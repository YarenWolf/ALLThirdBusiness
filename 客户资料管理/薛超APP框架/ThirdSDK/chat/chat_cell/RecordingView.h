//
//  DDRecordingView.h
//  Emoji
//
//  Created by YiLiFILM on 14/12/13.
//  Copyright (c) 2014年 YiLiFILM. All rights reserved.
//语音录音提示
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDRecordingState)
{
    DDShowVolumnState,
    DDShowCancelSendState,
    DDShowRecordTimeTooShort,
    DDShowTheRestTimeRemind
};

@interface RecordingView : UIView
@property (nonatomic,assign)DDRecordingState recordingState;

- (instancetype)initWithState:(DDRecordingState)state;
- (void)setVolume:(float)volume;  //0-1.0 volumn
-(void)setTheRestTimeRemindNum:(int)num;//必须是DDShowTheRestTimeRemind时使用


@end
