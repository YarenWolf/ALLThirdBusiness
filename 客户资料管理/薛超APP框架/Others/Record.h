//
//  Record+CoreDataClass.h
//  
//
//  Created by 薛超 on 16/11/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Record : NSManagedObject
@property (nonatomic, retain) NSString *type;        //收入/支出/预算
@property (nonatomic, retain) NSDate   *date;          //日期
@property (nonatomic, retain) NSString *yinhang;     //账户
@property (nonatomic, retain) NSString *account;     //账号
@property (nonatomic, retain) NSString *inputItem;   //收入项目
@property (nonatomic, retain) NSString *outputItem;  //支出项目
@property (nonatomic, retain) NSString *expectItem;  //预算项目
@property (nonatomic, assign) double money;          //金额
@property (nonatomic, retain) NSString *classItem;   //分类
@property (nonatomic, retain) NSString *descript;    //详细说明


@end
