//
//  WXSpeechSynthesizerPlayer.h
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//
@protocol WXSpeechSynthesizerPlayerDelegate <NSObject>

- (void)playerDidFinishPlaying;
- (void)playerError;
@end

#import <Foundation/Foundation.h>

@interface WXSpeechSynthesizerPlayer : NSObject
@property (nonatomic, assign)id<WXSpeechSynthesizerPlayerDelegate>delegate;
- (void)playNewData:(NSData *)data;
- (void)pause;
- (void)play;
- (void)stop;

@end
