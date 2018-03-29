//
//  WxHookSettingTableViewCell.h
//  LingLi
//
//  Created by AQY on 2018/3/29.
//  Copyright © 2018年 LingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WxHookSettingModelType) {
    WxHookSettingModelTypeNormal = 0,
    WxHookSettingModelTypeSwitch,
};

@class WxHookSettingTableViewCell;
@interface WxHookSettingModel : NSObject

@property (nonatomic, assign) WxHookSettingModelType modelType;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * desc;

@property (nonatomic, copy) void (^resetCellWidgetProperty) (WxHookSettingTableViewCell * cell);
@end

@protocol WxHookSettingTableViewCellDelegate;
@interface WxHookSettingTableViewCell : UITableViewCell

@property (nonatomic, weak) WxHookSettingModel * model;
@property (nonatomic, strong) UISwitch * onSwitch;
@property (nonatomic, weak) id <WxHookSettingTableViewCellDelegate> delegate;
@end

@protocol WxHookSettingTableViewCellDelegate <NSObject>
- (void)wxHookSettingTableViewCell:(WxHookSettingTableViewCell *)cell onSwitchChanged:(BOOL)isOn;
@end
