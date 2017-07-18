//
//  Student.h
//  数据持久化-NSUserDefalults
//
//  Created by ISD1510 on 15/12/31.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject<NSCoding>
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger age;
-(id)initWithName:(NSString*)name Age:(NSInteger)age;
//DownLoadViewController的
@property(nonatomic,strong)NSMutableDictionary *mutableDic;
+(id)sharedImageCenter;
@end
