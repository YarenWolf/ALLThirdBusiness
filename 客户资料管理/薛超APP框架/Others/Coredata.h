//
//  Coredata.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Coredata : NSManagedObject
@property (nonatomic, retain) NSString *name;        //姓名
@property (nonatomic, retain) NSString *time;        //认识时间
@property (nonatomic, retain) NSString *place;       //认识地点
@property (nonatomic, retain) NSString *sex;         //性别
@property (nonatomic, retain) NSString *phone;       //手机
@property (nonatomic, retain) NSString *wechart;     //微信号
@property (nonatomic, retain) NSString *email;       //邮箱
@property (nonatomic, retain) NSString *age;         //年龄
@property (nonatomic, retain) NSString *birthDay;    //生日
@property (nonatomic, retain) NSString *company;     //公司
@property (nonatomic, retain) NSString *position;    //职位
@property (nonatomic, retain) NSString *unitAddress; //单位地址
@property (nonatomic, retain) NSString *homeAddress; //家庭地址
@property (nonatomic, retain) NSString *character;   //性格特点
@property (nonatomic, retain) NSString *hobby;       //爱好
@property (nonatomic, retain) NSString *dream;       //梦想
@property (nonatomic, retain) NSString *economic;    //经济状况
@property (nonatomic, retain) NSString *firstVision; //初次预约
@property (nonatomic, retain) NSString *need;        //需求分析
@property (nonatomic, retain) NSString *secondVision;//二次预约
@property (nonatomic, retain) NSString *suggest;     //制作建议书
@property (nonatomic, retain) NSString *deal;        //成交面谈
@property (nonatomic, retain) NSString *dealTime;    //成交时间
@property (nonatomic, retain) NSString *insuranceType;//险种
@property (nonatomic, retain) NSString *policyNumber;//保单件数
@property (nonatomic, retain) NSString *quota;       //保额(万)
@property (nonatomic, retain) NSString *annualPremium;//年化保费
@property (nonatomic, retain) NSString *instructions;//其他说明
@property (nonatomic, retain) NSString *others;      //附带
@property (nonatomic, retain) NSData *icon;
@end

