//
//  JSONParsingTool.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "JSONParsingTool.h"
#import "JSONParsingData.h"
@implementation JSONParsingTool

+ (NSArray *)getAllWeatherData:(NSDictionary *)dataDic {
    //循环解析
    NSArray *weatherArray = dataDic[@"weather"];
    //可变数组
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *weatherDic in weatherArray) {
        JSONParsingData *weather = [JSONParsingData parseWeatherJson:weatherDic];
        [mutableArray addObject:weather];
    }
    
    return [mutableArray copy];
}

@end
