//
//  TRMusic.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMusic : NSObject
//原则：属性名字必须和字典的key一样
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *filename;
@property(nonatomic,strong)NSString *singer;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *singerIcon;
@end


