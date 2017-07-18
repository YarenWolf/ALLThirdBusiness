//
//  TRMusicTool.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRMusicTool.h"
@implementation TRMusicTool
static NSArray *musicArrayFromFile=nil;
static TRMusic *currentMusic=nil;
+(NSArray *)musicArray{
    if(!musicArrayFromFile){
        musicArrayFromFile=[self getMusicDataFromPlist:@"Musics.plist"];
    }return musicArrayFromFile;
}
+(NSArray*)getMusicDataFromPlist:(NSString*)fileName{
    NSMutableArray *allMusic=[NSMutableArray array];
    //1.从filename中读取数据
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    NSArray *musicArray=[[NSArray alloc]initWithContentsOfFile:plistPath];
    //2.对象转模型
    for (NSDictionary *musicDic in musicArray) {
        //1.声明一个空的模型对象
        TRMusic *music=[[TRMusic alloc]init];
        //2.使用KVC方式自动转。有个方法自动将字典中的key与之对应的对象一一转化
        [music setValuesForKeysWithDictionary:musicDic];
        [allMusic addObject:music];
    }return allMusic;
}
+(TRMusic *)currentPlayingMusic{
    return currentMusic;
}
+(void)setCurrentPlayingMusic:(TRMusic *)music{
    //判断music合法，赋值。
    currentMusic=music;
}
+(TRMusic *)nextMusic{
    //获取当前音乐下标
    NSUInteger index=[musicArrayFromFile indexOfObject:currentMusic];
    //下一首的下标
    NSUInteger nextIndex=index+1;
    if(nextIndex>=musicArrayFromFile.count){
        nextIndex=0;
    }
    return musicArrayFromFile[nextIndex];
}
+(TRMusic *)previousMusic{
    return musicArrayFromFile[([musicArrayFromFile indexOfObject:currentMusic]+musicArrayFromFile.count-1)%musicArrayFromFile.count];
}
@end
