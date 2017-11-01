//
//  RecoderAndPlayer.m
//  TCRecordDemo
//
//  Created by dev06 on 14-4-1.
//  Copyright (c) 2014年 tianChuan. All rights reserved.
//

#import "RecoderAndPlayer.h"
#import "amrFileCodec.h"
#import "NetEngine.h"


@implementation RecoderAndPlayer
@synthesize viewDelegate=_viewDelegate;



#pragma 录音
-(void)SpeechRecordStart
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strNum=@"1";//[NSString stringWithFormat:@"%ld",[defaults valueForKey:K_alreadyNum]?[[defaults valueForKey:K_alreadyNum] integerValue]+1:1];
    [defaults setValue:strNum forKey:K_alreadyNum];
    [defaults synchronize];
    //录制
    _isPlay = NO;
    if ([self startAudioSession])
    {
        _aSeconds=0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        [self record];
    }
}
-(NSData *)decodeAmr:(NSData *)data{
    if (!data)
    {
        return data;
    }
    return DecodeAMRToWAVE(data);
}
-(NSData*)encodePcm:(NSData*)data{
    if (!data) {
        return data;
    }
    return EncodeWAVEToAMR(data, 1, 16);
}
//录音
-(BOOL)record
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:DOCUMENTS_FOLDER]) {
        [fileManager createDirectoryAtPath:DOCUMENTS_FOLDER
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
    
	NSError *error;
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSURL *urlPath = [NSURL fileURLWithPath:FILEPATH];
	_recorder = [[AVAudioRecorder alloc] initWithURL:urlPath settings:settings error:&error];
	if (!_recorder)
	{
		return NO;
	}
    //开启音量检测
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
	if (![_recorder prepareToRecord])
	{
		return NO;
	}
	if (![_recorder record])
	{
		return NO;
	}
    [self LoudSpeakerRecorder:YES];
	return YES;
}
//音量
- (void)detectionVoice
{
    [_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    NSLog(@"音量:%lf",lowPassResults);
    if ([self.viewDelegate respondsToSelector:@selector(theVolumeChangeValue:)]) {
        [self.viewDelegate theVolumeChangeValue:lowPassResults];
    }
    [self performSelector:@selector(detectionVoice) withObject:nil afterDelay:0.16];
}


#pragma 打开扬声器--录音、播放
//打开扬声器--录音
-(bool) LoudSpeakerRecorder:(bool)bOpen
{
//原来代码
	//播放的时候设置play ，录音时候设置recorder

//    //return false;
//    UInt32 route;
//    // OSStatus error;
//    UInt32 sessionCategory =  kAudioSessionCategory_PlayAndRecord;////kAudioSessionCategory_PlayAndRecord;    // 1
//
//    AudioSessionSetProperty (
//                             kAudioSessionProperty_AudioCategory,                        // 2
//                             sizeof (sessionCategory),                                   // 3
//                             &sessionCategory                                            // 4
//                             );
//    
//    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
    //tjc 修改
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    return true;
}
//打开扬声器--播放
-(bool)LoudSpeakerPlay:(bool)bOpen
{
    
//原来代码
//	//播放的时候设置play ，录音时候设置recorder
//	
//	//return false;
//    UInt32 route;
//    //OSStatus error;
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty (
//                             kAudioSessionProperty_AudioCategory,                        // 2
//                             sizeof (sessionCategory),                                   // 3
//                             &sessionCategory                                            // 4
//                             );
//    
//    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
    //tjc 修改
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    return true;
}

//格式化录制文件名称 距离1970的毫秒数 10位整数
- (NSString *) fileNameString
{
    double seconds = [[NSDate date] timeIntervalSince1970];
    NSString *mircoSeconds = [[[NSString stringWithFormat:@"%f",seconds] componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@.%@",mircoSeconds,@"wav"];
    _recordAudioName = fileName;
    return fileName;
}
//获取文件大小 并且移除临时生成的wav文件
-(NSString*)fetchRecordAudioFileSize:(NSString*)fileName{
    NSNumber *fileSize = [NSNumber numberWithInt:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSDictionary *fileAttibutes = [fileManager attributesOfItemAtPath:fileName error:&error];
    if (fileAttibutes != nil) {
        
        if ([fileAttibutes objectForKey:NSFileSize]) {
            fileSize = [fileAttibutes objectForKey:NSFileSize];
        }
    }
    //移除生成的临时文件  recordAudioName
    NSString *tempFile = [documentsDirectory stringByAppendingPathComponent:_recordAudioName];
    [fileManager removeItemAtPath:tempFile error:nil];
    return [[NSString alloc] initWithFormat:@"%@",fileSize];
}
//建立录音会话
- (BOOL) startAudioSession
{
	NSError *error;
	_session = [AVAudioSession sharedInstance];
	if (![_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
		return NO;
	}
	if (![_session setActive:YES error:&error])
	{
		return NO;
	}
    [self performSelector:@selector(detectionVoice) withObject:nil afterDelay:0.16];
    return _session.inputAvailable;//.inputIsAvailable;
}
//录音倒计时
-(void)countTime{
    if (_aSeconds>=SpeechMaxTime) {
        _aSeconds = 100;

        [self SpeechRecordStop];
    }else {
        _aSeconds++;
        if (_aSeconds+10>SpeechMaxTime) {
            int numTemp=SpeechMaxTime-_aSeconds;
            if ([self.viewDelegate respondsToSelector:@selector(theTestTimePromptAction:)]) {
                [self.viewDelegate theTestTimePromptAction:numTemp];
            }
        }
        if ([_viewDelegate respondsToSelector:@selector(TimePromptAction:)]) {
            [_viewDelegate TimePromptAction:_aSeconds];
        }
        
    }
    NSLog(@"录音记时%d",_aSeconds);
}
//录音完成
-(void)SpeechRecordStop
{
    [self stopRecording];
    [_timer invalidate];
    if ([_viewDelegate respondsToSelector:@selector(TimePromptAction:)]) {
        [_viewDelegate TimePromptAction:_aSeconds];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
//停止录音
- (void) stopRecording
{
	[_recorder stop];
}

/*******************************************播放录音文件夹中的文件***********************************************/

#pragma 播放录音文件夹中的文件
-(void)SpeechAMR2WAV:(NSString *)amrFile
{
    NSData *amrData = [NSData dataWithContentsOfFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:amrFile]];
    NSData *wavData = [self decodeAmr:amrData];
    if (!wavData) {
        NSLog(@"wavdata is empty");
        return;
    }
    [self LoudSpeakerPlay:YES];
    _player= [[AVAudioPlayer alloc] initWithData:wavData error:nil];
    [_player stop];
    _player.delegate =self;
    [_player prepareToPlay];
    [_player setVolume:1.0];
    [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
}
//播放下载的录音文件
-(void)SpeechChatAMR2WAV:(NSString *)amrFile
{
    NSData *amrData = [NSData dataWithContentsOfFile:[DOCUMENTS_CHAT_FOLDER stringByAppendingPathComponent:amrFile]];
    NSData *wavData = [self decodeAmr:amrData];
    if (!wavData) {
        NSLog(@"wavdata is empty");
        return;
    }
    [self LoudSpeakerPlay:YES];
    _player= [[AVAudioPlayer alloc] initWithData:wavData error:nil];
    [_player stop];
    _player.delegate =self;
    [_player prepareToPlay];
    [_player setVolume:1.0];
    [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
}

//停止播放
-(void) stopPlaying{
    if (_player) {
        [_player stop];
    }
}
//播放
- (void)play
{
    if (_player){
        [_player play];
        if ([self.viewDelegate respondsToSelector:@selector(playingStartWithBBS)]) {
            //
            [self.viewDelegate playingStartWithBBS];
        }
    }
    
}
#pragma AVAudioPlayerDelegate method

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //被暂停
    if ([self.viewDelegate respondsToSelector:@selector(playingFinishWithBBS:)]) {
        //播放完成回调
        [self.viewDelegate playingFinishWithBBS:NO];
    }

}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
//    开始播放playingStartWithBBS
   

}
//播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _isPlay = NO;
    if ([self.viewDelegate respondsToSelector:@selector(playingFinishWithBBS:)]) {
        //播放完成回调
        [self.viewDelegate playingFinishWithBBS:YES];
    }
    
}
#pragma AVAudioRecorderDelegate method
//录音完成回调方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (_aSeconds>0) {
        // NSLog(@"%d",self.aSeconds);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:DOCUMENTS_FOLDER]) {
                [fileManager createDirectoryAtPath:DOCUMENTS_FOLDER
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
            }
            NSData *adata = [NSData dataWithContentsOfFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:_recordAudioName]];
            //pct to amr
            [self encodePcm:adata];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            // [defaults setValue:self.userName forKey:K_alreadyNum];
            
            //已经生成amr的文件
            NSString *fileName = [NSString stringWithFormat:@"%@",[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"alreadyEncoderData%@.amr",[defaults valueForKey:K_alreadyNum]]]];
            
            //获取文件大小 并且移除临时生成的wav文件
            NSString *fileSize = [NSString stringWithFormat:@"%d",[[self fetchRecordAudioFileSize:fileName]intValue]/1000];
           dispatch_async(dispatch_get_main_queue(), ^{
               if ([_viewDelegate respondsToSelector:@selector(recordAndSendAudioFile:fileSize:duration:)]) {
                   [_viewDelegate recordAndSendAudioFile:fileName fileSize:fileSize duration:[NSString stringWithFormat:@"%d",_aSeconds>SpeechMaxTime?SpeechMaxTime:_aSeconds]];
               }               
           });
        });
        
       
    }
    
}





-(void)SpeechChatAMR2WAVUrl:(NSString *)amrUrl
{
    //下载 DOCUMENTS_CHAT_FOLDER
    __block BOOL isDir = YES;
    NSString *dbPath = [DOCUMENTS_CHAT_FOLDER stringByAppendingPathComponent:[amrUrl lastPathComponent]];
    NSString *filespath = [dbPath stringByDeletingPathExtension];
    //判断文件是否存在
    if([[NSFileManager defaultManager] fileExistsAtPath:dbPath] == NO)
    {//soapShare]
        DLog(@"________amrUrl:%@",amrUrl);
        
        [NetEngine  createFileAction:amrUrl onCompletion:^(id resData, BOOL isCache) {
            NSLog(@"dic 是%@",resData);
            DLog(@"____%@",dbPath);
            
            if (![[NSFileManager defaultManager]fileExistsAtPath:filespath isDirectory:&isDir ]) {// isDir判断是否为文件夹
                [[NSFileManager defaultManager]createDirectoryAtPath:filespath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            BOOL b=[resData writeToFile:dbPath options:NSDataWritingAtomic error:NULL];
            DLog(@"文件写入%@",b?@"成功":@"失败");
            [self SpeechChatAMR2WAV:[amrUrl lastPathComponent]];
        } onError:^(NSError *error) {
            
        } withMask:SVProgressHUDMaskTypeNone];
    }else{
        [self SpeechChatAMR2WAV:[amrUrl lastPathComponent]];
    }
    
    
    
}

- (BOOL)isPlaying
{
    if (!_player) {
        return NO;
    }
    return _player.isPlaying;
}




@end
