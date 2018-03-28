//
//  _MMServiceCenter.h
//  WxHook
//
//  Created by AQY on 2018/3/28.
//

#import <Foundation/Foundation.h>

@interface _MMServiceCenter : NSObject

+ (id)defaultCenter;
- (id)getService:(Class)service;
@end
