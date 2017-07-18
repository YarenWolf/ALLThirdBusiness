//
//  WXGrammarWordlistViewController.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-1-23.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXGrammarWordlistViewController.h"
#import "WXGrammarWordlistView.h"

#import "WXErrorMsg.h"
@interface WXGrammarWordlistViewController ()


@end

@implementation WXGrammarWordlistViewController
{
    UITextView *_grammarTextView;
}


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
    
    CGRect wordFrame = CGRectMake(10, 20, 300, 100);
    if ([UIScreen mainScreen].bounds.size.height>500) {
        _speechRecognizerView.resultFrame = CGRectMake(10, 120+80, 300, 80);
        wordFrame = CGRectMake(10, 20, 300, 100 + 80);
    }
    _speechRecognizerView.resultAlignment = NSTextAlignmentLeft;
    [_speechRecognizerView setText: @"识别结果："];
    
    _grammarTextView = [[UITextView alloc] initWithFrame:wordFrame];
    
    [self.view addSubview:_grammarTextView];
    [_grammarTextView release];
    
    _grammarTextView.text = [self defaultGrammarWords];
    _grammarTextView.font = [UIFont systemFontOfSize:20];
    
    _grammarTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _grammarTextView.textColor = [UIColor whiteColor];
    [_grammarTextView.layer setCornerRadius:10];
    

    

}
//重写开始方法
- (BOOL)start{
    return [[WXVoiceSDK sharedWXVoice] startOnceWithGrammarString:_grammarTextView.text andType:[self grammarType]];
}

//只有开始方法不一样，下面是一些界面上的微调，可以无视----
- (void)voiceInputResultArray:(NSArray *)array{
    if (array && array.count>0) {
        WXVoiceResult *result=[array objectAtIndex:0];
        [_speechRecognizerView setResultText:[NSString stringWithFormat:@"识别结果：%@", result.text]];
    }else{
        [_speechRecognizerView setResultText:@""];
    }
}

- (void)uploadData{
   
}
- (NSInteger)grammarType{
    return GrammarTypeOfWordlist;
}
- (NSString *)defaultGrammarWords{
    return @"崔大勺 | 张小萌 | 金秀贤 | 李若曦 | 杨不悔 | 叶宁远 | 丰云 | 刘星 ;";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_grammarTextView resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (void)addTestStr:(NSString *)str{
    NSLog(@"%@", str);

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
