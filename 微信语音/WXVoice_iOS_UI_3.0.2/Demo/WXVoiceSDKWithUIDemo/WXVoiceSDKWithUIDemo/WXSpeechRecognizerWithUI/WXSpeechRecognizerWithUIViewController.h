//
//  WXSpeechRecognizerWithUIViewController.h
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-3-4.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXSpeechRecognizerWithUI.h"
#import "WXSpeechRecognizerWithUIView.h"

@interface WXSpeechRecognizerWithUIViewController : UIViewController
{
@public
    WXSpeechRecognizerWithUI *_wxssui;
    WXSpeechRecognizerWithUIView *_ctrView;
}
@end
