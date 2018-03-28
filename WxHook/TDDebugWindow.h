//
//  TDDebugWindow.h
//  TDChess-iPhone
//
//  Created by li on 16/11/1.
//  Copyright © 2016年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDDebugWindow : UIWindow

+ (void)outputDebugContent:(NSString *)content;
+ (void)clear;

@end
