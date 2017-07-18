//
//  Student.m
//  数据持久化-NSUserDefalults
//
//  Created by ISD1510 on 15/12/31.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "Student.h"

@implementation Student
-(id)initWithName:(NSString *)name Age:(NSInteger)age{
    if(self=[super init]){
        self.name=name;
        self.age=age;
    }
    return self;
}
#pragma mark 以下是自定义的归档与解档，方法来自于NSCoding协议。
//时机：归档时调用该方法。
-(void)encodeWithCoder:(NSCoder *)aCoder{
   NSLog(@"编码:%s",__func__);
    //所有的属性进行编码操作
    [aCoder encodeObject:self.name forKey:@"123456"];
    [aCoder encodeInteger:self.age forKey:@"654321"];
}
//时机：解档时调用该方法。
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        NSLog(@"解码:%s",__func__);
        //所有的属性进行解码操作
        self.name=[aDecoder decodeObjectForKey:@"123456"];
        self.age=[aDecoder decodeIntegerForKey:@"654321"];
    }
    return self;
}
//单例模式======================
static Student *_studentByGCD=nil;
+(id)sharedStudent{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        _studentByGCD=[[Student alloc]init];
    });
    return _studentByGCD;
}
//重写alloc方法完善单利的创建
//+(instancetype)alloc{
//    static dispatch_once_t onceTocken;
//    dispatch_once(&onceTocken, ^{
//        _studentByGCD=[super alloc];
//    });
//    return _studentByGCD;
//}
#pragma mark 以下是download控制器的
+(id)sharedImageCenter{
    static Student *_imageCenter=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCenter=[[Student alloc]init];
    });
    return _imageCenter;
}
-(instancetype)init{
    if (self=[super init]) {
        self.mutableDic=[NSMutableDictionary dictionary];
    }
    return self;
}

@end
