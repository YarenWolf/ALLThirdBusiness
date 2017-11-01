//
//  TLExpressionDetailViewController.h
//  TLChat
//
//  Created by 李伯坤 on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import "BaseViewController.h"
#import "TLEmojiGroup.h"
@class TLImageExpressionDisplayView;
@interface TLExpressionDetailViewController : BaseViewController
@property (nonatomic, strong) TLEmojiGroup *group;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TLImageExpressionDisplayView *emojiDisplayView;
@end
