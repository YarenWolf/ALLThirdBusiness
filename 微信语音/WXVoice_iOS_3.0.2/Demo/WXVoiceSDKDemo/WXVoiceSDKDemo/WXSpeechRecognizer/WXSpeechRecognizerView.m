//
//  WXSpeechRecognizerView.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#define StateOfReady    0
#define StateOfSpeaking 1
#define StateOfWaiting  2

#import "WXSpeechRecognizerView.h"

@implementation WXSpeechRecognizerView
{

    NSInteger _state;
    NSTimer *_timer;
    NSInteger _waitImageIndex;
    NSInteger _volumn;
    NSInteger _nowVolumn;
    
    

}
@synthesize delegate = _delegate;
@synthesize resultFrame = _resultFrame;
@synthesize resultAlignment = _resultAlignment;

- (void)dealloc
{
    
    [_textView release];
    [super dealloc];
}
- (void)removeFromSuperview{
    [_timer invalidate];
    _timer = nil;
    [super removeFromSuperview];
}

- (void)setVolumn:(float)volumn{
    //3-11
    if (_state == StateOfSpeaking) {
        if (volumn *3+3>_volumn) {
            _volumn = volumn *3+3;
        }
        
        if (_volumn>11) {
            _volumn = 11;
        }

    }
}

- (void)finishRecorder{
    _state = StateOfWaiting;
    if (_timer) {
        [_timer invalidate];
    }
    [self setText:@"识别中..."];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
}
- (void)timeUp{
    if (_state == StateOfSpeaking) {
        if (_volumn == 3 && _nowVolumn <5) {
            static int t = 4;
            t--;
            if (t == 0) {
                _nowVolumn = 7- _nowVolumn;
                t = 10;
            }
        } else {
            if (_volumn>_nowVolumn) {
                _nowVolumn+=1;
            } else if (_volumn<_nowVolumn) {
                _nowVolumn-=1;
            } else{
                _volumn = 3;
            }
        }
        NSString *imageName = [NSString stringWithFormat:@"voice%03d.png", _nowVolumn];
        [_button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
    } else if (_state == StateOfWaiting) {
        //wait 001-007
        _waitImageIndex = _waitImageIndex%7 + 1;
        [_button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"voice_wait%03d.png", _waitImageIndex]] forState:UIControlStateNormal];
    }
}
- (void)setText:(NSString *)text{

    [_textView removeFromSuperview];
    [_textView release];
    
    _textView = [[UITextView alloc] initWithFrame:self.resultFrame];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:20];
    _textView.editable = NO;
    _textView.userInteractionEnabled = NO;
    _textView.text = text;
    
    _textView.textAlignment = self.resultAlignment;

    [self addSubview:_textView];
}

- (void)setResultText:(NSString *)text{
    _state = StateOfReady;
    [_timer invalidate];
    _timer = nil;
    [_button setImage:[UIImage imageNamed:@"voice011.png"] forState:UIControlStateNormal];
    
    _reSetButton.enabled = NO;
    [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
    
    [self setText:text];
}


- (void)setErrorCode:(NSInteger)errorCode{
    _state = StateOfReady;
    [_timer invalidate];
    _timer = nil;
    [_button setImage:[UIImage imageNamed:@"voice011.png"] forState:UIControlStateNormal];
    
    _reSetButton.enabled = NO;
    [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
    if (self.resultAlignment == NSTextAlignmentLeft) {
        [self setResultText:[NSString stringWithFormat:@"ErrorCode = %d", errorCode]];
    } else {
        [self setResultText:[NSString stringWithFormat:@"ErrorCode = %d\n点击重新开始", errorCode]];
    }
}
- (void)didCancel{
    _state = StateOfReady;
    [_timer invalidate];
    _timer = nil;
    _reSetButton.enabled = NO;
    [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
    _button.enabled = YES;
    [_button setImage:[UIImage imageNamed:@"voice011.png"] forState:UIControlStateNormal];
    if (self.resultAlignment == NSTextAlignmentLeft) {
        [self setText:@"已取消"];;
    } else {
        [self setText:@"已取消\n点击重新开始"];
    }
    
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
        
        self.resultFrame = CGRectMake(10, 120, 300, 80);
        self.resultAlignment = NSTextAlignmentCenter;
        
        [self setText:@"点击开始说话"];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(105, frame.size.height-220, 110, 110);
        [_button setImage:[UIImage imageNamed:@"voice011.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        
        _reSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reSetButton.frame = CGRectMake(225, frame.size.height-220+55, 55, 55);
        _reSetButton.enabled = NO;
        [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
        [_reSetButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reSetButton];
    }
    return self;
}
- (void)clickedButton:(UIButton *)btn{
    if (btn == _reSetButton) {
        if (_state != StateOfReady) {
            _reSetButton.enabled = NO;
            [_reSetButton setImage:[UIImage imageNamed:@"reset001.png"] forState:UIControlStateNormal];
            _button.enabled = NO;
            [_button setImage:[UIImage imageNamed:@"voice001.png"] forState:UIControlStateNormal];
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            [self setText:@"正在取消..."];
            [_delegate cancel];
        }
        return;
    }
    if (_state == StateOfReady) {
        if ([_delegate start]) {
            _state = StateOfSpeaking;
            _nowVolumn = 3;
            _volumn = 3;
            _reSetButton.enabled = YES;
            [_reSetButton setImage:[UIImage imageNamed:@"reset002.png"] forState:UIControlStateNormal];
            [self setText:@"语音已开启，请说话..."];
            if (_timer) {
                [_timer invalidate];
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
        }
    } else if (_state == StateOfSpeaking) {
        [_delegate finishRecorder];
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

@end
