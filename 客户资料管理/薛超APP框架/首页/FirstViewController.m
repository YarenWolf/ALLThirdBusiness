//
//  XwelcomView.h
//  薛超APP框架
//
//  Created by 薛超 on 16/6/13.
//  Copyright © 2016年 薛超. All rights reserved.
//
#import "FirstViewController.h"
#import "BaseCollectionViewLayout.h"
#import "BusinessViewController.h"
#import "SalesViewController.h"
#import "SignthebillViewController.h"
#import "LocalBusinessViewController.h"
#import "FinanceViewController.h"
#import "JHChartSempleViewController.h"
@interface FirstCollectionViewCell : BaseCollectionViewCell
@end
@implementation FirstCollectionViewCell
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
@interface FirstViewController(){
}
@property(nonatomic,assign)BOOL islinkjiguang;
@end
@implementation FirstViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"首页";
    BaseCollectionViewLayout *layout = [[BaseCollectionViewLayout alloc]init];
    [layout fillLayoutWithItemSize:CGSizeMake(APPW/2, APPW/2) groupInset:UIEdgeInsetsMake(30, 20, 0, 20) itemSpace:0 lineSpace:0];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-100) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:
  @{@"title":@"增加客户名单",@"pic":@"1.jpg"},@{@"title":@"财务管理",@"pic":@"money.jpg"},
  @{@"title":@"本地查询",@"pic":@"3.jpg"},@{@"title":@"每日销售情况记录",@"pic":@"4.png"},
  @{@"title":@"每月签单记录",@"pic":@"6.jpg"},@{@"title":@"业务查询",@"pic":@"2.jpg"},nil];
    [self fillTheCollectionViewDataWithCanMove:YES sectionN:1 itemN:self.collectionView.dataArray.count itemName:@"FirstCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customdata"];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tname" ascending:NO],
//                                [NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:NO]];
//    NSError *error = nil;
//    NSArray *a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:&error];
//    for (Customdata *person in a) {
//        [[AppDelegate Share].managedObjectContext deleteObject:person];
//    }
//    [[AppDelegate Share] saveContext];
//    [SVProgressHUD showSuccessWithStatus:@"数据清除成功"];
        // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.collectionView.frame = CGRectMake(0, 0, APPW, APPH-100);
        [self.collectionView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.collectionView.frame = CGRectMake(0, 0, APPW, APPH-100);
        [self.collectionView reloadData];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.collectionView.dataArray[indexPath.item][@"title"];
    switch (indexPath.item) {
        case 0:[[self.tabBarController.viewControllers objectAtIndex:2]popToRootViewControllerAnimated:NO];self.tabBarController.selectedIndex = 2;break;
        case 1:[self pushController:[FinanceViewController class] withInfo:nil withTitle:title];break;
        case 2:[self pushController:[LocalBusinessViewController class] withInfo:nil withTitle:title];break;
        case 3:[self pushController:[SalesViewController class] withInfo:nil withTitle:title];break;
        case 4:[self pushController:[SignthebillViewController class] withInfo:nil withTitle:title];break;
        case 5:[self pushController:[BusinessViewController class] withInfo:nil withTitle:title];break;
        default:break;
    }
}

#pragma mark  极光推送
- (void)ReceiveMessage:(NSNotification *)notification{
    if ([[Utility Share] isActive]) {
        NSDictionary *userInfo = [notification userInfo];
        NSDictionary*dic=[userInfo JsonObjKey:@"aps"];
        if ([[dic JsonObjKey:@"alert"] rangeOfString:@"发送了一条新的消息"].location != NSNotFound) {
          [SVProgressHUD showImage:nil status:[dic JsonObjKey:@"alert"]];
            return;
        }
        [[Utility Share] StartSystemShake];
        [[Utility Share] playSystemSound];
        [SVProgressHUD showImage:nil status:[dic JsonObjKey:@"alert"]];
    }
}
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}
- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}
- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"已注册%@", [notification userInfo]);
}
- (void)networkDidLogin:(NSNotification *)notification {
    self.islinkjiguang=YES;
    [self setAlert];
    NSLog(@"已登录");
//    if ([APService registrationID]) {
//        
//    }
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentContent = [NSString stringWithFormat: @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count])return nil;
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    return str;
}
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}
-(void)setAlert{
    if (self.islinkjiguang&&[[Utility Share]isLogin]) {
//        [APService setAlias:UTILITY.userId callbackSelector:nil object:nil];
    }
}

#pragma mark - 键盘显示/隐藏
//  键盘显示
- (void)keyBoardWillShow:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    }completion:^(BOOL finished) {
    }];
}
// 键盘隐藏
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    }];
}

@end
