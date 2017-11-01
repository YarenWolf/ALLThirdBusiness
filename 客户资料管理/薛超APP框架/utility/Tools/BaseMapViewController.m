//
////
////  GuangzhaoViewController.m
////  GuangFuBao
////  Created by 薛超 on 16/7/26.
////  Copyright © 2016年 55like. All rights reserved.
//#import "BaseMapViewController.h"
//#import<BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import<BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import<BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import<BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import<BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import<BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import<BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import<BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
//#import <CoreLocation/CoreLocation.h>
//#pragma mark 自定义气泡框
//@interface PointCell : UIView
//@property (strong, nonatomic) UILabel *city;
//@property (strong, nonatomic) UILabel *corr;
//@property (strong, nonatomic) UILabel *cita;
//@property (nonatomic,strong)UIImageView *icon;
//@end
//@implementation PointCell
//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initUI];
//    }
//    return self;
//}
//- (void)initUI{
//    _city = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 20)];
//    _corr= [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 180, 20)];
//    _cita= [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 180, 20)];
//    _city.font = _corr.font = _cita.font = Font(12);
//    [self addSubviews:_city,_cita,_corr,nil];
//    self.backgroundColor = RGBCOLOR(250, 250, 250);
//}
//@end
//@interface BaseMapViewController ()<BNHUDListenerProtocol,BMKMapViewDelegate,BMKLocationServiceDelegate,UISearchBarDelegate>{
//    BMKMapView *_mapview;
//    BMKLocationService *_locService;
//    UIButton *selectMap;
//    CLGeocoder *_geocoder;
//}
//@property(nonatomic,strong)  CLLocationManager *locationManager;
//@end
//@implementation BaseMapViewController
//#pragma mark BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
//
//-(void)viewWillAppear:(BOOL)animated {
//    [_mapview viewWillAppear];
//    _mapview.delegate = self;
//    _locService.delegate = self;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [_mapview viewWillDisappear];
//    [_locService stopUserLocationService];
//    _mapview.showsUserLocation = NO;
//    _mapview.delegate = nil; // 不用时，置nil
//    _locService.delegate = nil;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(70, TopHeight, APPW-100, 30)];
//    searchBar.placeholder = @"Search";
//    searchBar.barTintColor = [UIColor whiteColor];
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    BNHUDManager *hudManager = [BNHUDManager shareInstance];
//    [[BNHUDManager shareInstance] connectToBNService];
//    [hudManager connectRemoteServiceSuccess:^{
//        [hudManager setBNEventListener:self];
//    } connectRemoteserviceFail:^(NSError *error) {
//        
//    }];
//    
////    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
////    tap.numberOfTapsRequired = tap.numberOfTouchesRequired = 1;
////    [self.view addGestureRecognizer:tap];
////    
////    _geocoder=[[CLGeocoder alloc]init];
////    _mapview=[[BMKMapView alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH-64 )];
////    _mapview.scrollEnabled = YES;
////    _mapview.mapType = BMKMapTypeStandard;
////    _mapview.delegate=self;
////    [self.view addSubview:_mapview];
////    
////    selectMap=[[UIButton alloc]initWithFrame:CGRectMake(APPW-60, 80, 50, 30)];
////    [selectMap setTitle:@"标准" forState:UIControlStateNormal];
////    [selectMap setTitle:@"卫星" forState:UIControlStateSelected];
////    selectMap.backgroundColor = RGBACOLOR(10, 10, 10, 0.5);
////    [selectMap addTarget:self action:@selector(changeMap:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:selectMap];
////    
////    //适配ios7
////    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
////        self.navigationController.navigationBar.translucent = NO;
////    }
////    _locService = [[BMKLocationService alloc]init];
////    _locService.delegate=self;
////    [_locService startUserLocationService];
////    
////    _mapview.showsUserLocation = NO;//先关闭显示的定位图层
////    _mapview.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
////    _mapview.showsUserLocation = YES;//显示定位图层
//}
//#pragma mark Action
////-(void)myLocationClicked{
////    _locService.delegate=self;
////    [_locService startUserLocationService];
////    _mapview.showsUserLocation = NO;//先关闭显示的定位图层
////    _mapview.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
////    _mapview.showsUserLocation = YES;//显示定位图层
////    
////    CLLocationCoordinate2D coor;
////    coor.latitude = [[[Utility Share] userlatitude] doubleValue];//纬度
////    coor.longitude = [[[Utility Share] userlongitude] doubleValue];//经度
////    BMKCoordinateSpan span = {0.01,0.01};
////    BMKCoordinateRegion region = {coor,span};
////    [_mapview setRegion:region];
////}
////- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
////    CGPoint p = [sender locationInView:_mapview];
////    CLLocationCoordinate2D coord = [_mapview convertPoint:p toCoordinateFromView:_mapview];
////    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc]init];
////    ann.coordinate=coord;
////    [_mapview addAnnotation:ann];
////    BMKCoordinateSpan span=BMKCoordinateSpanMake(8, 8);
////    BMKCoordinateRegion region=BMKCoordinateRegionMake(ann.coordinate,span);
////    [_mapview setRegion:region];
////    [_mapview selectAnnotation:ann animated:YES];
////}
////
////-(void)changeMap:(UIButton*)sender{
////    if(sender.selected)_mapview.mapType = BMKMapTypeStandard;
////    else _mapview.mapType = BMKMapTypeSatellite;
////    sender.selected = !sender.selected;
////}
////
////#pragma mark - MKAnnotationView delegate
////- (BMKAnnotationView *)mapView:(BMKMapView *)mapView  viewForAnnotation:(id <BMKAnnotation>)annotation{
////    BMKPinAnnotationView *annoationView = (BMKPinAnnotationView*)[mapView viewForAnnotation:annotation];
////    if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
////        annoationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnorV"] ;
////        annoationView.canShowCallout = YES;
////        ((BMKPinAnnotationView*)annoationView).animatesDrop = YES;// 设置该标注点动画显示
////        annoationView.image = [UIImage imageNamed:@"location_mylocation"];
////        annoationView.annotation = annotation;
////        PointCell *popView = [[PointCell alloc]initWithFrame:CGRectMake(0, 0, 130, 90)];
////        CLLocation *location=[[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
////        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
////            CLPlacemark *placemark=[placemarks firstObject];
////            popView.city.text = [NSString stringWithFormat:@"%@%@",placemark.locality,placemark.subLocality];
////            popView.corr.text =placemark.name;
////            popView.cita.text =[NSString stringWithFormat:@"经纬度:%0.2f , %0.2f",annotation.coordinate.longitude,annotation.coordinate.latitude];
////        }];
////        
////        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
////        pView.frame = CGRectMake(0, 0, 100, 80);
////        ((BMKPinAnnotationView*)annoationView).paopaoView = pView;
////        return annoationView;
////
////        
////    }
////    return nil;
////}
////- (void)willStartLocatingUser{
////    NSLog(@"开始定位");
////}
////
//////用户方向更新后，会调用此函数
////- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
////    [_mapview updateLocationData:userLocation];
////}
////
//////用户位置更新后，会调用此函数
////- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
////    [_mapview updateLocationData:userLocation];
////    [[Utility Share]setUserlatitude:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude]];
////    [[Utility Share]setUserlongitude:[NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude]];
////    [_geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
////        CLPlacemark *placemark=[placemarks firstObject];
////        DLog(@"%@",placemark);
////        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
////        annotation.coordinate=userLocation.location.coordinate;
////        BMKCoordinateSpan span=BMKCoordinateSpanMake(8, 8);
////        BMKCoordinateRegion region=BMKCoordinateRegionMake(annotation.coordinate,span);
////        [_mapview setRegion:region];
////        [_mapview addAnnotation:annotation];
////        [_mapview selectAnnotation:annotation animated:YES];
////
////    }];
////    [_locService stopUserLocationService];
////
////}
////
////- (void)didStopLocatingUser{
////    NSLog(@"停止定位");
////}
////#pragma mark searchBarDelegate
////- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
////    [_geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
////        CLPlacemark *placemark=[placemarks firstObject];
////        BMKPointAnnotation *ann = [[BMKPointAnnotation alloc]init];
////        ann.coordinate=placemark.location.coordinate;
////        BMKCoordinateSpan span=BMKCoordinateSpanMake(8, 8);
////        BMKCoordinateRegion region=BMKCoordinateRegionMake(ann.coordinate,span);
////        [_mapview setRegion:region];
////        [_mapview addAnnotation:ann];
////        [_mapview selectAnnotation:ann animated:YES];
////    }];
////}
//@end
//
