 //
//  BKIapManager.m
//  UltraSpeed
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import "BKIapManager.h"
#import <StoreKit/StoreKit.h>
#import "GTMBase64.h"

@implementation SKProduct (priceAsString)

- (NSString *)priceAsString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[self price]];
    
    //    [formatter release];
    return str;
}

@end

static BKIapManager *_iapManager;
@interface BKIapManager () <SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (copy, nonatomic) void (^syncProductsCompletionHandler)(NSError *);
@property (copy, nonatomic) void (^buyProductCompletionHandler)(NSError *);
@property (copy, nonatomic) void (^restoreProductCompletionHandler)(NSError *);
@property (copy, nonatomic) void (^receiptRefreshCompletionHandler)(NSError *);
@end

@implementation BKIapManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _products = [NSMutableArray array];
        _isBuying = NO;
        _isSyncProducts = NO;
        _isSyncProductsFinish = NO;
        
        [self receipt];
//        reportQueue = dispatch_queue_create("BKIapReportQueue", NULL);
    }
    return self;
}

+ (BKIapManager *)currentIapManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iapManager = [[BKIapManager alloc] init];
    });
    
    return _iapManager;
}

- (void)peparProduct
{
    NSAssert(self.iapProvider, @"必须有iapProvider");
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    __weak typeof(self) weakSelf = self;
    
    [self.products removeAllObjects];
    [self.iapProvider regProductsCompletionHandler:^(NSArray<BKIapProduct *> *regProducts) {
        [weakSelf.products addObjectsFromArray:regProducts];
    }];
}

- (void)syncProductsWithCompletionHandler:(void (^)(NSError *))completionHandler
{
    NSAssert(self.iapProvider, @"必须有iapProvider");
    
    _isSyncProductsFinish = NO;
    _isSyncProducts = YES;
    self.syncProductsCompletionHandler = completionHandler;
    
    NSMutableSet *_productIdentifiers = [NSMutableSet set];
    
    for (BKIapProduct *product in self.products) {
        [_productIdentifiers addObject:product.productIdentifier];
    }
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    request.delegate = self;
    [request start];
    
//    [self.products removeAllObjects];
//    [self.iapProvider regProductsCompletionHandler:^(NSArray<BKIapProduct *> *regProducts) {
//        [weakSelf.products addObjectsFromArray:regProducts];
//        
//        NSMutableSet *_productIdentifiers = [NSMutableSet set];
//        
//        for (BKIapProduct *product in weakSelf.products) {
//            [_productIdentifiers addObject:product.productIdentifier];
//        }
//        
//        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
//        request.delegate = self;
//        [request start];
//    }];
}

- (void)buyProduct:(BKIapProduct *)product completionHandler:(void (^)(NSError *))completionHandler
{
    if (_isBuying) {
        return;
    }
    NSAssert(self.iapProvider, @"必须有iapProvider");
    
    _isBuying = YES;
    
    self.buyProductCompletionHandler = nil;
    self.buyProductCompletionHandler = completionHandler;
    
    __weak typeof(self) weakSelf = self;
    [self.iapProvider preparBuyProduct:product finishPreparHandler:^(BOOL canBuy) {
        if([SKPaymentQueue canMakePayments] && canBuy)
        {
            SKPayment *payment = [SKPayment paymentWithProduct:product.iapProduct];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else
        {
            NSError *error= [NSError errorWithDomain:@"com.geeksoft.filexpert.iap" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"购买失败"}];
            weakSelf.buyProductCompletionHandler(error);
            weakSelf.buyProductCompletionHandler = nil;
        }
    }];
}

- (void)receiptRefresh:(void (^)(NSError *))completionHandler
{
    self.receiptRefreshCompletionHandler = nil;
    self.receiptRefreshCompletionHandler = completionHandler;
    
    SKReceiptRefreshRequest *refreshRequest = [[SKReceiptRefreshRequest alloc] init];
    refreshRequest.delegate = self;
    [refreshRequest start];
}

- (void)restoreProduct:(void (^)(NSError *))completionHandler
{
    self.restoreProductCompletionHandler = nil;
    self.restoreProductCompletionHandler = completionHandler;
    
    if (self.receipt) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    else {
        [self receiptRefresh:^(NSError *error) {
            if (!error) {
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
            }
            else {
                self.restoreProductCompletionHandler(error);
            }
        }];
    }
}

- (NSString *)receipt
{
    NSString *base64Receipt = nil;
    
    NSData *receiptData = nil;
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if (!receiptData) {
        /* No local receipt -- handle the error. */
        //        receipt = transaction.transactionReceipt;
//        SKReceiptRefreshRequest *refreshRequest = [[SKReceiptRefreshRequest alloc] init];
//        refreshRequest.delegate = self;
//        [refreshRequest start];
        
    }
    /* ... Send the receipt data to your server ... */
    base64Receipt = [GTMBase64 stringByEncodingData:receiptData];
    
    return base64Receipt;
    
}

#pragma mark -
#pragma mark  SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        self.receiptRefreshCompletionHandler(nil);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        self.receiptRefreshCompletionHandler(error);
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

// 请求商品回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSError *error = nil;
//    if (response.invalidProductIdentifiers.count > 0) {
//        error = [NSError errorWithDomain:@"com.gm.BKIapManager" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"含有无效的商品"}];
//    }
    
    for (SKProduct *product in response.products) {
        for (BKIapProduct *outProduct in self.products) {
            if ([outProduct.productIdentifier isEqualToString:product.productIdentifier]) {
                outProduct.iapProduct = product;
                outProduct.name = product.localizedTitle;
                outProduct.price = [product priceAsString];
            }
        }
    }
    
    _isSyncProductsFinish = YES;
    _isSyncProducts = NO;
    
    if (self.syncProductsCompletionHandler) {
        self.syncProductsCompletionHandler(error);
        self.syncProductsCompletionHandler = nil;
        
    }
}

#pragma mark -
#pragma mark 商品购买状态

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateStyle = NSDateIntervalFormatterFullStyle;
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
//        NSLog(@"%@",transaction.transactionIdentifier);
//        NSLog(@"%@",)
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"SKPaymentTransactionStateDeferred");
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if (self.iapProvider) {
        [self.iapProvider restoreVerificationHandler:^(NSError *error) {
            self.restoreProductCompletionHandler(error);
        }];
    }
    else {
        if (self.restoreProductCompletionHandler) {
            self.restoreProductCompletionHandler(nil);
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if (self.restoreProductCompletionHandler) {
        self.restoreProductCompletionHandler(error);
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    [self provideContent:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    _isBuying = NO;
    if (self.buyProductCompletionHandler) {
        self.buyProductCompletionHandler(nil);
        self.buyProductCompletionHandler = nil;
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
   
    
    [self provideContent:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    _isBuying = NO;
    if (self.buyProductCompletionHandler) {
        self.buyProductCompletionHandler(transaction.error);
    }
}

- (void)provideContent:(SKPaymentTransaction *)transaction
{
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchased:
        case SKPaymentTransactionStateRestored: {
            NSString *productIdentifier = transaction.payment.productIdentifier;
            for (BKIapProduct *iapProduct in self.products) {
                if ([iapProduct.productIdentifier isEqualToString:productIdentifier]) {
                    [self.iapProvider provideContentWithProduct:iapProduct paymentTransaction:transaction];
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
