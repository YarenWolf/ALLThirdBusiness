//
//  MCCoverageChartView.m
//  MCChartView
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
#import "MCCoverageChartView.h"
//
//  MCCoverageLayer.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MCCoverageLayer : CALayer

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, assign) CGFloat maxRadius;

@property (nonatomic, assign) CGColorRef coverageColor;

@property (nonatomic, assign) CGFloat radius;

- (void)reloadRadiusWithAnimate:(BOOL)animate;
- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
//
//  MCCoverageLayer.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//


@implementation MCCoverageLayer

- (instancetype)initWithLayer:(MCCoverageLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        self.minRadius = layer.minRadius;
        self.maxRadius = layer.maxRadius;
        self.centerPoint = layer.centerPoint;
        self.startAngle = layer.startAngle;
        self.endAngle = layer.endAngle;
        self.coverageColor = layer.coverageColor;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if([key isEqualToString:@"radius"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat lineWidth = _radius - _minRadius;
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextAddArc(ctx, _centerPoint.x, _centerPoint.y, _radius - lineWidth/2, _startAngle, _endAngle, YES);
    CGContextSetStrokeColorWithColor(ctx, _coverageColor);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextStrokePath(ctx);
}

- (void)reloadRadiusWithAnimate:(BOOL)animate {
    [self reloadRadiusWithAnimate:animate duration:1.5];
}

- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration {
    if (animate) {
        _radius = _maxRadius;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"radius"];
        animation.fromValue = @(_minRadius + 10);
        animation.toValue = @(_maxRadius);
        animation.repeatCount = 1;
        animation.duration = duration;
        animation.fillMode = kCAFillModeBoth;
        [self addAnimation:animation forKey:@"angle_key"];
    } else {
        _radius = _maxRadius;
        [self setNeedsDisplay];
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
#define COVERAGE_CHART_PADDING 16.0
#define COVERAGE_INFO_WIDTH 16.0
#define COVERAGE_INFO_HEIGHT 16.0
#define COVERAGE_INFO_PADDING 16.0
@interface MCCoverageChartView ()
@property (nonatomic, assign) NSInteger numberOfCoverage;
@property (nonatomic, strong) NSMutableArray *chartDataSource;
@property (nonatomic, strong) NSMutableArray *coverageColors;
@property (nonatomic, assign) CGFloat cacheMaxValue;
@end
@implementation MCCoverageChartView
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }return self;
}
- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    _centerPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    _maxRadius = MIN(CGRectGetWidth(self.bounds)/2 - COVERAGE_CHART_PADDING, CGRectGetHeight(self.bounds)/2 - COVERAGE_CHART_PADDING);
    _minRadius = 0;
    _cacheMaxValue = -1.0f;
}
- (CGFloat)cacheMaxValue {
    if (_cacheMaxValue == -1.0f) {
        _cacheMaxValue = [_maxValue floatValue];
        for (id value in _chartDataSource) {
            _cacheMaxValue = MAX([value floatValue], _cacheMaxValue);
        }
    }return _cacheMaxValue;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _maxRadius, 0, 2 * M_PI, 0);
    CGContextStrokePath(context);
    NSAttributedString *title = self.centerTitle;
    CGSize titleSize = [title size];
    [title drawInRect:CGRectMake(_centerPoint.x - titleSize.width, _centerPoint.y - titleSize.height, titleSize.width, titleSize.height)];
    if (_showCoverageInfo) {
        CGFloat yOffset = _centerPoint.y - _maxRadius;
        CGFloat xOffset = _centerPoint.x + _maxRadius + COVERAGE_INFO_PADDING;
        for (NSInteger index = 0; index < _coverageColors.count; index ++) {
            CGContextSetFillColorWithColor(context, [_coverageColors[index] CGColor]);
            CGContextFillRect(context, CGRectMake(xOffset, yOffset, COVERAGE_INFO_WIDTH, COVERAGE_INFO_HEIGHT));
            if(self.attributedTitleBlock){
                NSAttributedString *title = self.attributedTitleBlock(index);
                CGSize titleSize = title.size;
                [title drawInRect:CGRectMake(xOffset + COVERAGE_INFO_WIDTH + 2, yOffset + (COVERAGE_INFO_HEIGHT - titleSize.height)/2, titleSize.width, titleSize.height)];
            }else{
                NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.titleBlock(index) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:COVERAGE_INFO_HEIGHT], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                CGSize titleSize = title.size;
                [title drawInRect:CGRectMake(xOffset + COVERAGE_INFO_WIDTH + 2, yOffset + (COVERAGE_INFO_HEIGHT - titleSize.height)/2, titleSize.width, titleSize.height)];
            }yOffset += 3 * COVERAGE_INFO_HEIGHT/2;
        }
    }
}

- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
   NSInteger numberOfCoverage = self.dataArray.count;
    
    _chartDataSource = [[NSMutableArray alloc] initWithCapacity:numberOfCoverage];
    _coverageColors = [NSMutableArray arrayWithCapacity:numberOfCoverage];
    for (NSInteger index = 0; index < numberOfCoverage; index ++) {
        [_chartDataSource addObject:self.coverageValueBlock(index)];
        UIColor *coverageColor = [UIColor colorWithRed:(index + 1.0)/numberOfCoverage green:1 - (index + 1.0)/numberOfCoverage blue:index * 1.0/numberOfCoverage alpha:1.0];
        coverageColor = self.colorBlock(index);
        [_coverageColors addObject:coverageColor];
    }
    
    CGFloat startAngle = 3 * M_PI_2;
    CGFloat endAngle = 3 * M_PI_2;
    for (NSInteger index = 0; index < numberOfCoverage; index ++) {
        endAngle = startAngle - 2 * M_PI/numberOfCoverage;
        MCCoverageLayer *coverageLayer = [[MCCoverageLayer alloc] init];
        coverageLayer.startAngle = startAngle;
        coverageLayer.endAngle = endAngle;
        coverageLayer.coverageColor = [_coverageColors[index] CGColor];
        coverageLayer.minRadius = _minRadius;
        coverageLayer.maxRadius = [_chartDataSource[index] floatValue]/self.cacheMaxValue * (_maxRadius - _minRadius) + _minRadius;
        coverageLayer.centerPoint = _centerPoint;
        coverageLayer.frame = self.bounds;
        [self.layer addSublayer:coverageLayer];
        
        [coverageLayer reloadRadiusWithAnimate:animate duration:coverageLayer.maxRadius/_maxRadius * 0.75];
        
        startAngle = endAngle;
    }

    if (self.centerView && _minRadius != 0) {
        UIView *view = self.centerView;
        CGFloat scale = MAX(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))/_minRadius;
        view.transform = CGAffineTransformMakeScale(scale, scale);
        view.center = _centerPoint;
        [self addSubview:view];
    }
}
- (void)fillDataWithParameters:(NSDictionary*)parameters
                     dataArray:(NSMutableArray*)dataArray
        valueOfCoverageAtIndex:(coverageValueBlock)coverageValueBlock
                  colorAtIndex:(colorBlock)colorBlock
                  titleAtIndex:(titleBlock)titleBlock
               attributedTitle:(attributedTitleBlock)attributedTitleBlock
                   centerTitle:(NSAttributedString*)centerTitle
                    centerView:(UIView*)centerView{
    
    [self setValuesForKeysWithDictionary:parameters];
    self.dataArray = dataArray;
    self.colorBlock = colorBlock;
    self.titleBlock = titleBlock;
    self.attributedTitleBlock = attributedTitleBlock;
    self.centerTitle = centerTitle;
    self.centerView = centerView;
    self.coverageValueBlock = coverageValueBlock;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
