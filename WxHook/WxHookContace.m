//
//  WxHookContace.m
//  WxHook
//
//  Created by AQY on 2018/3/28.
//

#import "WxHookContace.h"
#import <objc/message.h>

@implementation WxHookContace

- (instancetype)initWithContact:(id)contact {
    self = [super init];
    if (self) {
        if (!contact) return nil;
        self.contact = contact;
    }
    return self;
}

- (NSString *)m_nsUsrName {
    return [self.contact m_nsUsrName];
}
- (NSString *)m_nsEncodeUserName {
    return [self.contact m_nsEncodeUserName];
}
- (NSString *)m_nsAliasName {
    return [self.contact m_nsAliasName];
}
- (NSString *)m_uiConType {
    return [self.contact m_uiConType];
}
- (NSString *)m_nsNickname {
    return [self.contact m_nsNickname];
}
- (NSString *)m_nsFullPY {
    return [self.contact m_nsFullPY];
}
- (NSString *)m_nsShortPY {
    return [self.contact m_nsShortPY];
}
- (NSString *)m_nsHeadImgUrl {
    return [self.contact m_nsHeadImgUrl];
}
- (int)m_uiSex {
    return [self.contact m_uiSex];
}


@end
