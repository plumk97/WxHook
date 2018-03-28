//
//  _CMessageWrap.h
//  WxHook
//
//  Created by AQY on 2018/3/28.
//

#import <Foundation/Foundation.h>

@interface _CMessageWrap : NSObject

@property(retain, nonatomic) NSString *m_nsContent;
@property(nonatomic) unsigned int m_uiMessageType;
- (id)GetDisplayContent;
@end
