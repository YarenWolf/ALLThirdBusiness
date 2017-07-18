//
//  WXSpeechSynthesizerView.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#define StateOfReady    0
#define StateOfPlaying  1
#define StateOfPause    2
#define StateOfCanceling 3

#import "WXSpeechSynthesizerView.h"

@interface WXSpeechSynthesizerView ()<UITextViewDelegate>


@end

@implementation WXSpeechSynthesizerView

- (void)dealloc
{
    [_textView release];
    [_testView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _state = StateOfReady;
        
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_320x568.png"]];
        iv.frame = CGRectMake(0, 0, 320, 568);
        [self addSubview:iv];
        [iv release];
        
        float buttonY;
        float textViewHeight;
        if (frame.size.height>500) {
            buttonY = frame.size.height-220;
            textViewHeight = frame.size.height-250;
        } else {
            buttonY = frame.size.height-180;
            textViewHeight = frame.size.height-230;
        }
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 280, textViewHeight)];
        _textView.delegate = self;
        _textView.text = @"微信语音开放平台，免费给移动开发者提供语音云服务，目前开放的有语音识别、语音合成等。其中语音识别可以让有文字输入的地方用语音输入来代替，准确率达90%以上；语音合成支持把文字合成甜美女声。从此让你的用户与手机自由语音交互，体验别致的移动生活！";
        _textView.font = [UIFont systemFontOfSize:20];
        _textView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _textView.textColor = [UIColor blackColor];
        [self addSubview:_textView];
        
        _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playerButton.frame = CGRectMake(105, buttonY, 110, 110);
        [_playerButton setImage:[UIImage imageNamed:@"play002.png"] forState:UIControlStateNormal];
        [_playerButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playerButton];

        
        _reSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reSetButton.frame = CGRectMake(225, buttonY+55, 55, 55);
        [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
        [_reSetButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reSetButton];
        
        _testView = [[UITextView alloc] initWithFrame:CGRectMake(0, textViewHeight+30, 320, 200)];
        _testView.backgroundColor = [UIColor clearColor];
        _testView.userInteractionEnabled = NO;
        _testView.scrollEnabled = YES;
        [self addSubview:_testView];
        
    }
    return self;
}

- (void)clickedButton:(UIButton *)btn{
    if (btn == _reSetButton) {
        _state = StateOfCanceling;
        _reSetButton.enabled = NO;
        [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
        
        _playerButton.enabled = NO;
        [_playerButton setImage:[UIImage imageNamed:@"play001.png"] forState:UIControlStateNormal];
        
        [_delegate reSet];
    } else {
        if (_state == StateOfReady) {
            if ([_delegate startWithText:_textView.text]) {
                _state = StateOfPlaying;
                [self setTextViewCanEdit:NO];
                [_playerButton setImage:[UIImage imageNamed:@"pause002.png"] forState:UIControlStateNormal];
                _reSetButton.enabled = YES;
                [_reSetButton setImage:[UIImage imageNamed:@"reset002.png"] forState:UIControlStateNormal];
            }
        } else if (_state == StateOfPlaying) {
            _state = StateOfPause;
            [_playerButton setImage:[UIImage imageNamed:@"play002.png"] forState:UIControlStateNormal];
            [_delegate pause];
        } else if (_state == StateOfPause) {
            _state = StateOfPlaying;
            [_playerButton setImage:[UIImage imageNamed:@"pause002.png"] forState:UIControlStateNormal];
            [_delegate play];
        }
    }
}

- (void)reSetView{
    [self setTextViewCanEdit:YES];
    _state = StateOfReady;
    _playerButton.enabled = YES;
    [_playerButton setImage:[UIImage imageNamed:@"play002.png"] forState:UIControlStateNormal];
    _reSetButton.enabled = NO;
    [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_textView resignFirstResponder];
}



- (void)addTestStr:(NSString *)str{
    _testView.text = [_testView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",str]];
    NSRange range = NSMakeRange(_testView.text.length, 0);
    [_testView scrollRangeToVisible:range];
}

- (void)setText:(NSString *)text{
    _textView.text = text;
}
- (void)selectRange:(NSRange)range{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_textView.text];
    [attStr addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    _textView.attributedText = attStr;
    [attStr release];
    [_textView setFont:[UIFont systemFontOfSize:30]];
    if (_textView.editable == NO) {
        _textView.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    [_textView scrollRangeToVisible:range];
}
- (void)setTextViewCanEdit:(BOOL)canEdit{
    _textView.editable = canEdit;
    //_textView.selectable = canEdit;   //只有iOS7能用
    if (canEdit) {
        _textView.textColor = [UIColor blackColor];
    } else {
        _textView.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//为了方便长文本合成时也可以使用这个view而多加的接口，忽略即可
- (UITextView *)textView{
    return _textView;
}
@end
