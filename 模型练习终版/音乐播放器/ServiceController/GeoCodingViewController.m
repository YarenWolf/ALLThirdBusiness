//
//  Geo-codingViewController.m
//  音乐播放器
//  Created by ISD1510 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
#import "GeoCodingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIViewController+Extension.h"
@interface GeoCodingViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property(nonatomic,strong)CLGeocoder *coder;
@property(nonatomic,strong)CLLocationManager *manager;
@end

@implementation GeoCodingViewController
-(CLGeocoder *)coder{
    if (!_coder) {
        _coder=[CLGeocoder new];
    }return _coder;
}
-(CLLocationManager *)manager{
    if (!_manager) {
        _manager=[[CLLocationManager alloc]init];
    }return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    MKMapView *mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:mapView];
    //地理编码
    [self geographyCodingAndUncoding];
    //以下是定位
    self.manager.delegate=self;
    //判断ios操作系统的版本
    if([[UIDevice currentDevice].systemVersion doubleValue]>=8.0){//征求用户同意(Info.plist分别添加key)
        [self.manager requestWhenInUseAuthorization];//允许应用在前台定位（使用期间）
    }else{
        [self.manager startUpdatingLocation];
    }
    //添加手势调用停止定位的功能
    UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self.manager action:@selector(stopUpdatingLocation)];
    longpress.minimumPressDuration=2;
    [self.view addGestureRecognizer:longpress];
}
-(void)geographyCodingAndUncoding{
    //地理编码：（城市，地区-》经纬度）
    NSString *cityName=@"上海";
    [self.coder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //返回的速度慢
        if (!error) {
            for (CLPlacemark *placemark in placemarks) {
                [self PrintCacheData:[NSString stringWithFormat:@"返回的地标信息:%f:%f",placemark.location.coordinate.longitude,placemark.location.coordinate.latitude]];
            }
        }
        //反地理编码
        CLLocation *location=[[CLLocation alloc]initWithLatitude:29.554 longitude:118.2432];
        [self.coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //经纬度所在的详细信息（字典）
            if(!error){
                for (CLPlacemark *placemark in placemarks) {
                    [self PrintCacheData:[NSString stringWithFormat:@"详细信息:%@",placemark.addressDictionary]];
                }
            }
        }];
    }];
}
#pragma mark ManagerDelegate 以下是定位的相关知识
//用户是否同意
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse://设置精确度(didUpdateLocation调用次数.单位：米
            self.manager.distanceFilter=10;[self.manager startUpdatingLocation];break;
        case kCLAuthorizationStatusNotDetermined:[self PrintCacheData:@"用户不允许定位"];
        default:break;
    }
}
//用户的位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    for (CLLocation *location in locations) {
        [self PrintCacheData:[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude]];
    }
}
@end
