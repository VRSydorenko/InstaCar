#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;

#pragma mark Capture Session Configuration

- (id)init {
    self = [super init];
	if (self) {
		self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        frontCamera = 0;
        backCamera = 0;
        captureInProgress = false;
        [self initCameras];
	}
	return self;
}

- (void)addVideoPreviewLayer {
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

-(void)initCameras{
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        DLog(@"Device name: %@", device.localizedName);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionBack) {
                DLog(@"Device position: back");
                backCamera = device;
            } else {
                DLog(@"Device position: front");
                frontCamera = device;
            }
        }
    }
}

-(AVCaptureConnection*)getVideoConnection{
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
		for (AVCaptureInputPort *port in connection.inputPorts) {
			if ([port.mediaType isEqual:AVMediaTypeVideo]) {
				return connection;
            }
        }
    }
    return nil;
}

- (void)addVideoInputFrontCamera:(BOOL)front {
    NSError *error = nil;
    
    AVCaptureDevice *captureDevice = front ? frontCamera : backCamera;
    if (captureDevice){
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!error) {
            [self clearInputs];
            //[self.captureSession removeInput:self.captureSession.inputs.lastObject];
            if ([self.captureSession canAddInput:deviceInput]) {
                [self.captureSession addInput:deviceInput];
                activeInputFront = front;
            } else {
                ALog(@"Couldn't add %@ facing video input", front ? @"front" : @"back");
            }
        }
    }
}

- (void)addLastVideoInput{
    [self addVideoInputFrontCamera:activeInputFront];
}

- (void)addStillImageOutput
{
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kCMVideoCodecType_JPEG], (NSString*)AVVideoCodecKey,
                                    [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (NSString*)kCVPixelBufferPixelFormatTypeKey,
                                    nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.captureSession addOutput:self.stillImageOutput];
}

- (void)captureStillImage{
	AVCaptureConnection *videoConnection = [self getVideoConnection];
    
	DLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
        completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            /*CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if (exifAttachments) {
                DLog(@"attachements: %@", exifAttachments);
            } else {
                DLog(@"no attachments");
            }*/
                               
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(imageSampleBuffer);
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

            // calculating rect for cropping
            CGFloat currentMinSideLength = MIN(ciImage.extent.size.width, ciImage.extent.size.height);
            CGFloat desiredSideLength = 918.0;
            CGRect screenRect = [UIScreen mainScreen].bounds;
            CGFloat topOffset = self.imageTopCropMargin * currentMinSideLength/MIN(screenRect.size.width, screenRect.size.height); // 'top' is 'right' here
            CGRect subImageRect = CGRectMake(topOffset, 0, currentMinSideLength, currentMinSideLength);
            
            ciImage = [ciImage imageByCroppingToRect:subImageRect];
            //ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI_2)];
                               
            CGFloat imageScale = currentMinSideLength/desiredSideLength;
            UIImageOrientation orientation = UIImageOrientationRight;
            if (activeInputFront){
                orientation = UIImageOrientationUp | UIImageOrientationLeftMirrored;
            }
            self.stillImage = [[UIImage alloc] initWithCIImage:ciImage scale:imageScale orientation:orientation];
            [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
        }
     ];
}

-(void) switchInputs{
    [self addVideoInputFrontCamera:!activeInputFront];
}

- (void)clearInputs{
    for (AVCaptureDeviceInput *input in self.captureSession.inputs) {
        [self.captureSession removeInput:input];
    }
}

- (void)dealloc {
	[self.captureSession stopRunning];
    
	previewLayer = nil;
	captureSession = nil;
    stillImageOutput = nil;
    stillImage = nil;
}

@end
