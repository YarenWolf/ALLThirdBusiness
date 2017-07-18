//
//  WXErrorMsg.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "WXErrorMsg.h"
#import "WXMsgView.h"
@implementation WXErrorMsg

+ (void)showErrorMsg:(NSString *)errorMsg onView:(UIView *)view{
    WXMsgView *msgView = [[WXMsgView alloc] initWithFrame:view.bounds];
    msgView.msgLabel.text = errorMsg;
    [view addSubview:msgView];
    
    [msgView release];
}

@end
