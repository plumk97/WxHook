//
//  WxHookApplication.h
//  WxHook
//
//  Created by AQY on 2018/3/24.
//

#import <Foundation/Foundation.h>
#import "WxHookContace.h"

@interface WxHookApplication : NSObject

@property (nonatomic, readonly) WxHookContace * selfContact;

+ (instancetype)sharedInstance;
- (void)remoteLogWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
- (id)MMServiceCenter;
- (id)getService:(NSString *)serviceClass;

// MAKR: - Red Packet
@property (nonatomic, assign, readonly) NSInteger receiveRedPacketCount;
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, NSMutableDictionary *> * waitOpenRedPacketMessages;
- (void)addRedPacketMessage:(id)message;
- (void)OnWCToHongbaoCommonResponse:(id)response;
@end
