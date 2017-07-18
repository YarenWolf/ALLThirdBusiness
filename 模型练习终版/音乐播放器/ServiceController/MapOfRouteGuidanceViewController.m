//
//  MapOfRouteGuidanceViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MapOfRouteGuidanceViewController.h"
#import <MapKit/MapKit.h>
#import "UIViewController+Extension.h"
@interface MapOfRouteGuidanceViewController ()<MKMapViewDelegate>
@property (nonatomic,strong)MKMapView *mapView;
@end

@implementation MapOfRouteGuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    self.view=self.mapView;
    self.mapView.delegate=self;
    [self startDrawLines];
}
- (void)startDrawLines {
    NSString *startPoint=@"北京";
    NSString *endPoint=@"上海";
    //创建CLGeoCoder对象
    CLGeocoder *coder=[CLGeocoder new];
    [coder geocodeAddressString:startPoint completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //假设返回一个，或者返回多个，只取一个
        CLPlacemark *placemark=[placemarks lastObject];
        //添加大头针
        MKPointAnnotation *annotation=[MKPointAnnotation new];
        annotation.coordinate=placemark.location.coordinate;
        annotation.title=startPoint;
        [self.mapView addAnnotation:annotation];
        //地理编码起点
        [coder geocodeAddressString:endPoint completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //取最后一项
            CLPlacemark *endPlacemark=[placemarks lastObject];
            MKPointAnnotation *endannotation=[MKPointAnnotation new];
            endannotation.coordinate=endPlacemark.location.coordinate;
            endannotation.title=endPoint;
            [self.mapView addAnnotation:endannotation];
            //发送请求，绘制路线
            [self routeWithStartPoint:placemark withEndPoint:endPlacemark];
        }];
    }];
}
-(void)routeWithStartPoint:(CLPlacemark*)startPlacemark withEndPoint:(CLPlacemark*)endPlacemark{
    //请求对象的创建
    MKDirectionsRequest *request=[MKDirectionsRequest new];
    //设置请求的起点和终点
    MKMapItem *sourceItem=[[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark:startPlacemark]];
    MKMapItem *destinationItem=[[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark:endPlacemark]];
    request.source=sourceItem;
    request.destination=destinationItem;
    MKDirections *directions=[[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //获取服务器返回的路线Routes(包含很多Steps）
            NSArray *routesArray=response.routes;
            for (MKRoute *route in routesArray) {
                //从route中获取所有小steps
                for (MKRouteStep *step in route.steps) {
                    [self PrintCacheData:[NSString stringWithFormat:@"显示step的详情:%@",step.instructions]];
                }
                //添加polyline到地图视图上
                [self.mapView addOverlay:route.polyline];
            }
        }
    }];
}
//只要调用addOverLay方法就会调用下面的协议方法
-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    //划线要创建polyLine对象
    MKPolylineRenderer *polyLine=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
    polyLine.lineWidth=3;
    polyLine.strokeColor=[UIColor redColor];
    return polyLine;//返回它的子类也是可以的
}
@end
