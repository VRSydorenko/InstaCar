#import <AVFoundation/AVFoundation.h>

#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

@interface CaptureSessionManager : NSObject {
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    bool activeInputFront;
    bool captureInProgress;
}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

@property int imageTopCropMargin; // status bar * navigation item height

- (void)addVideoPreviewLayer;
- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)addVideoInputFrontCamera:(BOOL)front;
- (void)addLastVideoInput;
- (void)clearInputs;
- (void)switchInputs;

@end
