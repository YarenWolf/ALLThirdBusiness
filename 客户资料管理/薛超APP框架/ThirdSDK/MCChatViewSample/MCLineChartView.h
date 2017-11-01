#import <UIKit/UIKit.h>
CGFloat static const kChartViewUndefinedValue = -1.0f;
typedef id (^lineValueBlock)(NSInteger number, NSInteger index);
typedef NSUInteger (^lineCountBlock)(NSInteger number);
typedef UIColor* (^colorBlock)(NSInteger number);
typedef CGFloat (^lineWidthBlock)(NSInteger number);
typedef NSString* (^titleBlock)(NSInteger number);
typedef UIView* (^hintViewBlock)(NSInteger number, NSInteger index);
typedef UIView* (^pointViewBlock)(NSInteger number, NSInteger index);
typedef NSString* (^informationBlock)(NSInteger number, NSInteger index);
@interface MCLineChartView : UIView
@property (nonatomic, strong) id minValue;
@property (nonatomic, strong) id maxValue;
@property (nonatomic, assign) NSInteger numberOfYAxis;
@property (nonatomic, copy) NSString *unitOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYAxis;
@property (nonatomic, strong) UIColor *colorOfYText;
@property (nonatomic, assign) CGFloat yFontSize;
@property (nonatomic, assign) BOOL oppositeY;
@property (nonatomic, assign) BOOL hideYAxis;
@property (nonatomic, strong) UIColor *colorOfXAxis;
@property (nonatomic, strong) UIColor *colorOfXText;
@property (nonatomic, assign) CGFloat xFontSize;
@property (nonatomic, assign) BOOL solidDot;
@property (nonatomic, assign) CGFloat dotRadius;
- (void)reloadData;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,copy)lineValueBlock lineValueBlock;
@property (nonatomic,copy)lineCountBlock lineCountBlock;
@property (nonatomic,copy)colorBlock colorBlock;
@property (nonatomic,copy)lineWidthBlock lineWidthBlock;
@property (nonatomic,copy)titleBlock titleBlock;
@property (nonatomic,copy)hintViewBlock hintViewBlock;
@property (nonatomic,copy)pointViewBlock pointViewBlock;
@property (nonatomic,copy)informationBlock informationBlock;


- (void)fillDataWithParameters:(NSDictionary*)parameters
                     dataArray:(NSMutableArray*)dataArray
         lineCountAtlineNumber:(lineCountBlock)lineCountBlock
             valueAtLineNumber:(lineValueBlock)lineValueBlock
       lineWidthWithLineNumber:(lineWidthBlock)lineWidthBlock
             titleAtLineNumber:(titleBlock)titleBlock
       lineColorWithLineNumber:(colorBlock)colorBlock
     hintViewOfDotInLineNumber:(hintViewBlock)hintViewBlock
    pointViewOfDotInLineNumber:(pointViewBlock)pointViewBlock
  informationOfDotInLineNumber:(informationBlock)informationBlock;

@end
//范例
/*
 _titles = @[@"第一次月考", @"第二次月考", @"第三次月考", @"第四次月考", @"第五次月考"];
 _dataSource = @[@100, @245, @180, @165, @225];
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@10,@"dotRadius",@YES,@"oppositeY",@1,@"minValue",@700,@"maxValue",@YES,@"solidDot",@7,@"numberOfYAxis",[UIColor whiteColor],@"colorOfXAxis", [UIColor whiteColor],@"colorOfXText",[UIColor whiteColor],@"colorOfYAxis",[UIColor whiteColor],@"colorOfYText",nil];
 _lineChartView = [[MCLineChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
 [_lineChartView fillDataWithParameters:dict dataArray:[NSMutableArray arrayWithArray:_dataSource] lineCountAtlineNumber:^NSUInteger(NSInteger number) {
 return [_dataSource count];
 } valueAtLineNumber:^id(NSInteger number, NSInteger index) {
 return _dataSource[index];
 } lineWidthWithLineNumber:^CGFloat(NSInteger number) {
 return 1;
 } titleAtLineNumber:^NSString *(NSInteger number) {
 return _titles[number];
 } lineColorWithLineNumber:^UIColor *(NSInteger number) {
 if (number == 0) { return [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
 } else if (number == 1) {return [UIColor lightGrayColor];
 } else if (number == 2) {return [UIColor redColor];
 } else {return [UIColor yellowColor];
 }
 } hintViewOfDotInLineNumber:^UIView *(NSInteger number, NSInteger index) {
 return nil;
 } pointViewOfDotInLineNumber:^UIView *(NSInteger number, NSInteger index) {
 return nil;
 } informationOfDotInLineNumber:^NSString *(NSInteger number, NSInteger index) {
 if (index == 0 || index == _dataSource.count - 1) {
 return [NSString stringWithFormat:@"%@名", _dataSource[index]];
 }
 return nil;
 }];
 [self.view addSubview:_lineChartView];
 [_lineChartView reloadData];
*/
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
