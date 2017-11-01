//
//  MCPieChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef id (^ValueBlock)(NSInteger index);
typedef UIColor* (^colorBlock)(NSInteger index);
@interface MCPieChartView : UIView
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *pieBackgroundColor;
@property (nonatomic, assign) BOOL ring;
@property (nonatomic, assign) CGFloat ringWidth;
@property (nonatomic, copy  ) NSString *ringTitle;
@property (nonatomic, assign) BOOL circle;
- (void)reloadData;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy  ) ValueBlock ValueBlock;
@property (nonatomic, copy  ) colorBlock colorBlock;
@property (nonatomic, strong) id sumValue;
@property (nonatomic, strong) NSAttributedString *attributeRingTitle;
@property (nonatomic, strong) UIView *ringView;

- (void)fillDataWithParameters:(NSDictionary*)parameters
                     dataArray:(NSMutableArray*)dataArray
             valueOfPieAtIndex:(ValueBlock)ValueBlock
             colorOfPieAtIndex:(colorBlock)colorBlock
                      sumValue:(id)sumValue
                     ringTitle:(NSAttributedString*)ringTitle
                      ringView:(UIView*)ringView;
@end
//范例
/*
 NSMutableArray *mutableArray = [NSMutableArray array];
 for (NSInteger i = 0; i < 4; i ++) {
 [mutableArray addObject:@(arc4random()%100)];
 }
 _dataSource = [NSArray arrayWithArray:mutableArray];
 NSAttributedString *attributeTitle = [[NSAttributedString alloc] initWithString:@"简单题\n共300分" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
 _pieChartView = [[MCPieChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@NO,@"circle",@"简单题\n共300分",@"ringTitle",@20,@"ringWidth", nil];
 [self.view addSubview:_pieChartView];
 [_pieChartView fillDataWithParameters:dict dataArray:[NSMutableArray arrayWithArray:_dataSource] valueOfPieAtIndex:^id(NSInteger index) {
 return _dataSource[index];
 } colorOfPieAtIndex:^UIColor *(NSInteger index) {
 if (index == 0) {return [UIColor colorWithRed:98/255.0 green:147/255.0 blue:215/255.0 alpha:1.0];
 } else if (index == 1) {return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
 } else if (index == 2) {return [UIColor colorWithRed:224/255.0 green:135/255.0 blue:56/255.0 alpha:1.0];}
 return [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
 } sumValue:@400 ringTitle:attributeTitle ringView:nil];
 [_pieChartView reloadData];
 */
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
