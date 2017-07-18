
//
//  AllTheFileData.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "AllTheFileData.h"
#import "DataPersistenceViewController.h"
#import "TRMainTableViewController.h"
#import "TRMusicDetailViewController.h"
#import "OprationFileViewController.h"
#import "ThreadViewController.h"
#import "GCDViewController.h"
#import "DownLoadViewController.h"
#import "JSONParsingViewController.h"
#import "SocketCommunicationViewController.h"
#import "SocketServiceViewController.h"
#import "OfficialSocketCommulationViewController.h"
#import "WebViewController.h"
#import "URLConnectionViewController.h"
#import "DownloadWebResourceViewController.h"
#import "DownloadProgressViewController.h"
#import "PackageAFNetworkingViewController.h"
#import "GeoCodingViewController.h"
#import "MKMapViewController.h"
#import "MapOfRouteGuidanceViewController.h"
@implementation AllTheFileData
static AllTheFileData *allData=nil;
+(id)sharedData{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        allData=[[AllTheFileData alloc]init];
    });
    return allData;
}
+(instancetype)alloc{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        allData=[super alloc];
    });
    return allData;
}
+(NSArray *)damoData{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return @[[[TRMainTableViewController alloc]init],
             [storyBoard instantiateViewControllerWithIdentifier:@"OperationFile"],
             [storyBoard instantiateViewControllerWithIdentifier:@"DataPersistence"],
             [storyBoard instantiateViewControllerWithIdentifier:@"Thread"],
             [storyBoard instantiateViewControllerWithIdentifier:@"GCD"],
             [[DownLoadViewController alloc]initWithImageURL:[NSURL URLWithString:@"http://images.apple.com/v/iphone-5s/gallery/a/images/download/photo_2.jpg"]],
             [[JSONParsingViewController alloc]init],
             [storyBoard instantiateViewControllerWithIdentifier:@"SocketCommunicationViewController"],
             [storyBoard instantiateViewControllerWithIdentifier:@"SocketServiceViewController"],
             [storyBoard instantiateViewControllerWithIdentifier:@"OfficialSocketCommulationViewController"],
             [[WebViewController alloc]init],
             [storyBoard instantiateViewControllerWithIdentifier:@"URLConnectionViewController"],
             [storyBoard instantiateViewControllerWithIdentifier:@"DownloadWebResourceViewController"],
             [storyBoard instantiateViewControllerWithIdentifier:@"DownloadProgressViewController"],
             [[PackageAFNetworkingViewController alloc]init],
             [[GeoCodingViewController alloc]init],
             [[MKMapViewController alloc]init],
             [[MapOfRouteGuidanceViewController alloc]init],
             ];
}
+(NSArray*)allDescription{
    return @[
             @"音乐播放器",
             @"文件操作",
             @"数据存储",
             @"多线程编程",
             @"GCD线程",
             @"组下载图片",
             @"JSON格式解析",
             @"Socket通信",
             @"Socket服务器",
             @"官方Socket通信",
             @"网页视图加载",
             @"URLConnection",
             @"下载网络资源",
             @"下载进度监控",
             @"AFNetworking封装",
             @"地图编码和定位",
             @"添加地图标注",
             @"地图线路导航",
             ];
}
+(NSString*)allDetailDescription:(NSString*)className{
    //从指定路径读取plist文件中的数据
    NSDictionary *allDemoDetailDescription=[[NSDictionary alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"AllTheDetailDescription" withExtension:@"plist"]];
    return  allDemoDetailDescription[className];
}



















@end
