
//
//  TRAudioTool.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRAudioTool.h"
static NSMutableDictionary *allPlayer=nil;
@interface TRAudioTool()
//@property(nonatomic,strong)NSMutableDictionary *allPlayer;
@end
@implementation TRAudioTool
+(NSMutableDictionary *)allPlayer{
    if(!allPlayer){
        allPlayer=[NSMutableDictionary dictionary];
    }return allPlayer;
}
+(AVAudioPlayer *)playAudioWithFileName:(NSString *)fileName{
    //判断字典中是否有意境创建好的player对象
    //初始化字典
    [self allPlayer];
    AVAudioPlayer *player=allPlayer[fileName];
    //有：（正在播放；否：play）  //没有：创建player对象，并存储到字典中，播放。
    if(!player){
    NSURL *audioURL=[[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
    NSError *error=nil;
    player=[[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:&error];
    if(!error){allPlayer[fileName]=player;}
    }
    //播放
    if(!player.playing){[player play];}
    return player;
}
+(void)pauseAudioWithFileName:(NSString *)fileName{
    AVAudioPlayer *player=allPlayer[fileName];
    if (player) {
        if (player.playing) {
            [player pause];
        }
    }
}
+(void)stopAudioWithFileName:(NSString *)fileName{
    AVAudioPlayer *player=allPlayer[fileName];
    if(player){[player stop];}
    [allPlayer removeObjectForKey:fileName];
}
@end
