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
#import <UIKit/UIKit.h>

#import "CaptainHook/CaptainHook.h"
#import "WxHookApplication.h"
#import <Cycript/Cycript.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "TDDebugWindow.h"

static void UncaughtExceptionHandler(NSException *exception) {
    HKLog(@"%@", exception);
}

CHDeclareClass(UIApplication);
CHDeclareClass(MicroMessengerAppDelegate);
CHOptimizedMethod2(self, void, MicroMessengerAppDelegate, application, UIApplication *, application, didFinishLaunchingWithOptions, NSDictionary *, options)
{
    CHSuper2(MicroMessengerAppDelegate, application, application, didFinishLaunchingWithOptions, options);
    [WxHookApplication sharedInstance];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    TDDebugWindow * dw = [[TDDebugWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    dw.windowLevel = UIWindowLevelAlert + 20;
    [dw setHidden:NO];

//    CYListenServer(8883);
}

CHDeclareClass(LocationRetriever);
CHOptimizedMethod2(self, void, LocationRetriever, onMapLocationChanged, id, arg1, withTag, long long, arg2) {
    
    NSString * latitude = [[NSUserDefaults standardUserDefaults] objectForKey:AppHookSDK_Location_latitude];
    NSString * longitude = [[NSUserDefaults standardUserDefaults] objectForKey:AppHookSDK_Location_longitude];
    
    if (latitude == nil) {
        CHSuper2(LocationRetriever, onMapLocationChanged, arg1, withTag, arg2);
        return;
    }
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    arg1 = location;
    CHSuper2(LocationRetriever, onMapLocationChanged, arg1, withTag, arg2);
}
CHOptimizedMethod2(self, void, LocationRetriever, onGPSLocationChanged, id, arg1, withTag, unsigned long long, arg2) {
    NSString * latitude = [[NSUserDefaults standardUserDefaults] objectForKey:AppHookSDK_Location_latitude];
    NSString * longitude = [[NSUserDefaults standardUserDefaults] objectForKey:AppHookSDK_Location_longitude];
    
    if (latitude == nil) {
        CHSuper2(LocationRetriever, onGPSLocationChanged, arg1, withTag, arg2);
        return;
    }
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    arg1 = location;
    CHSuper2(LocationRetriever, onGPSLocationChanged, arg1, withTag, arg2);
}

CHDeclareClass(CMessageMgr);
CHOptimizedMethod1(self, void, CMessageMgr, onNewSyncAddMessage, id, arg1) {
    CHSuper1(CMessageMgr, onNewSyncAddMessage, arg1);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[WxHookApplication sharedInstance] addRedPacketMessage:arg1];
    });
}
CHOptimizedMethod1(self, void, CMessageMgr, OnSendMessageSuccess, id, arg1) {
    CHSuper1(CMessageMgr, OnSendMessageSuccess, arg1);
}


CHDeclareClass(WCRedEnvelopesLogicMgr);
//CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, QueryRedEnvelopesDetailRequest, id, arg1) {
//    CHSuper1(WCRedEnvelopesLogicMgr, QueryRedEnvelopesDetailRequest, arg1);
//    [[WxHookApplication sharedInstance] remoteLogWithFormat:@"QueryRedEnvelopesDetailRequest : %@, %@", arg1, NSStringFromClass([arg1 class])];
//}
//CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, id, arg1) {
//    CHSuper1(WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, arg1);
//    [[WxHookApplication sharedInstance] remoteLogWithFormat:@"ReceiverQueryRedEnvelopesRequest : %@, %@", arg1, NSStringFromClass([arg1 class])];
//}

CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, id, arg1, Request, id , arg2) {
    CHSuper2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    [[WxHookApplication sharedInstance] OnWCToHongbaoCommonResponse:arg1];
}

//CHDeclareClass(BaseMsgContentViewController);
//CHOptimizedMethod0(self, id, BaseMsgContentViewController, GetMessagesWrapArray) {
//
//    id obj = CHSuper0(BaseMsgContentViewController, GetMessagesWrapArray);
//    if ([obj count] > 4) {
//        [[WxHookApplication sharedInstance] addRedPacketMessage:obj[2]];
//    }
////    for (id m in obj) {
////        HKLog(@"%p, %@", m, NSStringFromClass([m class]));
////    }
//    return obj;
//}

CHConstructor {
    @autoreleasepool {
        CHLoadLateClass(MicroMessengerAppDelegate);
        CHHook2(MicroMessengerAppDelegate, application, didFinishLaunchingWithOptions);
        
        CHLoadLateClass(LocationRetriever);
        CHHook2(LocationRetriever, onMapLocationChanged, withTag);
        CHHook2(LocationRetriever, onGPSLocationChanged, withTag);
        
        CHLoadLateClass(CMessageMgr);
        CHHook1(CMessageMgr, onNewSyncAddMessage);
        CHHook1(CMessageMgr, OnSendMessageSuccess);
        
        CHLoadLateClass(WCRedEnvelopesLogicMgr);
//        CHHook1(WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest);
//        CHHook1(WCRedEnvelopesLogicMgr, QueryRedEnvelopesDetailRequest);
        CHHook2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, Request);
        
//        CHLoadLateClass(BaseMsgContentViewController);
//        CHHook0(BaseMsgContentViewController, GetMessagesWrapArray);
    }
}
