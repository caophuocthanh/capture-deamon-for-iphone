//
//  IAVAppDelegate.h
//  springbroadd
//
//  Created by IAV Tech on 1/12/15.
//  Copyright (c) 2015 com.iavtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DaemonDelegate : UIResponder <UIApplicationDelegate> {
	AVCaptureSession *session;
	AVCaptureStillImageOutput *stillImageOutput;
}

-(void) startDaemon:(NSTimer *) timer;

@end
