//
//  SureMinionsView.m
//  SureOFOCopy
//
//  Created by 刘硕 on 2017/7/3.
//  Copyright © 2017年 刘硕. All rights reserved.
//

#import "SureMinionsView.h"
#import <CoreMotion/CoreMotion.h>
@interface SureMinionsEyesView : UIView
//初始速度 默认为10 初始速度越大眼球的移动越快
@property (nonatomic, strong) UIImageView *eyesImageView;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end
@implementation SureMinionsEyesView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //设置初始化速度
        _eyesImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"minions_eyes"]];
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = self.bounds.size.width / 2;
        self.clipsToBounds = YES;
        _eyesImageView.frame = CGRectMake(0, 0, 37 / 2, 39 / 2);
        _eyesImageView.center = self.center;
        [self addSubview:_eyesImageView];
        [self createMotion];
    }return self;
}
- (void)createMotion {
    _motionManager = [[CMMotionManager alloc] init];
    if ([_motionManager isAccelerometerAvailable]){
        _motionManager.accelerometerUpdateInterval = 0.01;
//        _motionManager.gyroUpdateInterval = 0.01;
//        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
//            NSLog(@"%f%f%f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
//        }];
        CGFloat _velocity = 10;
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (!error) {
                CGFloat pointX = _eyesImageView.center.x + accelerometerData.acceleration.x * _velocity; //眼睛将要移动到的x轴坐标
                CGFloat pointY = _eyesImageView.center.y - accelerometerData.acceleration.y * _velocity; //眼睛将要移动到的y轴坐标
                if (pointX < _eyesImageView.bounds.size.width / 2) {
                    pointX = _eyesImageView.bounds.size.width / 2;
                } else if(pointX > self.bounds.size.width - _eyesImageView.bounds.size.width / 2){
                    pointX = self.bounds.size.width - _eyesImageView.bounds.size.width / 2;
                }
                if (pointY < _eyesImageView .bounds.size.height / 2) {
                    pointY = _eyesImageView.bounds.size.height / 2;
                }else if (pointY > self.bounds.size.height - _eyesImageView.bounds.size.height / 2){
                    pointY = self.bounds.size.height - _eyesImageView.bounds.size.height / 2;
                }
                _eyesImageView.center = CGPointMake(pointX, pointY); //更新眼睛位置
                CGFloat r = self.bounds.size.width / 2 - self.eyesImageView.bounds.size.width / 2; //半径
                CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2); //圆点
                CGPoint currentPoint = _eyesImageView.center;//当前眼睛中心点
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.eyesImageView.bounds.size.width / 2, self.eyesImageView.bounds.size.width / 2, self.bounds.size.width  - self.eyesImageView.bounds.size.width , self.bounds.size.width - self.eyesImageView.bounds.size.width)];
                if (CGPathContainsPoint(path.CGPath, NULL, self.eyesImageView.center, NO)) {//判断眼睛是否在圆内
                }else{
                    //获取当前点与圆点之间的距离
                    CGFloat distance = sqrt(pow(center.x - currentPoint.x, 2) + pow(currentPoint.y - center.y, 2));
                    CGFloat x = center.x - r / distance * (center.x - currentPoint.x);
                    CGFloat y = center.y + r / distance * (currentPoint.y - center.y);
                    _eyesImageView.center = CGPointMake(x, y);
                }
            } else {
                NSLog(@"%@",error);
            }
        }];
    }
}
@end
@implementation SureMinionsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = redcolor;
        UIImageView *_backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        UIImageView *_grassImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _grassImageView.image = [UIImage imageNamed:@"minions_grass"];
        _backgroundImageView.contentMode = _grassImageView.contentMode = UIViewContentModeScaleAspectFit;
        SureMinionsEyesView*_rightEyeView = [[SureMinionsEyesView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.25, self.frame.size.height*0.25,self.frame.size.width*0.3,self.frame.size.width*0.3)];
        SureMinionsEyesView*_leftEyeView = [[SureMinionsEyesView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.55, _rightEyeView.frame.origin.y, _rightEyeView.frame.size.width,_rightEyeView.frame.size.width)];
        [self addSubview:_backgroundImageView];
        [self addSubview:_grassImageView];
        [self addSubview:_leftEyeView];
        [self addSubview:_rightEyeView];
    }
    return self;
}
@end
