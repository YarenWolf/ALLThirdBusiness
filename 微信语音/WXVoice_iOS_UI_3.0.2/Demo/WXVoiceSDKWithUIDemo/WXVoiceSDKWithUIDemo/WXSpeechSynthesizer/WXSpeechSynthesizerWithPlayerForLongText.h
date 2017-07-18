//
//  WXSpeechSynthesizerWithPlayerForLongText.h
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-1-8.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

//对于长文本的处理，本类仅供参考

#define PlayerStateOfReady  0
#define PlayerStateOfPlaying  1
#define PlayerStateOfPause  2

#define TEXT_BUFFER_LENGTH_MIN 100  //最少缓存的字符数,100中文字的语音数据约为80K-90K
#define TEXT_LENGTH_MAX 80          //单句最大长度（SDK内的上限为1024）
#define TEXT_LENGTH_ONCE 50         //超过长度后按此长度分段(如果有字母或数字，则延长至字母数字结束，以避免英文单词被从中间分割，最多延长30字符)

#define ERROR_OF_PLAYER -11 //播放器的错误

#import <Foundation/Foundation.h>



@protocol WXSpeechSynthesizerWithPlayerForLongTextDelegate <NSObject>
//当前播放语句的位置和长度
- (void)willPlayTextLocation:(NSInteger)location length:(NSInteger)length;
//播放结束
- (void)didEnd;
//发生错误
- (void)errorCode:(NSInteger)errorCode;

@end

@interface WXSpeechSynthesizerWithPlayerForLongText : NSObject

@property (nonatomic, assign) id<WXSpeechSynthesizerWithPlayerForLongTextDelegate> delegate;
@property (nonatomic, readonly) NSInteger state;

//开始合成并播放（这里的字符串要占用双倍内存的，某些上千万字的超级小说不要一下子都放进来。）
- (void)startWithText:(NSString *)text;
- (void)pause;  //暂停播放
- (void)goon;   //继续播放
- (void)stop;   //停止播放

@end
