//
//  RecoderAndPlayer.h
//  TCRecordDemo
//
//  Created by dev06 on 14-4-1.
//  Copyright (c) 2014年 tianChuan. All rights reserved.
//
/*
 $(PROJECT_DIR)/.../chat/chat_lib/speechSounde/lib
 
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//最大录音秒数
#define SpeechMaxTime 60

@protocol RecoderAndPlayerDelegate <NSObject>


@optional  //可选
//录制的音频文件名，大小，时长
-(void)recordAndSendAudioFile:(NSString *)fileName fileSize:(NSString *)fileSize duration:(NSString *)timelength;


//计时提醒
-(void)TimePromptAction:(int)sencond;
//倒计时
-(void)theTestTimePromptAction:(int)sencond;
-(void)theVolumeChangeValue:(float)volume;

//播放完成回调
-(void)playingFinishWithBBS:(BOOL)isFinish;
-(void)playingStartWithBBS;


@end

@interface RecoderAndPlayer : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder *_recorder;//录音库
    AVAudioPlayer *_player;//播放库
	AVAudioSession *_session;
    NSTimer *_timer;   //计时器
    NSString *_playpath;    //播放路径
    BOOL _isPlay;      //是否在播放
    id <RecoderAndPlayerDelegate> _viewDelegate;
    NSString *_recordAudioName;     //声音名
    
    int _aSeconds;//录音时间
}
@property (nonatomic,strong) id <RecoderAndPlayerDelegate> viewDelegate;


@property (readonly, getter=isPlaying) BOOL playing;
//录音开始
-(void)SpeechRecordStart;
//录音完成
-(void)SpeechRecordStop;
//播放录音文件夹中的文件
-(void)SpeechAMR2WAV:(NSString *)amrFile;
//播放下载的录音文件
-(void)SpeechChatAMR2WAV:(NSString *)amrFile;

-(void)SpeechChatAMR2WAVUrl:(NSString *)amrUrl;

//停止播放
-(void) stopPlaying;
@end
