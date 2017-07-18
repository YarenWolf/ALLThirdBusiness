//
//  TRMusicTool.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMusic.h"
@interface TRMusicTool : NSObject
//公开一个方法，读取plist文件并返回已经转换好的数组TRMusic
+(NSArray*)musicArray;
//获取当前正在播放的音乐
+(TRMusic*)currentPlayingMusic;
//设置当前播放音乐
+(void)setCurrentPlayingMusic:(TRMusic*)music;
+(TRMusic*)nextMusic;
+(TRMusic*)previousMusic;
@end

