//
//  WXSpeechRecognizerWithUIView.h
//  WXVoiceSDKWithUIDemo
//
//  Created by 宫亚东 on 14-3-18.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WXSpeechRecognizerWithUIViewDelegate <NSObject>

- (BOOL)clickedStartBtn;

@end

@interface WXSpeechRecognizerWithUIView : UIView

@property (nonatomic, assign)id<WXSpeechRecognizerWithUIViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame;
- (void)setText:(NSString *)text;

- (void)setResultFrame:(CGRect)frame;
- (void)setResultTextAlignment:(NSTextAlignment)alignment;

@end
