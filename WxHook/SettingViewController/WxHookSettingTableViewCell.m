//
//  WxHookSettingTableViewCell.m
//  LingLi
//
//  Created by AQY on 2018/3/29.
//  Copyright © 2018年 LingLi. All rights reserved.
//

#import "WxHookSettingTableViewCell.h"

@implementation WxHookSettingModel
@end

@implementation WxHookSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.onSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self.onSwitch addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setModel:(WxHookSettingModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    
    if (model.modelType == WxHookSettingModelTypeNormal) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (model.modelType == WxHookSettingModelTypeSwitch) {
        self.accessoryView = self.onSwitch;
    }
    
    if (model.resetCellWidgetProperty) {
        model.resetCellWidgetProperty(self);
    }
}


- (void)prepareForReuse {
    [super prepareForReuse];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
}

- (void)onSwitchChanged:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(wxHookSettingTableViewCell:onSwitchChanged:)]) {
        [self.delegate wxHookSettingTableViewCell:self onSwitchChanged:sender.isOn];
    }
}


@end
