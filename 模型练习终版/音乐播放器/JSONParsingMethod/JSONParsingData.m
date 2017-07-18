
//
//  JSONParsingData.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "JSONParsingData.h"

@implementation JSONParsingData

+ (id)parseWeatherJson:(NSDictionary *)weatherDic {
    return [[self alloc] initWithWeather:weatherDic];
}
- (id)initWithWeather:(NSDictionary *)weatherDic {
    if (self = [super init]) {
        //解析并赋值
        self.date = weatherDic[@"date"];
        self.tempMax = weatherDic[@"tempMaxC"];
        self.tempMin = weatherDic[@"tempMinC"];
    }
    return self;
}


@end
