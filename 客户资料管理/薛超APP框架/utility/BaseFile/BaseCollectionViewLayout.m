//
//  BaseCollectionViewLayout.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/20.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseCollectionViewLayout.h"
@implementation BaseCollectionViewLayout
- (instancetype)init{
    self = [super init];
    if (self) {
        // 设置item的大小
//        self.itemSize = _itemSize;
        // 设置水平滚动
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置最小行间距和格间距为10
        self.minimumInteritemSpacing = _itemSpace;//格
        self.minimumLineSpacing = _lineSpace;//行
        // 设置内边距
        self.sectionInset = _groupInset;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
-(void)fillLayoutWithItemSize:(CGSize)size groupInset:(UIEdgeInsets)groupInset itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace{
    self.itemSize = size;
    self.groupInset = groupInset;
    self.itemSpace = itemSpace;
    self.lineSpace = lineSpace;
}
@end


