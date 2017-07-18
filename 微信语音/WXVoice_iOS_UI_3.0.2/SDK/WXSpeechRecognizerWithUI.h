//
//  WXSpeechRecognizerWithUI.h
//  Del_UIAlertView
//
//  Created by 宫亚东 on 14-3-3.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXVoiceSDK.h"


@protocol WXVoiceWithUIDelegate <NSObject>

- (void)voiceInputResultArray:(NSArray *)array;

@optional   //UI上做过处理，因此下面的回调可以不使用
- (void)voiceInputMakeError:(NSInteger)errorCode;
- (void)voiceInputWaitForResult;
- (void)voiceInputDidCancel;
- (void)voiceInputVolumn:(float)volumn;

@end

//语音识别UI类，因为SDK是单例，所以本类也请只创建一个对象
@interface WXSpeechRecognizerWithUI : NSObject

- (id)initWithDelegate:(id<WXVoiceWithUIDelegate>)delegate andAppID:(NSString *)appid;
- (void)setDomain:(int)domain;
- (void)setSilTime:(float)silTime;
- (void)setResultType:(NSInteger)type;
- (BOOL)showAndStart;
- (BOOL)showAndStartOnceWithGrammarString:(NSString *)words andType:(WXGrammarType)type;
- (void)orientationChanged;     //屏幕方向改变后调用一次以更新UI方向

@end
