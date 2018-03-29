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
#import <objc/runtime.h>

static void UncaughtExceptionHandler(NSException *exception) {
    HKLog(@"%@", exception);
}

// MARK: - MicroMessengerAppDelegate

CHDeclareClass(MicroMessengerAppDelegate);
CHOptimizedMethod2(self, void, MicroMessengerAppDelegate, application, UIApplication *, application, didFinishLaunchingWithOptions, NSDictionary *, options)
{
    CHSuper2(MicroMessengerAppDelegate, application, application, didFinishLaunchingWithOptions, options);
    [WxHookApplication sharedInstance];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
//    TDDebugWindow * dw = [[TDDebugWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    dw.windowLevel = UIWindowLevelAlert + 20;
//    [dw setHidden:NO];
//    [TDDebugWindow logWithFormat:@"MicroMessengerAppDelegate"];
    
//    CYListenServer(8883);
}

// MARK: - LocationRetriever
CHDeclareClass(LocationRetriever);
CHOptimizedMethod2(self, void, LocationRetriever, onMapLocationChanged, id, arg1, withTag, long long, arg2) {
    
    CLLocation * simulateLocation = [WxHookApplication sharedInstance].simulateLocation;
    if (simulateLocation == nil) {
        CHSuper2(LocationRetriever, onMapLocationChanged, arg1, withTag, arg2);
        return;
    }
    
    arg1 = simulateLocation;
    CHSuper2(LocationRetriever, onMapLocationChanged, arg1, withTag, arg2);
}
CHOptimizedMethod2(self, void, LocationRetriever, onGPSLocationChanged, id, arg1, withTag, unsigned long long, arg2) {

    CLLocation * simulateLocation = [WxHookApplication sharedInstance].simulateLocation;
    if (simulateLocation == nil) {
        CHSuper2(LocationRetriever, onGPSLocationChanged, arg1, withTag, arg2);
        return;
    }
    
    arg1 = simulateLocation;
    CHSuper2(LocationRetriever, onGPSLocationChanged, arg1, withTag, arg2);
}

// MARK: - CMessageMgr
CHDeclareClass(CMessageMgr);
CHOptimizedMethod1(self, void, CMessageMgr, onNewSyncAddMessage, id, arg1) {
    CHSuper1(CMessageMgr, onNewSyncAddMessage, arg1);
    if ([WxHookApplication sharedInstance].autoOpenRedPacket) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[WxHookApplication sharedInstance] addRedPacketMessage:arg1];
        });
    }
}
CHOptimizedMethod1(self, void, CMessageMgr, OnSendMessageSuccess, id, arg1) {
    CHSuper1(CMessageMgr, OnSendMessageSuccess, arg1);
}


CHOptimizedMethod2(self, void, CMessageMgr, AddLocalMsg, id, arg1, MsgWrap, id, arg2) {
    
    NSString *str = [arg2 GetDisplayContent];
    NSString *pattern = @"你领取了.*红包";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: nil error: &error];
    NSArray *match = [regex matchesInString: str options: NSMatchingCompleted range: NSMakeRange(0, [str length])];
    if (match.count != 0) {
        // ...
        return;
    } else {
        CHSuper2(CMessageMgr, AddLocalMsg, arg1, MsgWrap, arg2);
    }
}

// MARK: - WCRedEnvelopesLogicMgr
CHDeclareClass(WCRedEnvelopesLogicMgr);
CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, id, arg1, Request, id , arg2) {
    CHSuper2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    [[WxHookApplication sharedInstance] OnWCToHongbaoCommonResponse:arg1];
}


// MARK: - NewSettingViewController
CHDeclareClass(NewSettingViewController);
CHOptimizedMethod0(self, void, NewSettingViewController, viewDidLoad) {
    //self.navigationItem.rightBarButtonItem
    //UIBarButtonItem
    CHSuper0(NewSettingViewController, viewDidLoad);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Hook" style:UIBarButtonItemStylePlain target:[WxHookApplication sharedInstance] action:@selector(pushHookSettingViewController)];
    id obj = self;
    [[obj navigationItem] setRightBarButtonItem: item];
}

//CHDeclareClass(BaseMsgContentViewController);
//CHOptimizedMethod0(self, id, BaseMsgContentViewController, GetMessagesWrapArray) {
//    id obj = CHSuper0(BaseMsgContentViewController, GetMessagesWrapArray);
//    return obj;
//}

// MARK: - CHConstructor
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
        CHHook2(CMessageMgr, AddLocalMsg, MsgWrap);
        
        CHLoadLateClass(WCRedEnvelopesLogicMgr);
        CHHook2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, Request);
        
        CHLoadLateClass(NewSettingViewController);
        CHHook0(NewSettingViewController, viewDidLoad);
        
//        CHLoadLateClass(BaseMsgContentViewController);
//        CHHook0(BaseMsgContentViewController, GetMessagesWrapArray);
    }
}
