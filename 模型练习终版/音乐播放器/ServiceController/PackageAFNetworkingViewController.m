
//
//  PackageAFNetworkingViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PackageAFNetworkingViewController.h"
#import "AFNetworking.h"
#import "PackageNetworkManager.h"
@interface PackageAFNetworkingViewController ()

@end
@implementation PackageAFNetworkingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [PackageNetworkManager sendGetRequestWithURL:@"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json" parameters:nil success:^(id responseObject) {
        NSLog(@"返回成功:%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"返回失败:%@",error.userInfo);
    }];
}
@end
