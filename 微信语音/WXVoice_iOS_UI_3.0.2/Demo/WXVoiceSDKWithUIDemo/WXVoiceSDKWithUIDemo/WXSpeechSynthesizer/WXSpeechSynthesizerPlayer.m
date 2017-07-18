//
//  WXSpeechSynthesizerPlayer.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 13-12-26.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "WXSpeechSynthesizerPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface WXSpeechSynthesizerPlayer ()<AVAudioPlayerDelegate>

@end

@implementation WXSpeechSynthesizerPlayer
{
    AVAudioPlayer *_player;
    double _currentTime;
}
@synthesize delegate = _delegate;

- (void)dealloc
{
    if (_player) {
        _player.delegate = nil;
        [_player release];
    }
    [super dealloc];
}

- (void)playNewData:(NSData *)data{
    if (_player) {
        [_player release];
    }
    _player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _player.delegate = self;
    if ([_player prepareToPlay] && [_player play]) {
        
    } else {
        [_player release];
        _player = nil;
        [_delegate playerError];
    }
}
- (void)pause{
    _currentTime = _player.currentTime;
    [_player pause];
}
- (void)play{
    if (_player.currentTime<_currentTime) {
        [_player release];
        _player = nil;
        [_delegate playerDidFinishPlaying];
    } else {
        [_player play];
    }
}
- (void)stop{
    [_player release];
    _player = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == _player) {
        [_player release];
        _player = nil;
        [_delegate playerDidFinishPlaying];
    }

}

@end
