//
//  _CContact.h
//  WxHook
//
//  Created by AQY on 2018/3/28.
//

#import <Foundation/Foundation.h>

@interface _CContact : NSObject

@property(retain, nonatomic) NSString *m_nsNickName;
@property(strong, nonatomic) NSDictionary *externalInfoJSONCache; // @synthesize externalInfoJSONCache=_externalInfoJSONCache;
@property(strong, nonatomic) NSString *m_nsDisplayNamePY; // @synthesize m_nsDisplayNamePY;
@property(strong, nonatomic) NSString *m_nsAntispamTicket; // @synthesize m_nsAntispamTicket;
@property(strong, nonatomic) NSString *m_nsShortPY; // @synthesize m_nsShortPY;
@property(strong, nonatomic) NSString *m_nsAtUserList; // @synthesize m_nsAtUserList;
@property(nonatomic) unsigned int m_uiDraftTime; // @synthesize m_uiDraftTime;
@property(nonatomic) unsigned int m_uiFriendScene; // @synthesize m_uiFriendScene;
@property(strong, nonatomic) NSString *m_nsMobileIdentify; // @synthesize m_nsMobileIdentify;
@property(nonatomic) unsigned int m_uiQQUin; // @synthesize m_uiQQUin;
@property(nonatomic) unsigned int m_uiExtKeyAtLastGet; // @synthesize m_uiExtKeyAtLastGet;
@property(nonatomic) unsigned int m_uiImgKeyAtLastGet; // @synthesize m_uiImgKeyAtLastGet;
@property(nonatomic) unsigned int m_uiExtKey; // @synthesize m_uiExtKey;
@property(nonatomic) unsigned int m_uiImgKey; // @synthesize m_uiImgKey;
@property(strong, nonatomic) NSString *m_nsDraft; // @synthesize m_nsDraft;
@property(strong, nonatomic) NSString *m_nsHeadHDMd5; // @synthesize m_nsHeadHDMd5;
@property(strong, nonatomic) NSString *m_nsHeadHDImgUrl; // @synthesize m_nsHeadHDImgUrl;
@property(strong, nonatomic) NSString *m_nsHeadImgUrl; // @synthesize m_nsHeadImgUrl;
@property(strong, nonatomic) NSString *m_nsHDImgStatus; // @synthesize m_nsHDImgStatus;
@property(strong, nonatomic) NSString *m_nsImgStatus; // @synthesize m_nsImgStatus;
@property(strong, nonatomic) NSData *m_dtUsrImg; // @synthesize m_dtUsrImg;
@property(nonatomic) unsigned int m_uiChatState; // @synthesize m_uiChatState;
@property(nonatomic) unsigned int m_uiType; // @synthesize m_uiType;
@property(nonatomic) unsigned int m_uiSex; // @synthesize m_uiSex;
@property(strong, nonatomic) NSString *m_nsRemarkPYFull; // @synthesize m_nsRemarkPYFull;
@property(strong, nonatomic) NSString *m_nsRemarkPYShort; // @synthesize m_nsRemarkPYShort;
@property(strong, nonatomic) NSString *m_nsRemark; // @synthesize m_nsRemark;
@property(strong, nonatomic) NSString *m_nsFullPY; // @synthesize m_nsFullPY;
@property(nonatomic) unsigned int m_uiConType; // @synthesize m_uiConType;
@property(strong, nonatomic) NSString *m_nsAliasName; // @synthesize m_nsAliasName;
@property(strong, nonatomic) NSString *m_nsEncodeUserName; // @synthesize m_nsEncodeUserName;
@property(strong, nonatomic) NSString *m_nsUsrName; // @synthesize m_nsUsrName;

@end
