//
//  BaseCollectionViewLayout.h
//  薛超APP框架
//
//  Created by 薛超 on 16/10/20.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewLayout:UICollectionViewFlowLayout
//@property (nonatomic, assign)CGSize itemSize;已有了
@property (nonatomic, assign)UIEdgeInsets groupInset;
@property (nonatomic, assign)CGFloat itemSpace;
@property (nonatomic, assign)CGFloat lineSpace;
-(void)fillLayoutWithItemSize:(CGSize)size groupInset:(UIEdgeInsets)groupInset itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace;

@end

