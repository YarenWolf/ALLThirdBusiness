//
//  Acount+CoreDataClass.h
//  
//
//  Created by 薛超 on 16/11/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Acount : NSManagedObject
@property (nonatomic, retain) NSString *type;  //类型：银行卡，信用卡，微信，支付宝，现金
@property (nonatomic, retain) NSString *yinhang;        //银行卡
@property (nonatomic, retain) NSString *account;     //账号
@property (nonatomic, assign) double yue;     //余额
@property (nonatomic, retain) NSString *tips;   //提醒
@property (nonatomic, assign) double edu;  //额度
@property (nonatomic, assign) double arrears;  //欠款
@property (nonatomic, assign) double least;  //最低还款
@property (nonatomic, retain) NSString *descript;  //其他
@end
