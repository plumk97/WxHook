//
//  WxHookApplication.m
//  WxHook
//
//  Created by AQY on 2018/3/24.
//

#import "WxHookApplication.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "_CWxHeaders.h"

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

- (id)MMServiceCenter {
    return [NSClassFromString(@"MMServiceCenter") defaultCenter];
}

- (id)getService:(NSString *)serviceClass {
    return [[self MMServiceCenter] getService:[NSClassFromString(serviceClass) class]];
}

@synthesize selfContact = _selfContact;
- (WxHookContace *)selfContact {
    
    id contact = [[self getService:@"CContactMgr"] getSelfContact];
    if (!contact) {
        _selfContact = nil;
        return nil;
    }
    if (_selfContact == nil) {
        _selfContact = [[WxHookContace alloc] initWithContact:contact];
    }
    return _selfContact;
}

// MARK: - Application Launch
- (void)applicationFinishLaunch {
    _server = [[HKSocketServer alloc] init];
    [_server acceptPort:9002];
}


// MAKR: - Red Packet
/*
 channelId = 1;
 headImg = "http://wx.qlogo.cn/mmhead/ver_1/TrmeHic3OV5CjWONq6YoZRibiaPSqroESzmIIFTkiag19TTHVicqn2l0QsWWziclGxiajEiaLTHTjpQ2GVQia3KEoVibibxicmErmt0ObsZDCay8Ndyt4xs/132";
 msgType = 1;
 nativeUrl = "wxpay://c2cbizmessagehandler/hongbao/receivehongbao?msgtype=1&channelid=1&sendid=1000039401201803276024877749882&sendusername=wxid_uo39614r0xwy22&ver=6&sign=b05042743978bace356d3fdddf4da46a1298dd023c993e3445ba648490f73d55b4ec2360e7a2d0300f2ea383d7cfc453fa92f9264ef2b33141be54f766b23da30a50fadab054ff450ea13d826a775656";
 nickName = Ayo;
 sendId = 1000039401201803276024877749882;
 sessionUserName = "wxid_uo39614r0xwy22";
 timingIdentifier = C66C0FE11792FBBA10CD30EA907CB2
 */

- (void)addRedPacketMessage:(id)message {
    
    int type = [message m_uiMessageType];
    if (type == 49 && [self selfContact]) {
        
       
        NSString * m_nsContent = [message m_nsContent];
        // 已经领取过
        if ([m_nsContent rangeOfString:@"paysubtype"].length > 0) return;
        
        NSString *pattern = @"wxpay:.*?]";
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: nil error: &error];
        NSArray <NSTextCheckingResult *> *match = [regex matchesInString: m_nsContent options: NSMatchingCompleted range: NSMakeRange(0, [m_nsContent length])];
        if (match.count != 0) {
            NSTextCheckingResult * result = [match firstObject];
            NSString * wxpayStr = [m_nsContent substringWithRange:NSMakeRange(result.range.location, result.range.length - 1)];
            
            NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
            [params setObject:wxpayStr forKey:@"nativeUrl"];
            
            [params setObject:@"Ayo" forKey:@"nickName"];
            [params setObject:@"http://wx.qlogo.cn/mmhead/ver_1/TrmeHic3OV5CjWONq6YoZRibiaPSqroESzmIIFTkiag19TTHVicqn2l0QsWWziclGxiajEiaLTHTjpQ2GVQia3KEoVibibxicmErmt0ObsZDCay8Ndyt4xs/132" forKey:@"headImg"];
            
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
                                                   initWithDictionary:@{@"agreeDuty" : @"1",
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
            [TDDebugWindow clear];
            [TDDebugWindow outputDebugContent:[NSString stringWithFormat:@"已经领取: %d", self.receiveRedPacketCount]];
        }
    }
    
}



@end
