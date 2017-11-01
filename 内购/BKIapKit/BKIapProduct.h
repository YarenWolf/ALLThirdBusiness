//
//  BKIapProduct.h
//  UltraSpeed
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct;

typedef enum {
    BKIapProductTypeConsumable = 0,
    BKIapProductTypeNonConsumable,
    BKIapProductTypeAutoRenewableSubscription,
    BKIapProductTypeFreeSubscription,
    BKIapProductTypeNonRenewingSubscription
} BKIapProductType;

@interface BKIapProduct : NSObject
/// 商品名
@property (copy, nonatomic) NSString *name;
/// 商品id
@property (copy, nonatomic) NSString *productIdentifier;
/// 本地化后的商品价格
@property (copy, nonatomic) NSString *price;
/// 实际内购用商品
@property (strong, nonatomic) SKProduct *iapProduct;
/// 内购类型
@property (assign, nonatomic) BKIapProductType iapType;

@end
