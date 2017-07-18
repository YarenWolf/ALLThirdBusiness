//
//  WXGrammarWordlistView.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-1-23.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXGrammarWordlistView.h"

@interface WXGrammarWordlistView ()<UITextViewDelegate>

@end

@implementation WXGrammarWordlistView
{
    UITextView *_grammarTextView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _grammarTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, 100)];
        [self addSubview:_grammarTextView];
        [_grammarTextView release];
        _grammarTextView.text = @"单词 | 语法 | 老虎 ;";
        _grammarTextView.backgroundColor = [UIColor whiteColor];
        _grammarTextView.textColor = [UIColor blackColor];
        
    }
    return self;
}

- (NSString *)text{
    return _grammarTextView.text;
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
