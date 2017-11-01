//
//  MCBarChartView.m
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCBarChartView.h"
#import "MCChartInformationView.h"
#define BAR_CHART_TOP_PADDING 30
#define BAR_CHART_LEFT_PADDING 40
#define BAR_CHART_RIGHT_PADDING 8
#define BAR_CHART_TEXT_HEIGHT 40
CGFloat static const kChartViewUndefinedCachedHeight = -1.0f;
@interface MCBarChartView ()<CAAnimationDelegate>{
    UIScrollView *_scrollView;
    CGFloat _chartHeight;
}
@property (nonatomic, assign) NSUInteger sections;
@property (nonatomic, assign) CGFloat paddingSection;
@property (nonatomic, assign) CGFloat paddingBar;
@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) CGFloat cachedMinHeight;
@property (nonatomic, strong)NSArray *titles;
@end
@implementation MCBarChartView
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {[self initialization];}
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {[self initialization];}
    return self;
}
- (void)initialization {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.bounds.size.width;
    _chartHeight = self.bounds.size.height - BAR_CHART_TOP_PADDING - BAR_CHART_TEXT_HEIGHT;
    _unitOfYAxis = @"";
    _numberOfYAxis = 5;
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BAR_CHART_LEFT_PADDING, 0, width - BAR_CHART_RIGHT_PADDING - BAR_CHART_LEFT_PADDING, CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.dataArray == nil) {
        [self reloadBarWithAnimate:NO];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateWithContext:context];
}
#pragma mark - Draw Coordinate
- (void)drawCoordinateWithContext:(CGContextRef)context {
    CGFloat width = self.bounds.size.width;
    CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
    CGContextMoveToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING - 1);
    CGContextAddLineToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - BAR_CHART_RIGHT_PADDING + 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
}
#pragma mark - Height
- (CGFloat)normalizedHeightForRawHeight:(NSNumber *)rawHeight {
    CGFloat value = [rawHeight floatValue];
    CGFloat maxHeight = [self.maxValue floatValue];
    return value/maxHeight * _chartHeight;
}
- (id)maxValue{
    if (_maxValue == nil) {
        if ([self cachedMaxHeight] != kChartViewUndefinedCachedHeight) {
            _maxValue = @([self cachedMaxHeight]);
        }
    }return _maxValue;
}
- (CGFloat)cachedMinHeight{
    if(_cachedMinHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_dataArray];
        for (NSArray *array in chartValues) {
            for (NSNumber *number in array) {
                CGFloat height = [number floatValue];
                if (height < _cachedMinHeight) {
                    _cachedMinHeight = height;
                }
            }
        }
    }return _cachedMinHeight;
}
- (CGFloat)cachedMaxHeight{
    if (_cachedMaxHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_dataArray];
        for (NSArray *array in chartValues) {
            for (NSNumber *number in array) {
                CGFloat height = [number floatValue];
                if (height > _cachedMaxHeight) {
                    _cachedMaxHeight = height;
                }
            }
        }
    }return _cachedMaxHeight;
}
#pragma mark - Reload Data
- (void)fillDataWithParameters:(NSDictionary*)parameters dataArray:(NSMutableArray*)dataArray titleArray:(NSArray*)titleArray barsNInSection:(barsNInSectionBlock)barsN barValue:(barValueBlock)barvalue barColor:(barColorBlock)barcolor sectionColor:(sectionColorBlock)sectioncolor information:(informationBlock)information hintView:(hintViewBlock)hintview didSelectBarAtIndex:(actionBlock)actionblock{
    NSAssert(titleArray, @"titleArray不能为空!");
    [self setValuesForKeysWithDictionary:parameters];
    _titles = titleArray;
    CGFloat contentWidth = _paddingSection;
    if(!dataArray){
        _sections = titleArray.count;
        dataArray = [NSMutableArray arrayWithCapacity:_sections];
        for (NSUInteger i = 0; i < _sections; i ++) {
            NSUInteger barCount = barsN(i);
            contentWidth += barCount * _barWidth + (barCount - 1) * _paddingBar + _paddingSection;
            NSMutableArray *barArray = [NSMutableArray arrayWithCapacity:barCount];
            for (NSInteger j = 0; j < barCount; j ++) {
                id value = barvalue(i,j);
                [barArray addObject:value];
            }
            [dataArray addObject:barArray];
        }
    }else{
        _sections = dataArray.count;
        for (NSUInteger i = 0; i < _sections; i ++) {
            NSUInteger barCount = barsN(i);
            contentWidth += barCount * _barWidth + (barCount - 1) * _paddingBar + _paddingSection;
        }
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
    _dataArray = [[NSMutableArray alloc] initWithArray:dataArray];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {[view removeFromSuperview];}
    }
    CGFloat chartYOffset = _chartHeight + BAR_CHART_TOP_PADDING;
    CGFloat unitHeight = _chartHeight/_numberOfYAxis;
    CGFloat unitValue = [self.maxValue floatValue]/_numberOfYAxis;
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chartYOffset - unitHeight * i - 10, BAR_CHART_LEFT_PADDING - 2, 20)];
        textLabel.textColor = _colorOfYText;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 0;
        textLabel.text = [NSString stringWithFormat:@"%.0f%@", unitValue * i, _unitOfYAxis];
        [self addSubview:textLabel];
    }
    self.barcolorblock = barcolor;
    self.sectioncolorblock = sectioncolor;
    self.informationblock = information;
    self.hintblock = hintview;
    self.actionblock = actionblock;
    self.barsNblock = barsN;
    self.barvalueblock = barvalue;
}
- (void)reloadBarWithAnimate:(BOOL)animate {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CGFloat xSection = _paddingSection;
    CGFloat xOffset = _paddingSection + _barWidth/2;
    CGFloat chartYOffset = _chartHeight + BAR_CHART_TOP_PADDING;
    for (NSInteger section = 0; section < _sections; section ++) {
        NSArray *array = _dataArray[section];
        for (NSInteger index = 0; index < array.count; index ++) {
            CGFloat height = [self normalizedHeightForRawHeight:array[index]];
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:CGPointMake(xOffset, chartYOffset)];
            [bezierPath addLineToPoint:CGPointMake(xOffset, chartYOffset - height)];
            CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
            shapeLayer.lineWidth = _barWidth;
            shapeLayer.path = bezierPath.CGPath;
            UIColor *barcolor =  self.barcolorblock(section,index);
            shapeLayer.strokeColor = barcolor.CGColor;
            [_scrollView.layer addSublayer:shapeLayer];
            if (animate) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.fromValue = @(0.0);
                animation.toValue = @(1.0);
                animation.repeatCount = 1.0;
                animation.duration = height/_chartHeight * 0.75;
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                [shapeLayer addAnimation:animation forKey:@"animation"];
            }
            NSTimeInterval delay = animate ? 0.75 : 0.0;
            UIView *hintView = self.hintblock(section,index);
                if (hintView) {
                    hintView.center = CGPointMake(xOffset, chartYOffset - height - CGRectGetHeight(hintView.bounds)/2);
                    hintView.alpha = 0.0;
                    [_scrollView addSubview:hintView];
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        hintView.alpha = 1.0;
                    } completion:nil];
                }
            NSString *information = self.informationblock(section,index);
                if (information) {
                    MCChartInformationView *informationView = [[MCChartInformationView alloc] initWithText:information];
                    informationView.center = CGPointMake(xOffset, chartYOffset - height - CGRectGetHeight(informationView.bounds)/2);
                    informationView.alpha = 0.0;
                    [_scrollView addSubview:informationView];
                    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        informationView.alpha = 1.0;
                    } completion:nil];
                }
            xOffset += _barWidth + (index == array.count - 1 ? 0 : _paddingBar);
        }
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSection - _paddingSection/2, _chartHeight + BAR_CHART_TOP_PADDING, xOffset - xSection + _paddingSection, BAR_CHART_TEXT_HEIGHT)];
            textLabel.textColor = _colorOfXText;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = [UIFont systemFontOfSize:14];
            textLabel.numberOfLines = 0;
            textLabel.text =  _titles[section];
            [_scrollView addSubview:textLabel];
        xOffset += _paddingSection;
        xSection = xOffset;
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
