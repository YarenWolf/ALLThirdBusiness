////
////  MapmViewController.m
////  薛超APP框架
////
////  Created by 薛超 on 16/10/27.
////  Copyright © 2016年 薛超. All rights reserved.
////
//
//#import "MapmViewController.h"
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
//@interface MapmViewController ()<BMKMapViewDelegate>
//@property(nonatomic,strong)BMKMapView* mapView;
//@end
//@implementation MapmViewController
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    _mapView.mapType = BMKMapTypeNone;//设置地图为空白类型
//    
//    [_mapView setTrafficEnabled:YES];
//    
//    //关闭实时路况图层
////    [_mapView setTrafficEnabled:NO];
//    self.view = _mapView;
//    BMKOpenTransitRouteOption *opt = [[BMKOpenTransitRouteOptionalloc] init];
//    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";//用于调起成功后，返回原应用
//    //初始化起点节点
//    BMKPlanNode* start = [[BMKPlanNodealloc]init];
//    //指定起点经纬度
//    CLLocationCoordinate2D coor1;
//    coor1.latitude = 39.90868;
//    coor1.longitude = 116.204;
//    //指定起点名称
//    start.name = @"西直门";
//    start.pt = coor1;
//    //指定起点
//    opt.startPoint = start;
//    
//    //初始化终点节点
//    BMKPlanNode* end = [[BMKPlanNodealloc]init];
//    CLLocationCoordinate2D coor2;
//    coor2.latitude = 39.90868;
//    coor2.longitude = 116.3956;
//    end.pt = coor2;
//    //指定终点名称
//    end.name = @"天安门";
//    opt.endPoint = end;
//    
//    //打开地图公交路线检索
//    BMKOpenErrorCode code = [BMKOpenRouteopenBaiduMapTransitRoute:opt];
//    //初始化BMKLocationService
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    //启动LocationService
//    [_locService startUserLocationService];
//}
//
////实现相关delegate 处理位置信息更新
////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
//}
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//}
//- (void) viewDidAppear:(BOOL)animated {
//    // 添加一个PointAnnotation
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    annotation.coordinate = coor;
//    annotation.title = @"这里是北京";
//    [_mapView addAnnotation:annotation];
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//}
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        return newAnnotationView;
//    }
//    return nil;
//}
//@end
