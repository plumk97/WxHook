//
//  WxHook.mm
//  WxHook
//
//  Created by 李铁柱 on 2018/3/23.
//  Copyright (c) 2018年 ___ORGANIZATIONNAME___. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#import "WxHookApplication.h"
#import <Cycript/Cycript.h>
#import <CoreLocation/CoreLocation.h>

CHDeclareClass(UIApplication);
CHDeclareClass(MicroMessengerAppDelegate);


CHOptimizedMethod2(self, void, MicroMessengerAppDelegate, application, UIApplication *, application, didFinishLaunchingWithOptions, NSDictionary *, options)
{
    CHSuper2(MicroMessengerAppDelegate, application, application, didFinishLaunchingWithOptions, options);
    [WxHookApplication sharedInstance];
    CYListenServer(8883);
    
}
CHDeclareClass(MMLocationMgr);
CHMethod2(void, MMLocationMgr, locationManager, CLLocationManager *, manager, didUpdateLocations, NSArray<CLLocation *> *, locations) {
    CHSuper2(MMLocationMgr, locationManager, manager, didUpdateLocations, locations);
    locations = @[[[CLLocation alloc] initWithLatitude:116.4770709111 longitude:39.8760362340]];
}


CHConstructor {
    @autoreleasepool {
        CHLoadLateClass(MicroMessengerAppDelegate);
        CHHook2(MicroMessengerAppDelegate, application, didFinishLaunchingWithOptions);
        
        
        CHLoadLateClass(MMLocationMgr);
        CHClassHook2(MMLocationMgr, locationManager, didUpdateLocations);
    }
}
