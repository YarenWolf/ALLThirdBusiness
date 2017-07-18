//
//  WXSpeechRecognizerWithUIView.m
//  WXVoiceSDKWithUIDemo
//
//  Created by 宫亚东 on 14-3-18.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXSpeechRecognizerWithUIView.h"

@implementation WXSpeechRecognizerWithUIView
{
    UITextView *_resultTextView;
}
- (void)dealloc
{
    [_resultTextView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_320x568.png"]];
        iv.frame = CGRectMake(0, 0, 320, 568);
        [self addSubview:iv];
        [iv release];
        
        _resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 120, 300, 80)];
        _resultTextView.backgroundColor = [UIColor clearColor];
        _resultTextView.textColor = [UIColor whiteColor];
        _resultTextView.font = [UIFont systemFontOfSize:20];
        _resultTextView.editable = NO;
        _resultTextView.userInteractionEnabled = NO;
        _resultTextView.text = @"";
        _resultTextView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_resultTextView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(105, frame.size.height-220, 110, 110);
        [btn setImage:[UIImage imageNamed:@"voice011.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)clickedButton:(UIButton *)btn{
    [_delegate clickedStartBtn];
}

- (void)setText:(NSString *)text{
    _resultTextView.text = text;
}

- (void)setResultFrame:(CGRect)frame{
    _resultTextView.frame = frame;
}
- (void)setResultTextAlignment:(NSTextAlignment)alignment{
    _resultTextView.textAlignment = alignment;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
