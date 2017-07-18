//
//  WXSpeechRecognizerWithUIViewController.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-3-4.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXSpeechRecognizerWithUIViewController.h"

@interface WXSpeechRecognizerWithUIViewController ()<WXVoiceWithUIDelegate,WXSpeechRecognizerWithUIViewDelegate>

@end

@implementation WXSpeechRecognizerWithUIViewController

- (void)dealloc
{
    [_ctrView release];
    [_wxssui release];
    [super dealloc];
}
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
    
    //VIEW
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -=64;
    
    _ctrView = [[WXSpeechRecognizerWithUIView alloc] initWithFrame:frame];
    _ctrView.delegate = self;
    [_ctrView setText:@"点击开始说话"];
    [self.view addSubview:_ctrView];
    
    //SDK
    _wxssui = [[WXSpeechRecognizerWithUI alloc] initWithDelegate:self andAppID:@"wxd9dbb2f20a952a5d"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)clickedStartBtn{
    [_ctrView setText:@""];
    return [_wxssui showAndStart];
}
- (void)voiceInputResultArray:(NSArray *)array{
    WXVoiceResult *result=[array objectAtIndex:0];
    [_ctrView setText:result.text];
}

//如果允许旋转的话，请在允许旋转的方向上调用[_wxssui orientationChanged]
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    if (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
//        [_wxssui orientationChanged];
//        return YES;
//    }
//    return NO;
//}
//- (BOOL)shouldAutorotate{
//    return YES;
//}
//- (NSUInteger)supportedInterfaceOrientations{
//    [_wxssui orientationChanged];
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}


@end
