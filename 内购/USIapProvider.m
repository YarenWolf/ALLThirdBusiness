//
//  USIapProvider.m
//  UltraSpeed
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import "USIapProvider.h"
#import "StoreDefine.h"
#import <UltraSpeedAPI/UltraSpeedAPI.h>
#import <StoreKit/StoreKit.h>
#import "ACTReporter.h"

@interface USIapProvider ()
@property (strong,nonatomic) USOrderInfo *currentOrderInfo;
@property (assign, nonatomic) NSUInteger restoreTransactionCount;
@end

@implementation USIapProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _products = [NSMutableArray array];
        self.restoreTransactionCount = 0;
    }
    return self;
}

- (void)regProductsCompletionHandler:(void (^)(NSArray<BKIapProduct *> *))completionHandler
{
    if (_products.count == 0) {
        BKIapProduct *product30Days = [[BKIapProduct alloc] init];
//        product30Days.name = @"30天极速VPN套餐";
        product30Days.productIdentifier = ProductIdentifier30Days;
        product30Days.iapType = BKIapProductTypeAutoRenewableSubscription;
       
        
        BKIapProduct *product90Days = [[BKIapProduct alloc] init];
//        product90Days.name = @"90天极速VPN套餐";
        product90Days.productIdentifier = ProductIdentifier90Days;
        product90Days.iapType = BKIapProductTypeAutoRenewableSubscription;
       
        
        BKIapProduct *product180Days = [[BKIapProduct alloc] init];
//        product180Days.name = @"180天极速VPN套餐";
        product180Days.productIdentifier = ProductIdentifier180Days;
        product180Days.iapType = BKIapProductTypeAutoRenewableSubscription;
        
        
        BKIapProduct *product360days = [[BKIapProduct alloc] init];
        product360days.productIdentifier = ProductIdentifier360Days;
        product360days.iapType = BKIapProductTypeAutoRenewableSubscription;
        
        [_products addObject:product360days];
        [_products addObject:product180Days];
        [_products addObject:product90Days];
        [_products addObject:product30Days];
    }
    
    completionHandler(_products);
}

- (void)preparBuyProduct:(BKIapProduct *)product finishPreparHandler:(void (^)(BOOL canBuy))finishPreparHandler
{
    __weak typeof(self) weakSelf = self;
    [[USAPIManager shareManager] preorderWithProduct:product.productIdentifier Success:^(USOrderInfo *orderInfo) {
        weakSelf.currentOrderInfo = orderInfo;
        finishPreparHandler(YES);
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        finishPreparHandler(NO);
    }];
}

- (void)provideContentWithProduct:(BKIapProduct *)product paymentTransaction:(SKPaymentTransaction *)transaction
{
    if (self.currentOrderInfo && transaction.transactionState == SKPaymentTransactionStatePurchased) {
        NSString *receipt = nil;
        
        if (product.iapType == BKIapProductTypeAutoRenewableSubscription) {
            receipt = [[BKIapManager currentIapManager] receipt];
        }
#if SKIN == 1
        [ACTConversionReporter reportWithConversionID:@"926945629" label:@"CdyECMig7WsQ3aKAugM" value:product.price isRepeatable:YES];
#elif SKIN == 2
        [ACTConversionReporter reportWithConversionID:@"926945629" label:@"9S7aCNq9-2sQ3aKAugM" value:product.price isRepeatable:YES];
#endif
        [[USAPIManager shareManager] finishOrderWithOrderId:self.currentOrderInfo.order_id Receipt:receipt Success:^(NSTimeInterval expiresTime) {
            self.currentOrderInfo = nil;
            [self reloadUserInfo];
            NSLog(@"过期时间:%f",expiresTime);
            
        } failure:^(NSError *error) {
            NSLog(@"error:%@",error);
            self.currentOrderInfo = nil;
        }];
    }
    else if(transaction.transactionState == SKPaymentTransactionStateRestored){
        self.restoreTransactionCount ++;
    }
}

- (void)restoreVerificationHandler:(void (^)(NSError *error))verificationHandler
{
    if (self.restoreTransactionCount > 0) {
        NSString *receipt = [[BKIapManager currentIapManager] receipt];
        if (receipt) {
            [[USAPIManager shareManager] updateOrder:receipt Success:^(NSTimeInterval expiresTime) {
                [self reloadUserInfo];
                verificationHandler(nil);
            } failure:^(NSError *error) {
                [self reloadUserInfo];
                verificationHandler(error);
            }];
        }
        else {
            NSError *error = [NSError errorWithDomain:@"com.iapProvider.restore"
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey:@"nothing_to_restore"}];
            verificationHandler(error);
        }
    }
    else {
        NSError *error = [NSError errorWithDomain:@"com.iapProvider.restore"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey:@"nothing_to_restore"}];
        verificationHandler(error);
    }
    self.restoreTransactionCount = 0;
}

- (void)reloadUserInfo
{
    [[USAPIManager shareManager] requestUserInfo:^(USUserInfo *userInfo) {} failure:^(NSError *error) {}];
//    USUserInfo *userInfo = [[USAPIManager shareManager] userInfo];
//    [[USAPIManager shareManager] loadUserInfoWithUid:userInfo.uid success:^(USUserInfo *model) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}
@end
