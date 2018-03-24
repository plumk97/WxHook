//
//  WxHookApplication.m
//  WxHook
//
//  Created by AQY on 2018/3/24.
//

#import "WxHookApplication.h"

@interface WxHookApplication () {
    HKSocketServer * _server;
}
@end
@implementation WxHookApplication

+ (instancetype)sharedInstance {
    
    static WxHookApplication * app = nil;
    if (app == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            app = [[WxHookApplication alloc] init];
        });
    }
    return app;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self applicationFinishLaunch];
    }
    return self;
}

- (void)dealloc {
}

// MARK: - Application Launch
- (void)applicationFinishLaunch {
    _server = [[HKSocketServer alloc] init];
    [_server acceptPort:9002];
}
@end
