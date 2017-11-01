//
//  FinanceViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/11/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "FinanceViewController.h"
#import "BaseCollectionViewLayout.h"
#import "FinanceManagerViewController.h"
#import "AccountViewController.h"
#import "PresentationViewController.h"
#import "ZhangdanViewController.h"
@interface FinanceCollectionViewCell : BaseCollectionViewCell
@end
@implementation FinanceCollectionViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(APPW/12, 10, APPW/3, APPW/3);
    self.title.frame = CGRectMake(0, APPW/3+20, W(self), 20);
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.icon,self.title,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:dict[@"pic"]];
    self.title.text = dict[@"title"];
}
@end
@interface FinanceViewController(){
}
@end
@implementation FinanceViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    BaseCollectionViewLayout *layout = [[BaseCollectionViewLayout alloc]init];
    [layout fillLayoutWithItemSize:CGSizeMake(APPW/2, APPW/2) groupInset:UIEdgeInsetsMake(30, 20, 0, 20) itemSpace:0 lineSpace:0];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:
                                     @{@"title":@"支出管理",@"pic":@"m1.jpg"},@{@"title":@"收入管理",@"pic":@"m2.jpg"},
                                     @{@"title":@"未来规划",@"pic":@"m3.jpg"},@{@"title":@"账户管理",@"pic":@"m4.jpg"},
                                     @{@"title":@"财务报告",@"pic":@"m5.jpg"},@{@"title":@"消费记录",@"pic":@"6.jpg"},nil];
    [self fillTheCollectionViewDataWithCanMove:YES sectionN:1 itemN:self.collectionView.dataArray.count itemName:@"FinanceCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.collectionView.dataArray[indexPath.item][@"title"];
    switch (indexPath.item) {
        case 0:[self pushController:[FinanceManagerViewController class] withInfo:nil withTitle:title];break;
        case 1:[self pushController:[FinanceManagerViewController class] withInfo:nil withTitle:title];break;
        case 2:[self pushController:[FinanceManagerViewController class] withInfo:nil withTitle:title];break;
        case 3:[self pushController:[AccountViewController class] withInfo:nil withTitle:title];break;
        case 4:[self pushController:[PresentationViewController class] withInfo:nil withTitle:title];break;
        case 5:[self pushController:[ZhangdanViewController class] withInfo:nil withTitle:title];break;
        default:break;
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.collectionView.frame = CGRectMake(0, 0, APPW, APPH);
        [self.collectionView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.collectionView.frame = CGRectMake(0, 0, APPW, APPH);
        [self.collectionView reloadData];
    }
}

@end
