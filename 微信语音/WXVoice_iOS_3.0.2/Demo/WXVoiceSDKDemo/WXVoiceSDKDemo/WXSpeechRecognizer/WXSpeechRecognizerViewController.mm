//
//  WXSpeechRecognizerViewController.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "WXSpeechRecognizerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WXVoiceSDK.h"
@interface WXSpeechRecognizerViewController ()<WXSpeechRecognizerViewDelegate, WXVoiceDelegate>
{
    double _begainTime;
}
@end

@implementation WXSpeechRecognizerViewController

- (void)dealloc
{
    [_speechRecognizerView release];
    [WXVoiceSDK releaseWXVoice];
    [super dealloc];
}

#pragma mark -----------WXVoiceDelegate------------

- (void)voiceInputResultArray:(NSArray *)array{
    //一旦此方法被回调，array一定会有一个值，所以else的情况不会发生，但写了会更有安全感的
    if (array && array.count>0) {
        WXVoiceResult *result=[array objectAtIndex:0];
        [_speechRecognizerView setResultText:result.text];
    }else{
        [_speechRecognizerView setResultText:@""];
    }
}
- (void)voiceInputMakeError:(NSInteger)errorCode{
    NSLog(@"%d",errorCode);
    [_speechRecognizerView setErrorCode:errorCode];
}
- (void)voiceInputVolumn:(float)volumn{
    [_speechRecognizerView setVolumn:volumn];
}
- (void)voiceInputWaitForResult{
    [_speechRecognizerView finishRecorder];
}
- (void)voiceInputDidCancel{
    [_speechRecognizerView didCancel];
}

#pragma mark -----------ViewDelegate------------

- (BOOL)start{
    return [[WXVoiceSDK sharedWXVoice] startOnce];
}
- (void)finishRecorder{
    [[WXVoiceSDK sharedWXVoice] finish];
}
- (void)cancel{
    [[WXVoiceSDK sharedWXVoice] cancel];
}
#pragma mark ====================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -=64;
    
    _speechRecognizerView = [[WXSpeechRecognizerView alloc] initWithFrame:frame];
    _speechRecognizerView.delegate = self;
    [self.view addSubview:_speechRecognizerView];
    
    // SDK
    WXVoiceSDK *speechRecognizer = [WXVoiceSDK sharedWXVoice];
    //可选设置
    speechRecognizer.silTime = 1.5f;
    //必选设置
    speechRecognizer.delegate = self;
    
    [speechRecognizer setAppID:@"wxd9dbb2f20a952a5d"];
    
    [speechRecognizer setDomain:20];
    [speechRecognizer setMaxResultCount:3];
    [speechRecognizer setResultType:1];//1有标点，0无标点
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
