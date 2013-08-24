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
	}
	return self;
}

- (void)addVideoPreviewLayer {
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)addVideoInputFrontCamera:(BOOL)front {
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        NSLog(@"Device name: %@", device.localizedName);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionBack) {
                NSLog(@"Device position: back");
                backCamera = device;
            } else {
                NSLog(@"Device position: front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    
    if (front) {
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            [self clearInputs];
            //[self.captureSession removeInput:self.captureSession.inputs.lastObject];
            if ([self.captureSession canAddInput:frontFacingCameraDeviceInput]) {
                [self.captureSession addInput:frontFacingCameraDeviceInput];
                activeInputFront = YES;
            } else {
                NSLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            [self clearInputs];
            //[self.captureSession removeInput:self.captureSession.inputs.lastObject];
            if ([self.captureSession canAddInput:backFacingCameraDeviceInput]) {
                [self.captureSession addInput:backFacingCameraDeviceInput];
                activeInputFront = NO;
            } else {
                NSLog(@"Couldn't add back facing video input");
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
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([port.mediaType isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [self.captureSession addOutput:self.stillImageOutput];
}

- (void)captureStillImage{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
		for (AVCaptureInputPort *port in connection.inputPorts) {
			if ([port.mediaType isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
    
	NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                           completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                               CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                               if (exifAttachments) {
                                   NSLog(@"attachements: %@", exifAttachments);
                               } else {
                                   NSLog(@"no attachments");
                               }
                               NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                               self.stillImage = [[UIImage alloc] initWithData:imageData];
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
