//
//  WXSpeechSynthesizerWithPlayerForLongText.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-1-8.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXSpeechSynthesizerWithPlayerForLongText.h"
#import "WXSpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark ====================================
@interface LongTextPlayDataModel : NSObject
@property (nonatomic, retain) NSData *data;
@property (nonatomic, assign) NSInteger textLocation;
@property (nonatomic, assign) NSInteger textLength;
@end

@implementation LongTextPlayDataModel
@synthesize data = _data;
@synthesize textLocation = _textLocation;
@synthesize textLength = _textLength;

- (void)dealloc
{
    self.data = nil;
    [super dealloc];
}
@end

#pragma mark ====================================

@interface WXSpeechSynthesizerWithPlayerForLongText ()<AVAudioPlayerDelegate, WXSpeechSynthesizerDelegate>

@property (nonatomic, retain) NSString *text;

@end


@implementation WXSpeechSynthesizerWithPlayerForLongText
{
    AVAudioPlayer *_player;
    NSMutableArray *_playDataList;
    
    double _currentTime;
    NSInteger _didUseLength;
    BOOL _speechSynthesizerIsReady;
    BOOL _isPlaying;
    
}
@synthesize delegate = _delegate;
@synthesize state = _state;
@synthesize text = _text;

- (void)dealloc
{
    [WXSpeechSynthesizer releaseSpeechSynthesizer];
    if (_player) {
        _player.delegate = nil;
        [_player release];
    }
    [_playDataList release];

    self.text = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _state = PlayerStateOfReady;
        _speechSynthesizerIsReady = YES;
        _isPlaying = NO;
        _playDataList = [[NSMutableArray alloc] init];
        [[WXSpeechSynthesizer sharedSpeechSynthesizer] setDelegate:self];
        [[WXSpeechSynthesizer sharedSpeechSynthesizer] setUserKey:@"248b63f1ceca9158ca88516bcb338e82a482ecd802cbca12"];
        [[WXSpeechSynthesizer sharedSpeechSynthesizer] setVolumn:1];
    }
    return self;
}


- (void)startWithText:(NSString *)text{
    [self stop];
    _state = PlayerStateOfPlaying;
    _didUseLength = 0;
    _currentTime = 0;
    self.text = text;
    [self nextStep];
}
//- (void)appText:(NSString *)text{
//    if (_state != PlayerStateOfReady) {
//        self.text = [self.text stringByAppendingString:text];
//    }
//}

- (void)pause{
    if (_state == PlayerStateOfPlaying) {
        _state = PlayerStateOfPause;
        
        _currentTime = _player.currentTime;
        [_player pause];
        
    }
}
- (void)goon{
    if (_state == PlayerStateOfPause) {
        _state = PlayerStateOfPlaying;
        
        if (_player.currentTime<_currentTime) {
            [_player release];
            _player = nil;
            [self nextStep];
        } else {
            [_player play];
        }
        
    }
}
- (void)stop{
    if (_state != PlayerStateOfReady) {
        _state = PlayerStateOfReady;
        
        if (_player) {
            _player.delegate = nil;
            [_player release];
            _player = nil;
        }
        _isPlaying = NO;
        self.text = nil;
        [_playDataList removeAllObjects];
        if (!_speechSynthesizerIsReady) {
            [[WXSpeechSynthesizer sharedSpeechSynthesizer] cancel];
        }
    }
}
- (BOOL)isChar:(unichar)c inString:(NSString *)string{
    for (int i = 0; i<string.length; i++) {
        if ([string characterAtIndex:i]==c) {
            return YES;
        }
    }
    return NO;
}

- (LongTextPlayDataModel *)nextDataModel{

    int i=0;
    for (; i<self.text.length; i++) {
        if (![self isChar:[self.text characterAtIndex:i] inString:@" .\r\n，。！？；：、,?!;:"] ) {
            break;
        }
    }
    int j=i;
    for (; j<self.text.length; j++) {
        if (j-i>TEXT_LENGTH_MAX) {
            for (j=i+TEXT_LENGTH_ONCE; j<i+TEXT_LENGTH_ONCE+30 && j<self.text.length; j++) {
                unichar c=[self.text characterAtIndex:j];
                if ( (c<'0' || c>'9') && (c<'a' || c>'z') && (c<'A' || c>'Z') ) {
                    break;
                }
            }
            break;
        }
        if ([self isChar:[self.text characterAtIndex:j] inString:@"\r\n，。！？；：,?!;:"] ) {
            break;
        }
    }
    if (j>i) {

        NSString *downloadStr = [self.text substringWithRange:NSMakeRange(i, j-i)];

        if ([[WXSpeechSynthesizer sharedSpeechSynthesizer] startWithText:downloadStr]) {
            _speechSynthesizerIsReady = NO;
            LongTextPlayDataModel *dataModel = [[[LongTextPlayDataModel alloc] init] autorelease];
            dataModel.textLocation = _didUseLength+i;
            dataModel.textLength = j-i;
            _didUseLength += j;
            self.text = [self.text substringFromIndex:j];
            return dataModel;
        }

    }
    return nil;
}

- (void)nextStep{
    
    if (_state == PlayerStateOfReady) {
        return;
    }
    
    [self playNext];
    
    if (_speechSynthesizerIsReady) {
        NSInteger textLength = 0;
        for (LongTextPlayDataModel *model in _playDataList) {
            textLength += model.textLength;
        }
        
        if (textLength<TEXT_BUFFER_LENGTH_MIN) {
            if (self.text) {
                LongTextPlayDataModel *playData = [self nextDataModel];
                if (playData) {
                    [_playDataList addObject:playData];
                    return;
                }
            }
            if (!_isPlaying) {
                _state = PlayerStateOfReady;
                [_delegate didEnd];
            }
            return;
        }
    }
}
- (void)playNext{
    if (_isPlaying) {
        return;
    }
    
    if (_playDataList.count>0) {
        LongTextPlayDataModel *dataModel = [_playDataList objectAtIndex:0];
        if (dataModel.data) {
            if (_player) {
                [_player release];
            }
            _player = [[AVAudioPlayer alloc] initWithData:dataModel.data error:nil];
            _player.delegate = self;
            if ([_player prepareToPlay] && [_player play]) {
                _isPlaying = YES;
                [dataModel retain];
                [_playDataList removeObjectAtIndex:0];
                [_delegate willPlayTextLocation:dataModel.textLocation length:dataModel.textLength];
                [dataModel release];
            } else {
                [_player release];
                _player = nil;
                [_delegate errorCode:ERROR_OF_PLAYER];
            }
        }
    }
}

#pragma mark -----------WXSpeechSynthesizerDelegate------------

- (void)speechSynthesizerResultSpeechData:(NSData *)speechData speechFormat:(int)speechFormat{

    _speechSynthesizerIsReady = YES;
    LongTextPlayDataModel *dataModel = [_playDataList lastObject];
    dataModel.data = speechData;
    [self nextStep];
}
- (void)speechSynthesizerMakeError:(NSInteger)error{
    _speechSynthesizerIsReady = YES;
    [_delegate errorCode:error];
    
}
- (void)speechSynthesizerDidCancel{
    _speechSynthesizerIsReady = YES;
    if (_state != PlayerStateOfReady) {
        [self nextStep];
    }
}
#pragma mark -----PlayerDelegate-----------
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

    _isPlaying = NO;
    [self nextStep];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    _isPlaying = NO;
    [_delegate errorCode:ERROR_OF_PLAYER];
}


@end
