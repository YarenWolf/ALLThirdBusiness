//
//  WXSpeechSynthesizerViewController.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-24.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "WXSpeechSynthesizerViewController.h"
#import "WXSpeechSynthesizerView.h"
#import "WXSpeechSynthesizer.h"
#import "WXSpeechSynthesizerPlayer.h"
#import "WXErrorMsg.h"
@interface WXSpeechSynthesizerViewController ()<WXSpeechSynthesizerViewDelegate,WXSpeechSynthesizerDelegate,WXSpeechSynthesizerPlayerDelegate>

@end

@implementation WXSpeechSynthesizerViewController
{
    WXSpeechSynthesizerPlayer *_player;
    WXSpeechSynthesizerView *_ssView;
    BOOL _isPause;
}


- (void)dealloc
{
    [_player release];
    [_ssView release];
    //[WXSpeechSynthesizer sharedSpeechSynthesizer].delegate=nil;
    [WXSpeechSynthesizer releaseSpeechSynthesizer];
    
    [super dealloc];
}

#pragma mark -----------WXSpeechSynthesizerDelegate------------

- (void)speechSynthesizerResultSpeechData:(NSData *)speechData speechFormat:(int)speechFormat{
    //amr格式无法直接播放，请自行转码
    [_player playNewData:speechData];
    if (_isPause) {
        [_player pause];
    }
}
- (void)speechSynthesizerMakeError:(NSInteger)error{
    [_ssView reSetView];
    [WXErrorMsg showErrorMsg:[NSString stringWithFormat:@"错误码：%d",(int)error] onView:self.view];
}
- (void)speechSynthesizerDidCancel{
    [_ssView reSetView];
}

#pragma mark -----------ViewDelegate------------
- (BOOL)startWithText:(NSString *)text{
    return [[WXSpeechSynthesizer sharedSpeechSynthesizer] startWithText:text];
}
- (void)pause{
    _isPause = YES;
    [_player pause];
}
- (void)play{
    _isPause = NO;
    [_player play];
}
- (void)reSet{
    _isPause = NO;
    [[WXSpeechSynthesizer sharedSpeechSynthesizer] cancel];
    [_player stop];
}
#pragma mark -----------PlayerDelegate------------
- (void)playerDidFinishPlaying{
    [_ssView reSetView];
}
- (void)playerError{
    [_ssView reSetView];
    [WXErrorMsg showErrorMsg:@"播放错误" onView:self.view];
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
    frame.size.height -= 64;
    _ssView = [[WXSpeechSynthesizerView alloc] initWithFrame:frame];
    _ssView.delegate = self;
    [self.view addSubview:_ssView];
    _player = [[WXSpeechSynthesizerPlayer alloc] init];
    _player.delegate = self;
    WXSpeechSynthesizer * speechSynthesizer = [WXSpeechSynthesizer sharedSpeechSynthesizer];
    [speechSynthesizer setDelegate:self];
    [speechSynthesizer setAppID:@"wxd9dbb2f20a952a5d"];
    [speechSynthesizer setVolumn:1.0];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
