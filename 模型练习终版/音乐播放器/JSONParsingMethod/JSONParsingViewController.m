//
//  JSONParsingViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "JSONParsingViewController.h"
#import "JSONParsingData.h"
#import "JSONParsingTool.h"
@interface JSONParsingViewController ()

@end

@implementation JSONParsingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据来源（本地）
    NSString *jsonPath=[[NSBundle mainBundle]pathForResource:@"text.json" ofType:nil];
    //读取数据并赋值给NSData
    NSData *jsonData=[NSData dataWithContentsOfFile:jsonPath];
    //解析：NSData->NSArray/NSDictionary(看服务器返回的最外层符号）
    NSError *error=nil;
    NSDictionary *jsonDic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@",jsonDic);//json解析从外往里
    NSString *str= [jsonDic[@"request"][0] valueForKey:@"query"];
    NSString *str1=jsonDic[@"request"][0][@"query"];
    NSArray *ary=jsonDic[@"request"];
    NSDictionary *dic=ary[0];
    NSString *str2=dic[@"query"];
    NSLog(@"\n%@\n%@\n%@",str,str1,str2);
    //===========================================================
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //开始转换并解析(子线程)
            [self convertAndParse:data];
        }
    }];
    [task resume];
}
- (void)convertAndParse:(NSData *)data {
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //解析
    NSDictionary *dataDic = jsonDic[@"data"];
    NSArray *currentArray = dataDic[@"current_condition"];
    NSDictionary *currentDic = currentArray[0];
    NSString *cloudStr = currentDic[@"cloudcover"];
    //连写取type对应value(熟悉之后)
    NSString *typeStr = dataDic[@"request"][0][@"type"];
    //循环解析
    NSArray *weatherArray=jsonDic[@"data"][@"weather"];
    for (NSDictionary *dic in weatherArray) {
        NSString *dateStr=dic[@"date"];
        NSString *tempMaxC=dic[@"tempMaxC"];
        NSString *tempMinC=dic[@"tempMinC"];
        NSLog(@"\n%@\n%@\n%@\n",dateStr,tempMaxC,tempMinC);
    }
    //使用工具类获取所有数据(TRWeather)
    NSArray *dataArray = [JSONParsingTool getAllWeatherData:dataDic];
    //验证
    for (JSONParsingData *weather in dataArray) {
        NSLog(@"\n%@\n%@\n%@",weather.date,weather.tempMax,weather.tempMin);
    }
    NSLog(@"%@; %@", cloudStr, typeStr);
}

@end
