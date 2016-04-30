
#import <UIKit/UIKit.h>
#import "DaemonDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        //Start a pool
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

        //initialize our LocationManager delegate so we can pick up GPS information
        DaemonDelegate* delegate = [[DaemonDelegate alloc] init];

        //start a timer so that the process does not exit, this will GPS time to fetch and come back.
        NSDate *now = [[NSDate alloc] init];
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:now
                                                  interval:1.0
                                                    target:delegate
                                                  selector:@selector(startDaemon:)
                                                  userInfo:nil
                                                   repeats:NO];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];

        [runLoop run];
        NSLog(@"Finished Everything, now closing");
        return 0;
    }
}


