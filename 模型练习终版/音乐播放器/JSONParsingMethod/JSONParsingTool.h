//
//  JSONParsingTool.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParsingTool : NSObject
//给定字典(data)，返回TRWeather模型对象组成的数组
+ (NSArray *)getAllWeatherData:(NSDictionary *)dataDic;

@end
