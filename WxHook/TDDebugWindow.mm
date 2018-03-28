//
//  TDDebugWindow.m
//  TDChess-iPhone
//
//  Created by li on 16/11/1.
//  Copyright © 2016年 li. All rights reserved.
//

#import "TDDebugWindow.h"

static TDDebugWindow * DebugWindow = nil;
@interface TDDebugWindow ()
@property (nonatomic, strong) UITextView * textView;
@end
@implementation TDDebugWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rootViewController = [[UIViewController alloc] init];
        [self.rootViewController.view addSubview:self.textView];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        DebugWindow = self;
    }
    return self;
}

- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.textColor = [UIColor redColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:11];
    }
    return _textView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.bounds = self.bounds;
}

+ (void)outputDebugContent:(NSString *)content {
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugWindow.textView.text = [DebugWindow.textView.text stringByAppendingFormat:@"%@\n",content];
        [DebugWindow.textView scrollRangeToVisible:NSMakeRange(DebugWindow.textView.text.length - 1, 0)];
    });
}

+ (void)clear {
    DebugWindow.textView.text = @"";
}

@end
