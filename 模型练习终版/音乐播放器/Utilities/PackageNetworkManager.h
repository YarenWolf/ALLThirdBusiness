//
//  PackageNetworkManager.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageNetworkManager : NSObject
typedef void(^successBlock)(id responseObject);
typedef void(^failureBlock)(NSError *error);
//@property(nonatomic,copy)void (^successBlock)(id responseObject);
+(void)sendGetRequestWithURL:(NSString*)urlStr parameters:(NSDictionary*)paramDic success:(successBlock)success failure:(failureBlock)failure;
@end
