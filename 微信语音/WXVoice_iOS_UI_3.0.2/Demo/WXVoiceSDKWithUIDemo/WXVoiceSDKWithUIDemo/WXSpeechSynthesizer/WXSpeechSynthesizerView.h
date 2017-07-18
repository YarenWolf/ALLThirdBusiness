//
//  WXSpeechSynthesizerView.h
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

@protocol WXSpeechSynthesizerViewDelegate <NSObject>

- (BOOL)startWithText:(NSString *)text;
- (void)pause;
- (void)play;
- (void)reSet;

@end

#import <UIKit/UIKit.h>

@interface WXSpeechSynthesizerView : UIView
{
    NSInteger _state;
    UITextView *_textView;
    UIButton *_playerButton;
    UIButton *_reSetButton;
    UITextView *_testView;
}
@property (nonatomic, assign) id<WXSpeechSynthesizerViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)reSetView;

- (void)addTestStr:(NSString *)str;

- (void)setText:(NSString *)text;
- (void)selectRange:(NSRange)range;
- (void)setTextViewCanEdit:(BOOL)canEdit;


- (UITextView *)textView;
@end
