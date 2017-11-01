//
//  MCRadarChartView.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
#import "MCRadarChartView.h"
//
//  MCRadarLayer.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MCRadarLayer : CALayer

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, strong) NSArray *radius;

@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGColorRef radarFillColor;
@property (nonatomic, assign) CGFloat pointRadius;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGColorRef fillColor;
@property (nonatomic, assign) CGColorRef strokeColor;

@property (nonatomic, assign) CGFloat progress;

- (void)reloadRadiusWithAnimate:(BOOL)animate;
- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
//
//  MCRadarLayer.m
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

@implementation MCRadarLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _drawPoints = YES;
        _radarFillColor = [UIColor clearColor].CGColor;
        _pointRadius = 3.0;
        _progress = 1.0;
    }
    return self;
}

- (instancetype)initWithLayer:(MCRadarLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        _drawPoints = layer.drawPoints;
        _radarFillColor = layer.radarFillColor;
        _pointRadius = layer.pointRadius;
        _lineWidth = layer.lineWidth;
        _fillColor = layer.fillColor;
        _strokeColor = layer.strokeColor;
        _radius = layer.radius;
        _centerPoint = layer.centerPoint;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetFillColorWithColor(ctx, _fillColor);
    CGContextSetStrokeColorWithColor(ctx, _strokeColor);
    
    CGFloat layerRadius = [[_radius firstObject] floatValue] * _progress;
    CGPoint point = [self pointAtIndex:0 radius:layerRadius];
    CGContextMoveToPoint(ctx, point.x, point.y);
    
    for (NSInteger index = 1; index < _radius.count; index ++) {
        CGFloat layerRadius = [_radius[index] floatValue] * _progress;
        CGPoint point = [self pointAtIndex:index radius:layerRadius];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    if (_drawPoints) {
        CGContextSetLineWidth(ctx, _lineWidth);
        CGContextSetFillColorWithColor(ctx, _radarFillColor);
        CGContextSetStrokeColorWithColor(ctx, _strokeColor);
        for (NSInteger index = 0; index < _radius.count; index ++) {
            CGFloat layerRadius = [_radius[index] floatValue] * _progress;
            CGPoint point = [self pointAtIndex:index radius:layerRadius];
            CGContextMoveToPoint(ctx, point.x + _pointRadius, point.y);
            CGContextAddArc(ctx, point.x, point.y, _pointRadius, 0, 2 * M_PI, NO);
        }
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
}

- (CGPoint)pointAtIndex:(NSInteger)index radius:(CGFloat)radius {
    CGFloat angleOfValue = 2 * M_PI/_radius.count;
    return CGPointMake(_centerPoint.x + radius * sin(index * angleOfValue), _centerPoint.y - radius * cos(index * angleOfValue));
}

- (void)reloadRadiusWithAnimate:(BOOL)animate {
    [self reloadRadiusWithAnimate:animate duration:0.75];
}

- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration {
    if (animate) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        animation.repeatCount = 1.0;
        animation.duration = duration;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [self addAnimation:animation forKey:@"animation"];
    } else {
        [self setNeedsDisplay];
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
#define RADAR_VIEW_PADDING 10.0
#define RADAR_TITLE_PADDING 2.0
@interface MCRadarChartView ()
@property (nonatomic, assign) NSInteger numberOfValue;
@property (nonatomic, strong) NSMutableArray *chartDataSource;
@end
@implementation MCRadarChartView
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
    _maxValue = @1;
    _minValue = @0;
    _centerPoint = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    _radius = MIN(CGRectGetWidth(self.bounds)/2 - RADAR_VIEW_PADDING * 2, CGRectGetHeight(self.bounds)/2 - RADAR_VIEW_PADDING * 4);
    _numberOfLayer = 4;
    _drawPoints = YES;
    _pointRadius = 3.0;
    _lineWidth = 1.0;
    _strokeColor = [UIColor greenColor];
    _fillColor = [UIColor clearColor];
    _radarLineWidth = 1.0;
    _radarStrokeColor = [UIColor lightGrayColor];
    _radarFillColor = [UIColor whiteColor];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawTitle];
    [self drawRadarWithContext:context];
}
- (void)drawTitle {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    if (self.attributedTitleBlock) {
        for (NSInteger index = 0; index < _numberOfValue; index ++) {
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitleBlock(index)];
            [title addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
            
            CGPoint radarPoint = [self pointAtIndex:index radius:_radius];
            CGRect titleRect = [self titleRectWithTitle:title radarPoint:radarPoint];
            [title drawInRect:titleRect];
        }
    } else if (self.titleBlock) {
        for (NSInteger index = 0; index < _numberOfValue; index ++) {
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.titleBlock(index) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: paragraphStyle}];
            
            CGPoint radarPoint = [self pointAtIndex:index radius:_radius];
            CGRect titleRect = [self titleRectWithTitle:title radarPoint:radarPoint];
            [title drawInRect:titleRect];
        }
    }
}

