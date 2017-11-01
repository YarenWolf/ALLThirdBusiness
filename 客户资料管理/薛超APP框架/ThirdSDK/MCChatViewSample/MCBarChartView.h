//
//  MCBarChartView.h
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSInteger (^barsNInSectionBlock)(NSInteger section);
typedef id (^barValueBlock)(NSInteger section,NSInteger index);
typedef UIColor* (^barColorBlock)(NSInteger section,NSInteger index);
typedef UIColor* (^sectionColorBlock)(NSInteger section);
typedef NSString* (^informationBlock)(NSInteger section,NSInteger index);
typedef UIView* (^hintViewBlock)(NSInteger section,NSInteger index);
typedef void (^actionBlock)(NSInteger index);

@interface MCBarChartView : UIView
@property (nonatomic, strong) id maxValue;
@property (nonatomic, assign) NSInteger numberOfYAxis;
@property (nonatomic, copy  ) NSString *unitOfYAxis;//纵坐标单位
@property (nonatomic, strong) UIColor *colorOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYText;
@property (nonatomic, strong) UIColor *colorOfXAxis;
@property (nonatomic, strong) UIColor *colorOfXText;
- (void)reloadBarWithAnimate:(BOOL)animate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,copy) barsNInSectionBlock barsNblock;
@property (nonatomic,copy) barValueBlock barvalueblock;
@property (nonatomic,copy) barColorBlock barcolorblock;
@property (nonatomic,copy) sectionColorBlock sectioncolorblock;
@property (nonatomic,copy) informationBlock informationblock;
@property (nonatomic,copy) hintViewBlock hintblock;
@property (nonatomic,copy) actionBlock actionblock;
/*
 dataArray:图标的数据包括分组和组内数据
 titleArray:横坐标标题组
 parameters:{
    tag = 222;
    numberOfYAxis=5;
    maxValue = @150;
    unitOfYAxis = @"分";
    barWidth = 5;
    sectionPadding = 5;
    barPadding = 5;
    colorOfXAxis = [UIColor whiteColor];
    colorOfXText = [UIColor whiteColor];
    colorOfYAxis = [UIColor whiteColor];
    colorOfYText = [UIColor whiteColor];
 }
 barColor:每个柱子的颜色
 sectionColor:每个区的颜色
 information:柱子上面的标注
 hintView:渲染视图
 //SectionN = dataArray.count //titleOfbar = titleArray[section]
 barsNInSection:每个项目里面有几个分项
 barValue:坐标值
 */
- (void)fillDataWithParameters:(NSDictionary*)parameters
                     dataArray:(NSMutableArray*)dataArray
                    titleArray:(NSArray*)titleArray
                barsNInSection:(barsNInSectionBlock)barsN
                      barValue:(barValueBlock)barvalue
                      barColor:(barColorBlock)barcolor
                  sectionColor:(sectionColorBlock)sectioncolor
                   information:(informationBlock)information
                      hintView:(hintViewBlock)hintview
           didSelectBarAtIndex:(actionBlock)actionblock;
@end
#pragma mark 范例
/*
 NSArray *_titles = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"];
 NSMutableArray *_dataSource = [NSMutableArray arrayWithArray:@[@[@120], @[@115.0], @[@50], @[@138], @[@110], @[@100]]];
 MCBarChartView *_barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(0, 20, APPW, 260)];
 [self.view addSubview:_barChartView];
 NSMutableDictionary *datasoureceP = [NSMutableDictionary dictionaryWithObjectsAndKeys:@111,@"tag",@150,@"maxValue",@"分" ,@"unitOfYAxis",@10 ,@"numberOfYAxis",redcolor,@"colorOfXAxis",[UIColor whiteColor],@"colorOfXText",redcolor,@"colorOfYAxis",[UIColor whiteColor],@"colorOfYText",@25,@"barWidth",@15,@"paddingSection",@5,@"paddingBar",nil];
 [_barChartView fillDataWithParameters:datasoureceP dataArray:nil titleArray:_titles barsNInSection:^NSInteger(NSInteger section) {
 return 1;
 } barValue:^id(NSInteger section, NSInteger index) {
 return _dataSource[section][index];
 } barColor:^UIColor *(NSInteger section, NSInteger index) {
 if (section == 0) {return yellowcolor;}
 return [UIColor greenColor];
 } sectionColor:^UIColor *(NSInteger section) {
 return [UIColor grayColor];
 } information:^NSString *(NSInteger section, NSInteger index) {
 if ([_dataSource[section][index] floatValue] >= 130) {return @"优秀";}else {return @"不及格";}
 } hintView:^UIView *(NSInteger section, NSInteger index) {
 return nil;
 } didSelectBarAtIndex:^(NSInteger index) {
 DLog(@"点击了某某某");
 }];
 
 [_barChartView reloadBarWithAnimate:NO];
*/
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
