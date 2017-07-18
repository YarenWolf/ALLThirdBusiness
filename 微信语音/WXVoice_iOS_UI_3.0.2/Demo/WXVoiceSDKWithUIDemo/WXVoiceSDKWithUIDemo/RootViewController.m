//
//  RootViewController.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-24.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "RootViewController.h"

#import "WXSpeechSynthesizerViewController.h"
#import "WXGrammarWordlistViewController.h"
#import "WXGrammarABNFViewController.h"
#import "WXSpeechRecognizerWithUIViewController.h"

//test
#import "WXSpeechSynthesizerViewControllerForLongText.h"


@interface RootViewController ()
{
}
@end

@implementation RootViewController
- (void)dealloc
{
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
    
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_320x568.png"]];
    iv.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:iv];
    [iv release];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320, 52);
    [btn setImage:[UIImage imageNamed:@"lb_btn1.png"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    btn.tag = 101;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 52, 320, 52);
    [btn setImage:[UIImage imageNamed:@"lb_btn2.png"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    btn.tag = 102;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 104, 320, 52);
    [btn setImage:[UIImage imageNamed:@"lb_btn3.png"] forState:UIControlStateNormal];
     [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
      btn.tag = 103;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 156, 320, 52);
    [btn setImage:[UIImage imageNamed:@"lb_btn4.png"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
       btn.tag = 104;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.navigationItem.backBarButtonItem setTitle:@"后退"];
    [self.navigationItem setTitle:@"微信语音"];
}

- (void)clickedBtn:(UIButton *)btn{
    UIViewController *vc;
    if (btn.tag == 101) {
        vc = [[[WXSpeechRecognizerWithUIViewController alloc] init] autorelease];
        [vc.navigationItem setTitle:@"语音识别"];
    } else if (btn.tag == 102) {
        vc = [[[WXSpeechSynthesizerViewController alloc] init] autorelease];
        [vc.navigationItem setTitle:@"语音合成"];
    } else if (btn.tag == 103) {
//        return;
        vc = [[[WXGrammarWordlistViewController alloc] init] autorelease];
        [vc.navigationItem setTitle:@"词表识别"];
    } else if (btn.tag == 104) {
//        return;
        vc = [[[WXGrammarABNFViewController alloc] init] autorelease];
        [vc.navigationItem setTitle:@"ABNF语法识别"];
    } else {
        vc = [[[WXSpeechRecognizerWithUIViewController alloc] init] autorelease];
        [vc.navigationItem setTitle:@"有UI的识别"];

    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        vc.extendedLayoutIncludesOpaqueBars = NO;
        vc.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }

    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
