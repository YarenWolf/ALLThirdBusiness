//
//  JSONParsingData.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParsingData : NSObject
//针对的哪部分数据创建模型类(一般原则：解析出那些key对应的value)
//date
@property (nonatomic, strong) NSString *date;
//maxC
@property (nonatomic, strong) NSString *tempMax;
//minC
@property (nonatomic, strong) NSString *tempMin;


+ (id)parseWeatherJson:(NSDictionary *)weatherDic;



@end
