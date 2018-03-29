//
//  WxHookApplication.h
//  WxHook
//
//  Created by AQY on 2018/3/24.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WxHookApplication : NSObject

+ (instancetype)sharedInstance;
- (void)remoteLogWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)pushHookSettingViewController;

- (id)MMServiceCenter;
- (id)getService:(NSString *)serviceClass;
- (id)selfContact;

// MAKR: - Red Packet
@property (nonatomic, assign) BOOL autoOpenRedPacket;
@property (nonatomic, assign, readonly) NSInteger receiveRedPacketCount;
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, NSMutableDictionary *> * waitOpenRedPacketMessages;
- (void)addRedPacketMessage:(id)message;
- (void)OnWCToHongbaoCommonResponse:(id)response;

// MARK: - Location
@property (nonatomic, assign) CLLocationCoordinate2D simulateLocationCoordinate;
@property (nonatomic, readonly) CLLocation * simulateLocation;
@end
