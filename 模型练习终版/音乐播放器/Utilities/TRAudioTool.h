//
//  TRAudioTool.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TRMusic.h"
@interface TRAudioTool : NSObject
//播放功能（传参），返回创建好的player，currentTime  totalTime
+(AVAudioPlayer*)playAudioWithFileName:(NSString *)fileName;
//暂停（传参）
+(void)pauseAudioWithFileName:(NSString*)fileName;
//停止（传参）
+(void)stopAudioWithFileName:(NSString*)fileName;
@end
