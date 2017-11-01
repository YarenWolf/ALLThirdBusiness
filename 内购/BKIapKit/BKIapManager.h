//
//  BKIapManager.h
//  UltraSpeed
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKIapProduct.h"

@class SKPaymentTransaction;
@protocol BKIapProvider <NSObject>
- (void)regProductsCompletionHandler:(void (^)(NSArray<BKIapProduct *> *))completionHandler;
- (void)preparBuyProduct:(BKIapProduct *)product finishPreparHandler:(void (^)(BOOL canBuy))finishPreparHandler;
- (void)provideContentWithProduct:(BKIapProduct *)product paymentTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreVerificationHandler:(void (^)(NSError *error))verificationHandler;
@end

@interface BKIapManager : NSObject
{
    NSMutableArray *_products;
}

@property (readonly, nonatomic) NSMutableArray *products;
@property (readonly, atomic) BOOL isSyncProducts;
@property (readonly, atomic) BOOL isSyncProductsFinish;
@property (readonly, atomic) BOOL isBuying;
@property (strong, nonatomic) id<BKIapProvider> iapProvider;

+ (BKIapManager *)currentIapManager;
- (void)peparProduct;
- (void)syncProductsWithCompletionHandler:(void (^)(NSError *))completionHandler;

- (void)buyProduct:(BKIapProduct *)product completionHandler:(void (^)(NSError *error))completionHandler;
- (void)restoreProduct:(void (^)(NSError *error))completionHandler;
- (NSString *)receipt;
@end
