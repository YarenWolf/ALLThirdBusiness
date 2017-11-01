//
//  MCRadarChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
#import <UIKit/UIKit.h>
typedef id (^ValueBlock)(NSInteger index);
typedef NSAttributedString* (^attributedTitleBlock)(NSInteger index);
typedef NSString* (^titleBlock)(NSInteger index);
@interface MCRadarChartView : UIView
@property (nonatomic, strong) id maxValue;
@property (nonatomic, strong) id minValue;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger numberOfLayer;
@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGFloat pointRadius;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat radarLineWidth;
@property (nonatomic, strong) UIColor *radarStrokeColor;
@property (nonatomic, strong) UIColor *radarFillColor;
- (void)reloadData;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy  ) ValueBlock ValueBlock;
@property (nonatomic, copy  ) attributedTitleBlock attributedTitleBlock;
@property (nonatomic, copy  ) titleBlock titleBlock;;

- (void)fillDataWithParameters:(NSDictionary*)parameters
                     dataArray:(NSMutableArray*)dataArray
             valueAtIndex:(ValueBlock)ValueBlock
             attributedTitleAtIndex:(attributedTitleBlock)attributedTitleBlock
                      titleAtIndex:(titleBlock)titleBlock;

@end
//范例
/*
 _titles = @[@"运算求解", @"创新意识", @"应用意识", @"数据处理", @"抽象概括", @"空间想象", @"推理论证"];
 NSMutableArray *mutableArray = [NSMutableArray array];
 for (NSInteger i = 0; i < _titles.count; i ++) {
 [mutableArray addObject:@((arc4random()%100)/100.0)];
 }
 _dataSource = [NSArray arrayWithArray:mutableArray];
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@100,@"radius",@2,@"pointRadius",redcolor,@"strokeColor",yellowcolor,@"fillColor", nil];
 _radarChartView = [[MCRadarChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
 [_radarChartView fillDataWithParameters:dict dataArray:[NSMutableArray arrayWithArray:_dataSource] valueAtIndex:^id(NSInteger index) {
 return @((arc4random()%100)/100.0);
 } attributedTitleAtIndex:^NSAttributedString *(NSInteger index) {
 return [[NSAttributedString alloc] initWithString:_titles[index] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
 } titleAtIndex:^NSString *(NSInteger index) {
 return _titles[index];
 }];
 [self.view addSubview:_radarChartView];
 [_radarChartView reloadData];
 */
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
