//
//  USIapProvider.h
//  UltraSpeed
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UltraSpeedAPI/UltraSpeedAPI.h>
@interface USIapProvider : NSObject <BKIapProvider>

@property (readonly, nonatomic) NSMutableArray *products;

- (void)regProductsCompletionHandler:(void (^)(NSArray<BKIapProduct *> *products))completionHandler;

- (void)preparBuyProduct:(BKIapProduct *)product finishPreparHandler:(void (^)(BOOL))finishPreparHandler;

- (void)provideContentWithProduct:(BKIapProduct *)product paymentTransaction:(SKPaymentTransaction *)transaction;

@end
