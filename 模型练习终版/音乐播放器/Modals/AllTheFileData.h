//
//  AllTheFileData.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AllTheFileData : NSObject
+(id)sharedData;
+(NSArray*)damoData;
+(NSArray*)allDescription;
+(NSString*)allDetailDescription:(NSString*)className;
@end