- (void)drawRadarWithContext:(CGContextRef)context {
    [_radarFillColor setFill];
    [_radarStrokeColor setStroke];
    CGContextSetLineWidth(context, _radarLineWidth);
    CGContextSaveGState(context);
    for (NSInteger layer = 0; layer < _numberOfLayer; layer ++) {
        CGFloat layerRadius = (1 - layer * 1.0/_numberOfLayer) * _radius;
        CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - layerRadius);
        for (NSInteger index = 1; index < _numberOfValue; index ++) {
            CGPoint point = [self pointAtIndex:index radius:layerRadius];
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextClosePath(context);
        if (layer == 0) {
            CGContextDrawPath(context, kCGPathFillStroke);
        } else {
            CGContextStrokePath(context);
        }
    }
    for (NSInteger index = 0; index < _numberOfValue; index ++) {
        CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
        CGPoint point = [self pointAtIndex:index radius:_radius];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

#pragma mark - Private
- (CGPoint)pointAtIndex:(NSInteger)index radius:(CGFloat)radius {
    CGFloat angleOfValue = 2 * M_PI/_numberOfValue;
    return CGPointMake(_centerPoint.x + radius * sin(index * angleOfValue), _centerPoint.y - radius * cos(index * angleOfValue));
}

- (CGRect)titleRectWithTitle:(NSAttributedString *)title radarPoint:(CGPoint)radarPoint {
    CGSize titleSize = [title size];
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    if (radarPoint.x > _centerPoint.x) {
        xOffset = radarPoint.x + RADAR_TITLE_PADDING;
    } else if (radarPoint.x == _centerPoint.x) {
        xOffset = radarPoint.x - titleSize.width/2;
    } else {
        xOffset = radarPoint.x - titleSize.width - RADAR_TITLE_PADDING;
    }
    if (radarPoint.y > _centerPoint.y) {
        yOffset = radarPoint.y;
    } else if (radarPoint.y == _centerPoint.y) {
        yOffset = radarPoint.y - titleSize.height/2;
    } else {
        yOffset = radarPoint.y - titleSize.height;
    }
    return CGRectMake(xOffset, yOffset, titleSize.width, titleSize.height);
}
-(void)fillDataWithParameters:(NSDictionary *)parameters dataArray:(NSMutableArray *)dataArray valueAtIndex:(ValueBlock)ValueBlock attributedTitleAtIndex:(attributedTitleBlock)attributedTitleBlock titleAtIndex:(titleBlock)titleBlock{
    [self setValuesForKeysWithDictionary:parameters];
    self.dataArray = dataArray;
    self.ValueBlock = ValueBlock;
    self.attributedTitleBlock = attributedTitleBlock;
    self.titleBlock = titleBlock;
}
#pragma mark - Reload Data
- (void)reloadData {
    [self reloadChartDataSourceAnimate:YES];
}
- (void)reloadChartDataSourceAnimate:(BOOL)animate{
    _numberOfValue = self.dataArray.count;
    NSAssert(_numberOfValue > 3, @"The return numberOfValue must greater than 3");
    _chartDataSource = [[NSMutableArray alloc] initWithCapacity:_numberOfValue];
    for (NSInteger index = 0; index < _numberOfValue; index ++) {
        id value = self.ValueBlock(index);
        [_chartDataSource addObject:value];
#ifdef DEBUG
        float floatValue = [value floatValue];
        if (floatValue > [_maxValue floatValue] || floatValue < [_minValue floatValue]) {}
#endif
    }
    [self setNeedsDisplay];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    MCRadarLayer *radarLayer = [[MCRadarLayer alloc] init];
    radarLayer.frame = self.bounds;
    radarLayer.fillColor = _fillColor.CGColor;
    radarLayer.strokeColor = _strokeColor.CGColor;
    radarLayer.lineWidth = _lineWidth;
    radarLayer.radarFillColor = _radarFillColor.CGColor;
    radarLayer.centerPoint = _centerPoint;
    
    NSMutableArray *radius = [NSMutableArray arrayWithCapacity:_numberOfValue];
    for (NSInteger i = 0; i < _numberOfValue; i ++) {
        float floatValue = [_chartDataSource[i] floatValue];
        CGFloat layerRadius = floatValue/[_maxValue floatValue] * _radius;
        [radius addObject:@(layerRadius)];
    }
    radarLayer.radius = radius;
    [self.layer addSublayer:radarLayer];
    [radarLayer reloadRadiusWithAnimate:animate];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
