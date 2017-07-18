
//
//  MKMapViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MKMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+Extension.h"
@interface Annotation : NSObject<MKAnnotation>
//大头针的地理位置
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property(nonatomic,strong)UIImage *image;
@end
@implementation Annotation
@end
@interface MKMapViewController ()<MKMapViewDelegate>
@property (strong, nonatomic)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *manager;
@end

@implementation MKMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAnnotation)];
    tap.numberOfTapsRequired=3;//点击三次就给地图添加大头针
    [self.mapView addGestureRecognizer:tap];
    //初始化manager
    self.manager=[[CLLocationManager alloc]init];
    //假定用户点击同意(info.plist添加key）
    [self.manager requestWhenInUseAuthorization];
    //相关设置
    self.mapView.delegate=self;
    self.mapView.rotateEnabled=YES;
    self.mapView.mapType=MKMapTypeHybridFlyover;
    //开始定位
    self.mapView.userTrackingMode=MKUserTrackingModeFollow;//地图一直显示用户位置
}
//定位到用户位置
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self PrintCacheData:[NSString stringWithFormat:@"用户的位置:%f    %f    %@     %@",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,userLocation.title,userLocation.subtitle]];
    //修改点中蓝色圈弹出框的内容
    userLocation.title=@"1501";
    userLocation.subtitle=@"Fighting";
}
//监控地图发生移动（停止移动即会调用）
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //regin是显示在设备上的，能看到的区域
    [self PrintCacheData:@"地图发生移动"];
}
- (void)addAnnotation {
    //创建大头针对象
    Annotation *annotation=[[Annotation alloc]init];
    //设置三个属性
    double latitude=31.1+(arc4random()%10)*1.0/100;
    double longitude=121.5+(arc4random()%10)*1.0/100;
    annotation.coordinate=CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title=@"大学";
    annotation.subtitle=@"这是大学的详细介绍内容";
    annotation.image=[UIImage imageNamed:@"icon_paopao_waterdrop_streetscape@2x.png"];
    //添加到地图视图上
    [self.mapView addAnnotation:annotation];
    //移动地图到添加大头针的位置，设置region
    MKCoordinateSpan span=MKCoordinateSpanMake(1, 1);//跨度
    MKCoordinateRegion region=MKCoordinateRegionMake(annotation.coordinate,span);//中心位置和跨度
    [self.mapView setRegion:region];
}
//当调用addannotation时就会调用该方法设置大头针的视图。用户默认蓝色的圈就是大头针对象，也会调用这个方法
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //判断添加的annotation是否是用户默认的蓝色
    if ([annotation isKindOfClass:[MKPinAnnotationView class]]) {
        return nil;//表明是默认的蓝色，直接返回nil
    }
    //需求：修改默认的大头针的图片.MKAnnotationView是MKPinAnnotation类的父类。需要用它的父类去修改图片
    //大头针视图的重用机制
    static NSString *identifier=@"annotation";
    MKAnnotationView *annoView= [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(!annoView){
        annoView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        //大头针对象和大头针视图之间的关系，颜色，动画
        //annoView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier1];
        //annoView.animatesDrop=YES;
        //annoView.backgroundColor=[UIColor redColor];
        //annoView.pinTintColor=[UIColor greenColor];
        //annoView.canShowCallout=YES;
        annoView.image=[UIImage imageNamed:@"超能 (3).png"];
        annoView.bounds=CGRectMake(0, 0, 40, 40);
        Annotation *anno=(Annotation*)annotation;
        annoView.image=anno.image;
        //设置弹出框的左右视图
        annoView.leftCalloutAccessoryView=[[UISwitch alloc]init];
        annoView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annoView.canShowCallout=YES;
    }else{//有可重用的大头针视图
        annoView.annotation=annotation;
    }
    return annoView;
}
@end
