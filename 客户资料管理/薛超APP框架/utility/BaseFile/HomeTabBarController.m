//
//  HomeTabBarController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "HomeTabBarController.h"
#import "HomeNavigationController.h"
#import "FirstViewController.h"
#import "ServiceViewController.h"
#import "DiscoveryViewController.h"
#import "MineViewController.h"
@interface HomeTabBarController ()
@property (nonatomic, strong) NSMutableArray *items;
@end
@implementation HomeTabBarController
- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //通过设置文本属性来设置字体颜色
    for(UIViewController *s in self.childViewControllers){
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        [s.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        s.tabBarItem.image = [s.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.selectedImage = [s.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //管理子控制器
//        [self setUpAllChildViewController];
}
#pragma mark 添加所有子控制器
-(void)setUpAllChildViewController{
    //首页
    FirstViewController *home = [[FirstViewController alloc] init];
    [self setUpOneChildViewController:home image:@"2x" selectedImage:@"pressed@2x" title:@"首页"];
    //服务
    ServiceViewController *deal = [[ServiceViewController alloc] init];
    [self setUpOneChildViewController:deal image:@"2x" selectedImage:@"pressed@2x" title:@"服务"];
    //发现
    DiscoveryViewController *discover = [[DiscoveryViewController alloc] init];
    [self setUpOneChildViewController:discover image:@"2x" selectedImage:@"pressed@2x" title:@"发现"];
    //我的
    MineViewController *profile = [[MineViewController alloc] init];
    [self setUpOneChildViewController:profile image:@"2x" selectedImage:@"pressed@2x" title:@"我的"];
}
#pragma mark 添加一个子控制器
-(void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title{
        viewController.tabBarItem.title = title;
        viewController.tabBarItem.image = [UIImage imageNamed:imageName];
        viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //通过设置文本属性来设置字体颜色
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        [viewController.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        // 保存tabBarItem模型到数组
        [self.items addObject:viewController.tabBarItem];
        HomeNavigationController *nav = [[HomeNavigationController alloc] initWithRootViewController:viewController];
        [self addChildViewController:nav];
}
//
//#import "MyTabBarController.h"
//#import "MyTabBar.h"
//@interface MyTabBarController ()<MyTabBarDelegate>
//
//@end
//
//@implementation MyTabBarController
//-(void)MyTabBarDidClickCenterButton:(MyTabBar *)tabBar{
////    WeChartViewController *WeChartC=[self.storyboard instantiateViewControllerWithIdentifier:@"wechartNavigationController"];
////    [self presentViewController:WeChartC animated:YES completion:nil];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //遍历TabBarController管理的所有子vc//通过这个子vc拿到与此vc关联的那个UITabBarItem//才能修改里面被选中的图片的渲染模式
//    for (UIViewController *vc in self.viewControllers){
//        UIImage *selectedImage = vc.tabBarItem.selectedImage;
//        vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
//    //获取UITabbarItem的样品实例
//    UITabBarItem *barItem = [UITabBarItem appearance];
//    //保存正常状态下的文本属性
//    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
//    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    normalAttributes[NSForegroundColorAttributeName] = [UIColor grayColor];
//    [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    //保存选中状态下的文本属性
//    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
//    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0  alpha:1.0];
//    [barItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
//    //2.替换系统自带的tabbar
//    MyTabBar *tabbar = [[MyTabBar alloc]init];
//    tabbar.delegate = self;
//    [self setValue:tabbar forKey:@"tabBar"];
//}
//@end

@end
