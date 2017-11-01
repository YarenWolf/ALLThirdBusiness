//
//  MCCoverageChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
#import <UIKit/UIKit.h>
typedef id (^coverageValueBlock)(NSInteger index);
typedef UIColor* (^colorBlock)(NSInteger index);
typedef NSString* (^titleBlock)(NSInteger index);
typedef NSAttributedString* (^attributedTitleBlock)(NSInteger index);
@interface MCCoverageChartView : UIView
- (void)reloadData;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat maxRadius;
@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, strong) id maxValue;
@property (nonatomic, assign) BOOL showCoverageInfo;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSAttributedString *centerTitle;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic,copy)coverageValueBlock coverageValueBlock;
@property (nonatomic,copy)colorBlock colorBlock;
@property (nonatomic,copy)titleBlock titleBlock;
@property (nonatomic,copy)attributedTitleBlock attributedTitleBlock;


- (void)fillDataWithParameters:(NSDictionary*)parameters
                     dataArray:(NSMutableArray*)dataArray
          valueOfCoverageAtIndex:(coverageValueBlock)coverageValueBlock
                  colorAtIndex:(colorBlock)colorBlock
                  titleAtIndex:(titleBlock)titleBlock
               attributedTitle:(attributedTitleBlock)attributedTitleBlock
                   centerTitle:(NSAttributedString*)centerTitle
                    centerView:(UIView*)centerView;

@end

//范例
/*
 _dataSource = @[@13, @20, @17, @20];
 _coverageChartView = [[MCCoverageChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@100,@"maxRadius",@30,@"minRadius",@24,@"maxValue" ,nil];
 _coverageChartView.centerPoint =CGPointMake(120, 150);
 _coverageChartView.showCoverageInfo = YES;
 [_coverageChartView fillDataWithParameters:dict dataArray:[NSMutableArray arrayWithArray:_dataSource] valueOfCoverageAtIndex:^id(NSInteger index) {
 return _dataSource[index];
 } colorAtIndex:^UIColor *(NSInteger index) {
 switch (index) { case 0:return [UIColor colorWithRed:98/255.0 green:147/255.0 blue:215/255.0 alpha:1.0];
 case 1:return [UIColor colorWithRed:213/255.0 green:108/255.0 blue:70/255.0 alpha:1.0];
 case 2:return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
 case 3:return [UIColor colorWithRed:97/255.0 green:84/255.0 blue:168/255.0 alpha:1.0];
 case 4:return [UIColor colorWithRed:255/255.0 green:176/255.0 blue:61/255.0 alpha:1.0];
 default:return [UIColor grayColor];
 }
 
 } titleAtIndex:^NSString *(NSInteger index) {
 NSArray *title = @[@"其他", @"粗心", @"掌握不熟练", @"知识点不会"];
 return [NSString stringWithFormat:@"%@%@%%", title[index], _dataSource[index]];
 } attributedTitle:^NSAttributedString *(NSInteger index) {
 return nil;
 } centerTitle:nil centerView:nil];
 [self.view addSubview:_coverageChartView];
 
 [_coverageChartView reloadData];
 */
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
