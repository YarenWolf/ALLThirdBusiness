//
//  TLExpressionPublicViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import "TLExpressionProxy.h"
@interface TLExpressionPublicViewController : UIViewController{
    NSInteger kPageIndex;
}
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) TLExpressionProxy *proxy;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
