//
//  TDDebugWindow.h
//  TDChess-iPhone
//
//  Created by li on 16/11/1.
//  Copyright © 2016年 li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDDebugWindow : UIWindow
    
+ (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);
+ (void)clear;
    
@end
