//
//  UIColor+WXVoiceColor.m
//  WXVoiceSDKdemo
//
//  Created by GongYadong on 13-10-28.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "UIColor+WXVoiceColor.h"

@implementation UIColor (WXVoiceColor)

+ (UIColor *)colorWithWebColor:(NSInteger)webColor{
    NSInteger blue=webColor%256;
    webColor/=256;
    NSInteger green=webColor%256;
    webColor/=256;
    NSInteger red=webColor%256;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
}

@end
