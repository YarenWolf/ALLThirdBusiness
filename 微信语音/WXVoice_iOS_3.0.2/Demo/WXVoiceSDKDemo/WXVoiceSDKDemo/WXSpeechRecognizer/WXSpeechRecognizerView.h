//
//  WXSpeechRecognizerView.h
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//
@protocol WXSpeechRecognizerViewDelegate <NSObject>

- (BOOL)start;
- (void)finishRecorder;
- (void)cancel;

@end

#import <UIKit/UIKit.h>

@interface WXSpeechRecognizerView : UIView
{
    UITextView *_textView;
    UIButton *_button;
    UIButton *_reSetButton;
}
@property (nonatomic, assign) id<WXSpeechRecognizerViewDelegate>delegate;

@property (nonatomic, assign) CGRect resultFrame;
@property (nonatomic, assign) NSTextAlignment resultAlignment;

- (id)initWithFrame:(CGRect)frame;
- (void)setVolumn:(float)volumn;
- (void)finishRecorder;
- (void)setText:(NSString *)text;
- (void)setResultText:(NSString *)text;
- (void)setErrorCode:(NSInteger)errorCode;
- (void)didCancel;

@end
