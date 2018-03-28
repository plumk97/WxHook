//
//  WxHookContace.h
//  WxHook
//
//  Created by AQY on 2018/3/28.
//

#import <Foundation/Foundation.h>

@interface WxHookContace : NSObject

@property (nonatomic, readonly) NSString * m_nsUsrName;
@property (nonatomic, readonly) NSString * m_nsEncodeUserName;
@property (nonatomic, readonly) NSString * m_nsAliasName;
@property (nonatomic, readonly) NSString * m_uiConType;
@property (nonatomic, readonly) NSString * m_nsNickname;
@property (nonatomic, readonly) NSString * m_nsFullPY;
@property (nonatomic, readonly) NSString * m_nsShortPY;
@property (nonatomic, readonly) NSString * m_nsHeadImgUrl;
@property (nonatomic, assign, readonly) int m_uiSex;

@property (nonatomic, weak) id contact;
- (instancetype)initWithContact:(id)contact;
@end
