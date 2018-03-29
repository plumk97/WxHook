//
//  WxHookApplication.m
//  WxHook
//
//  Created by AQY on 2018/3/24.
//

#import "WxHookApplication.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WxHookSettingViewController.h"


#define WxHook_AutoOpenRedPacket @"WxHook_AutoOpenRedPacket"
#define WxHook_SimulateLocationCoordinate @"WxHook_SimulateLocationCoordinate"

@interface WxHookApplication () {
    HKSocketServer * _server;
}
@end
@implementation WxHookApplication
@synthesize receiveRedPacketCount = _receiveRedPacketCount;
@synthesize waitOpenRedPacketMessages = _waitOpenRedPacketMessages;
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
        _waitOpenRedPacketMessages = [[NSMutableDictionary alloc] init];
        [self applicationFinishLaunch];
        
        _autoOpenRedPacket = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WxHook_AutoOpenRedPacket"] boolValue];
    
        NSString * coordinateStr = [[NSUserDefaults standardUserDefaults] objectForKey:WxHook_SimulateLocationCoordinate];
        if (coordinateStr != nil) {
            NSArray * components = [coordinateStr componentsSeparatedByString:@","];
            _simulateLocationCoordinate = CLLocationCoordinate2DMake([components[0] floatValue], [components[1] floatValue]);
            [self renewSimulateLocation];
        }
    }
    return self;
}

- (void)dealloc {
}

- (void)remoteLogWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
    
    va_list list;
    va_start(list, format);
    NSString * str = [[NSString alloc] initWithFormat:format arguments:list];
    va_end(list);
    
    HKSocketPacket * packet = [[HKSocketPacket alloc] init];
    packet.message = @{@"log" : str};
    [_server writePacket:packet];
}

- (void)pushHookSettingViewController {
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:[WxHookSettingViewController settingNavigationController] animated:YES completion:nil];
}

- (id)MMServiceCenter {
    return [NSClassFromString(@"MMServiceCenter") defaultCenter];
}

- (id)getService:(NSString *)serviceClass {
    return [[self MMServiceCenter] getService:[NSClassFromString(serviceClass) class]];
}

- (id)selfContact {
    
    id contact = [[self getService:@"CContactMgr"] getSelfContact];
    return contact;
}

// MARK: - Application Launch
- (void)applicationFinishLaunch {
    _server = [[HKSocketServer alloc] init];
    [_server acceptPort:9002];
}


// MAKR: - Red Packet
- (void)setAutoOpenRedPacket:(BOOL)autoOpenRedPacket {
    _autoOpenRedPacket = autoOpenRedPacket;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:autoOpenRedPacket] forKey:WxHook_AutoOpenRedPacket];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)addRedPacketMessage:(id)message {
    
    int type = [message m_uiMessageType];
    if (type == 49 && [self selfContact]) {
        
        NSString * m_nsContent = [message m_nsContent];
        // 已经领取过
        if ([m_nsContent rangeOfString:@"paysubtype"].length > 0) return;
        
        id selfContact = [self selfContact];
        NSString * nickname = [selfContact m_nsNickName];
        NSString * headImg = [selfContact m_nsHeadImgUrl];
        if (nickname == nil || headImg == nil) {
            return;
        }
        
        NSString *pattern = @"wxpay:.*?]";
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: nil error: &error];
        NSArray <NSTextCheckingResult *> *match = [regex matchesInString: m_nsContent options: NSMatchingCompleted range: NSMakeRange(0, [m_nsContent length])];
        if (match.count != 0) {
            NSTextCheckingResult * result = [match firstObject];
            NSString * wxpayStr = [m_nsContent substringWithRange:NSMakeRange(result.range.location, result.range.length - 1)];
            
            NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
            [params setObject:wxpayStr forKey:@"nativeUrl"];
            
            [params setObject:nickname forKey:@"nickName"];
            [params setObject:headImg forKey:@"headImg"];
            
            NSURLComponents * components = [NSURLComponents componentsWithURL:[NSURL URLWithString:wxpayStr] resolvingAgainstBaseURL:NO];
            for (NSURLQueryItem * item in [components queryItems]) {
                if ([item.name isEqualToString:@"channelid"]) {
                    [params setObject:[NSString stringWithFormat:@"%@", item.value] forKey:@"channelId"];
                }
                if ([item.name isEqualToString:@"msgtype"]) {
                    [params setObject:[NSString stringWithFormat:@"%@", item.value] forKey:@"msgType"];
                }
                if ([item.name isEqualToString:@"sendid"]) {
                    [params setObject:[NSString stringWithFormat:@"%@", item.value] forKey:@"sendId"];
                }
                if ([item.name isEqualToString:@"sendusername"]) {
                    [params setObject:[NSString stringWithFormat:@"%@", item.value] forKey:@"sessionUserName"];
                }
            }
            [_waitOpenRedPacketMessages setObject:params forKey:[params objectForKey:@"sendId"]];
            
            id redMgr = [self getService:@"WCRedEnvelopesLogicMgr"];
            NSMutableDictionary * requestParams = [[NSMutableDictionary alloc]
                                                   initWithDictionary:@{@"agreeDuty" : @"0",
                                                                        @"channelId" : [params objectForKey:@"channelId"],
                                                                        @"inWay" : @"1",
                                                                        @"msgType" : [params objectForKey:@"msgType"],
                                                                        @"nativeUrl" : [params objectForKey:@"nativeUrl"],
                                                                        @"sendId" : [params objectForKey:@"sendId"]}];
            [redMgr ReceiverQueryRedEnvelopesRequest:requestParams];
        }
    }
}

- (void)OnWCToHongbaoCommonResponse:(id)response {

    id retText = objc_msgSend(response, sel_getUid("retText"));
    NSData * buff = objc_msgSend(retText, sel_getUid("buffer"));
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:buff options:NSJSONReadingAllowFragments error:nil];
    if (json && [json isKindOfClass:[NSDictionary class]] && [[json objectForKey:@"retcode"] intValue] == 0 && [[json objectForKey:@"hbStatus"] intValue] == 2) {

        NSString * timingIdentifier = [json objectForKey:@"timingIdentifier"];
        NSString * sendId = [json objectForKey:@"sendId"];

        NSMutableDictionary * redPakcetDict = [self.waitOpenRedPacketMessages objectForKey:sendId];
        if (redPakcetDict) {
            [redPakcetDict setObject:timingIdentifier forKey:@"timingIdentifier"];
            id redMgr = [self getService:@"WCRedEnvelopesLogicMgr"];
            [redMgr OpenRedEnvelopesRequest:redPakcetDict];
            [self.waitOpenRedPacketMessages removeObjectForKey:sendId];
            
            _receiveRedPacketCount ++;
        }
    }
    
}

// MARK: - Location
@synthesize simulateLocation = _simulateLocation;
- (void)setSimulateLocationCoordinate:(CLLocationCoordinate2D)simulateLocationCoordinate {
    _simulateLocationCoordinate = simulateLocationCoordinate;
    [self renewSimulateLocation];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f,%f", simulateLocationCoordinate.latitude, simulateLocationCoordinate.longitude] forKey:WxHook_SimulateLocationCoordinate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)renewSimulateLocation {
    if (_simulateLocationCoordinate.longitude > 0 && _simulateLocationCoordinate.latitude > 0) {
        _simulateLocation = [[CLLocation alloc] initWithLatitude:_simulateLocationCoordinate.latitude longitude:_simulateLocationCoordinate.longitude];
    } else {
        _simulateLocation = nil;
    }
}

@end
