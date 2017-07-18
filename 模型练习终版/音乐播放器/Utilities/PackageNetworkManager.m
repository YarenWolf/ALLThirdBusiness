//
//  PackageNetworkManager.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PackageNetworkManager.h"
#import "AFNetworking.h"
@implementation PackageNetworkManager
+(void)sendGetRequestWithURL:(NSString *)urlStr parameters:(NSDictionary *)paramDic success:(successBlock)success failure:(failureBlock)failure{
    //和AFNetworking相关的调用
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //登陆成功返回responseObject回传控制器
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //登陆失败返回，error回传控制器
        failure(error);
    }];
}
+ (void)sendPostRequestWithURL:(NSString*)urlStr parameters:(NSDictionary *)paramDic success:(successBlock)success failure:(failureBlock)failure{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

@end
