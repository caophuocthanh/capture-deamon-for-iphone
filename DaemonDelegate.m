//
//  DaemonDelegate.m
//  location
//
//  Created by IAV Tech on 1/12/15.
//  Copyright (c) 2015 com.iavtech. All rights reserved.
//

#import "DaemonDelegate.h"
#import  <notify.h>

#define PATH_IMAGE @"/tmp/captured.jpg"

@implementation DaemonDelegate

-(void)registerNotify:(const char*) identifier {
    NSLog(@"registerNotify");
    int notify_token;
    notify_register_dispatch(identifier,
                             &notify_token,
                             dispatch_get_main_queue(), ^(int t) {
                                 uint64_t state = UINT64_MAX;
                                 notify_get_state(notify_token, &state);
                                 [self hanleNotify];
                             });
}

-(id) init {
    if (self = [super init]) {
        [self initComponents];
        [self registerNotify:"daemon.captured"];
    }
    return self;
}

-(void) hanleNotify {
    NSLog(@"hanleNotify");
    [self capture];
}

-(void) initComponents {
    NSLog(@"initComponents");
    //AVCaptureSession *session;
    //AVCaptureStillImageOutput *stillImageOutput;
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ([session canAddInput:deviceInput]) {
      [session addInput:deviceInput];
    }
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    [session startRunning];
}

-(void)capture {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                      if (imageDataSampleBuffer != NULL) {
                                                          NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                          UIImage *image = [UIImage imageWithData:imageData];
                                                          NSLog(@"Save image at path:%@", PATH_IMAGE);
                                                          [UIImageJPEGRepresentation(image, 1.0) writeToFile:PATH_IMAGE atomically:YES];
                                                      }
                                                  }];
}


-(void) startDaemon:(NSTimer *) timer {
    NSLog(@"startDaemon");
    [timer invalidate];
}

@end
