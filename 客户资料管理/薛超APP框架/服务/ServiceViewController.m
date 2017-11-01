//
//  ServiceViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "ServiceViewController.h"
#import "AppDelegate.h"
#import "Coredata.h"
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
@interface ServiceViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate,UIPopoverPresentationControllerDelegate>{
    NSMutableArray *cells;
    NSArray *titles;
    BOOL ischange;
    NSArray *keys;
    NSArray *attributes;
    CLGeocoder *geocoder;
    UIButton *iconbutton;
    
}

@end

@implementation ServiceViewController
-(void)call{
    SBaseCell *cell = cells[4];
    NSString *phoneNumber = cell.subtitle;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
//    需要在info里面添加 LSApplicationQueriesSchemes字段
//        NSURL *url = [NSURL URLWithString:@"mqq://"];
//        if([[UIApplication sharedApplication] canOpenURL:url]){
//            [[UIApplication sharedApplication] openURL:url];
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"您没有安装QQ"];
//        }
    //打开指定QQ
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"1294848228"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    
}
-(void)letUsChat{
    SBaseCell *cell = cells[5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.subtitle;
    //打开微信 , 没有配置
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}
-(void)daohang{
    SBaseCell *cell1 = cells[11];
    SBaseCell *cell2 = cells[12];
    SBaseCell *cell3 = cells[2];
    NSString *seeAddress = cell3.subtitle;
    NSString *officeAddress = cell1.subtitle;
    NSString *homeAddress = cell2.subtitle;
    [geocoder geocodeAddressString:officeAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        
        //设置白天黑夜模式
        [BNCoreServices_Strategy setDayNightType:BNDayNight_CFG_Type_Auto];
        CLLocationCoordinate2D wgs84llCoordinate;
        CLLocationCoordinate2D bd09McCoordinate;
        bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
        // 进入导航页面
        if(![BNCoreServices_Instance isServicesInited]){
            [SVProgressHUD showErrorWithStatus:@"引擎尚未初始化完成，请稍后再试"];return;
        }
        NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
        //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
        CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
        BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
        startNode.pos = [[BNPosition alloc] init];
        startNode.pos.x = myLocation.coordinate.longitude;
        startNode.pos.y = myLocation.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_OriginalGPS;
        [nodesArray addObject:startNode];
        
        //途经点
//        BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
//        midNode.pos = [[BNPosition alloc] init];
//        midNode.pos.x = 113.977004;
//        midNode.pos.y = 22.556393;
//        midNode.pos.eType = BNCoordinate_BaiduMapSDK;
//        [nodesArray addObject:midNode];
        
        //终点
        BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
        endNode.pos = [[BNPosition alloc] init];
        endNode.pos.x = placemark.location.coordinate.longitude;
        endNode.pos.y = placemark.location.coordinate.latitude;
        endNode.pos.eType = BNCoordinate_BaiduMapSDK;
        [nodesArray addObject:endNode];
        
        [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
        
    }];

}
-(void)viewDidLoad{
    [super viewDidLoad];
    geocoder = [[CLGeocoder alloc]init];
    self.title = @"客户信息";
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithTitle:@"打电话" style:UIBarButtonItemStylePlain target:self action:@selector(call)];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithTitle:@"发微信" style:UIBarButtonItemStylePlain target:self action:@selector(letUsChat)];
    UIBarButtonItem *right3 = [[UIBarButtonItem alloc]initWithTitle:@"路线导航" style:UIBarButtonItemStylePlain target:self action:@selector(daohang)];
    self.navigationItem.rightBarButtonItems = @[right1,right2];
    self.navigationItem.leftBarButtonItem = right3;
    
    attributes = @[@"name",@"time",@"place",@"sex",@"phone",@"wechart",@"email",@"age",@"birthDay",
                   @"company",@"position",@"unitAddress",@"homeAddress",@"character",@"hobby",@"dream",
                   @"economic",@"firstVision",@"need",@"secondVision",
                   @"suggest",@"deal",@"dealTime",@"insuranceType",@"policyNumber",@"quota",@"annualPremium",@"instructions",@"others"];
    keys = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"20",@"21",@"22",@"23",@"24",@"30",@"31",@"32",@"33",@"34",@"35",@"36"];
    // 1.创建组
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    SBaseGroup *group2 = [[SBaseGroup alloc]init];
    SBaseGroup *group3 = [[SBaseGroup alloc]init];
    SBaseGroup *group4 = [[SBaseGroup alloc]init];
    // 2.设置组的基本数据
    cells = [NSMutableArray arrayWithCapacity:28];
    titles = [NSArray arrayWithObjects:@"姓名",@"认识时间:",@"认识地点:",@"性别:",@"手机:",@"微信号",@"邮箱",@"年龄:",@"生日",
              @"公司",@"职位:",@"单位地址:",@"家庭地址:",@"性格特点:",@"爱好",@"梦想",
              @"经济状况",@"初次预约:",@"需求分析:",@"二次预约:",@"制作建议书:",
              @"成交面谈",@"成交时间:",@"险种:",@"保单件数:",@"保额(万):",@"年化保费",@"其他说明", nil];
    for(int i=0;i<28;i++){
        [self.values setObject:@"" forKey:keys[i]];
        SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
        c.title = titles[i];
        if(i!=3)c.isFill = YES;
        [cells addObject:c];
    }
    
    
    group1.items = @[cells[0],cells[1],cells[2],cells[3],cells[4],cells[5],cells[6],cells[7],cells[8]];
    [self.groups addObject:group1];
    group1.header = @"基本信息";
    SBaseCell *c =cells[3];
    c.cellArray = @[@"男",@"女"];
    group2.items = @[cells[9],cells[10],cells[11],cells[12],cells[13],cells[14],cells[15]];
    [self.groups addObject:group2];
    group2.header = @"公众信息";
    group3.items = @[cells[16],cells[17],cells[18],cells[19],cells[20]];
    [self.groups addObject:group3];
    group3.header = @"需求信息";
    group4.items = @[cells[21],cells[22],cells[23],cells[24],cells[25],cells[26],cells[27]];
    [self.groups addObject:group4];
    group4.header = @"成交信息";
    self.tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 250)];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(20, 170, APPW-50, 40)];
    [next setTitle:@"提   交" forState:UIControlStateNormal];
    next.layer.cornerRadius = 15;next.tag = 1;
    next.backgroundColor = redcolor;
    [next addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    iconbutton =[[UIButton alloc]initWithFrame:CGRectMake((APPW-200)/2, 0, 200, 150)];// [Utility buttonWithFrame:CGRectMake((APPW-200)/2, 0, 200, 150) title:@"头像" image:@"" bgimage:@"icon_add"];
    [iconbutton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [self.pictures addObject:[UIImage imageNamed:@"icon_add"]];
    [iconbutton addTarget:self action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
    iconbutton.tag = 0;
    
    [self.tableFootView addSubview:iconbutton];
    [self.tableFootView addSubview:next];
    
    [self fillTheTableDataWithHeadV:nil footV:self.tableFootView canMove:NO canEdit:YES headH:20 footH:20 rowH:44 sectionN:self.groups.count rowN:0 cellName:@"SBaseCell"];
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, -35, APPW, APPH-40);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, -35, APPW, APPH-40);
        [self.tableView reloadData];
    }
}
-(void)nextPage{
    [self.view endEditing:YES];
    DLog(@"\n\n\n%@",self.values);
    if(ischange){
        [self reviseCoreData];
       
    }else{
        [self addCoreData];
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    if(_baoliu){return;}
    for(int i=0;i<keys.count;i++){
        SBaseCell *cell = cells[i];
        cell.subtitle = [[self.person valueForKey:attributes[i]]notEmptyOrNull]?[self.person valueForKey:attributes[i]]:@"";
        [self.values setValue:[self.person valueForKey:attributes[i]] forKey:keys[i]];
        
    }
    if([self.person.name notEmptyOrNull]){
        UIImage *iconimage = [NSKeyedUnarchiver unarchiveObjectWithData:self.person.icon];
        [iconbutton setImage:iconimage forState:UIControlStateNormal];
        [self.pictures insertObject:iconimage atIndex:0];
    }
    
    if([[self.person valueForKey:attributes[0]]notEmptyOrNull]){
        ischange = YES;
        self.title = [self.person valueForKey:attributes[0]];
        UIButton *next = [self.tableFootView viewWithTag:1];
        [next setTitle:@"提交修改" forState:UIControlStateNormal];
    }else{
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMdd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        DLog(@"%@",dateString);
        SBaseCell *ce = cells[1];
        ce.subtitle = dateString;
        [self.values setObject:dateString forKey:@"01"];
        CLLocationCoordinate2D wgs84llCoordinate;
        CLLocationCoordinate2D bd09McCoordinate;
        bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
        CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
        [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *mark = [placemarks firstObject];
            SBaseCell *cer = cells[2];
            cer.subtitle = mark.addressDictionary[@"FormattedAddressLines"][0];
            [self.values setValue:cer.subtitle forKey:@"02"];
        }];

    }
    _baoliu = YES;
}
-(void)reviseCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Coredata"];
    AppDelegate *dele =[AppDelegate Share];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Coredata" inManagedObjectContext:dele.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"name = %@",[self.person valueForKey:@"name"]];
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"phone = %@",[self.person valueForKey:@"phone"]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1,p2]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    NSArray *persons = [dele.managedObjectContext executeFetchRequest:request error:nil];
    if ([persons count] > 0) {
        Coredata * lastPerson = [persons lastObject];
        lastPerson.name = [self.values valueForKey:keys[0]];
        lastPerson.time = [self.values valueForKey:keys[1]];
        lastPerson.place = [self.values valueForKey:keys[2]];
        lastPerson.sex = [self.values valueForKey:keys[3]];
        lastPerson.phone = [self.values valueForKey:keys[4]];
        lastPerson.wechart = [self.values valueForKey:keys[5]];
        lastPerson.email = [self.values valueForKey:keys[6]];
        lastPerson.age = [self.values valueForKey:keys[7]];
        lastPerson.birthDay = [self.values valueForKey:keys[8]];
        lastPerson.company = [self.values valueForKey:keys[9]];
        lastPerson.position = [self.values valueForKey:keys[10]];
        lastPerson.unitAddress = [self.values valueForKey:keys[11]];
        lastPerson.homeAddress = [self.values valueForKey:keys[12]];
        lastPerson.character = [self.values valueForKey:keys[13]];
        lastPerson.hobby = [self.values valueForKey:keys[14]];
        lastPerson.dream = [self.values valueForKey:keys[15]];
        lastPerson.economic = [self.values valueForKey:keys[16]];
        lastPerson.firstVision = [self.values valueForKey:keys[17]];
        lastPerson.need = [self.values valueForKey:keys[18]];
        lastPerson.secondVision = [self.values valueForKey:keys[19]];
        lastPerson.suggest = [self.values valueForKey:keys[20]];
        lastPerson.deal = [self.values valueForKey:keys[21]];
        lastPerson.dealTime = [self.values valueForKey:keys[22]];
        lastPerson.insuranceType = [self.values valueForKey:keys[23]];
        lastPerson.policyNumber = [self.values valueForKey:keys[24]];
        lastPerson.quota = [self.values valueForKey:keys[25]];
        lastPerson.annualPremium = [self.values valueForKey:keys[26]];
        lastPerson.instructions = [self.values valueForKey:keys[27]];
        lastPerson.icon =[NSKeyedArchiver archivedDataWithRootObject:self.pictures[0]];
        NSError *Error = nil;
        if ([dele.managedObjectContext save:&Error]) {
            ischange = NO;
            self.title = @"客户信息";
            UIButton *next = [self.tableFootView viewWithTag:1];
            [next setTitle:@"提   交" forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"更新成功"];
            self.person = nil;
            for(int i=0;i<keys.count;i++){
                SBaseCell *cell = cells[i];
                cell.subtitle = @"";//[self.person valueForKey:attributes[i]];
                [self.values setValue:@"" forKey:keys[i]];
            }
            [self.pictures removeAllObjects];
            [iconbutton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
            [self.pictures addObject:[UIImage imageNamed:@"icon_add"]];
        }else {
            [SVProgressHUD showErrorWithStatus:@"更新失败"];
        }
    }
}
-(void)addCoreData{
    if(![[self.values valueForKey:@"00"]notEmptyOrNull]){
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];return;
    }
    AppDelegate *dele =[AppDelegate Share];
    [dele readData];
    Coredata *data =[NSEntityDescription insertNewObjectForEntityForName:@"Coredata" inManagedObjectContext:dele.managedObjectContext];
    data.name=     [self.values valueForKey:keys[0]];
    data.time=     [self.values valueForKey:keys[1]];
    data.place=    [self.values valueForKey:keys[2]];
    data.sex=      [self.values valueForKey:keys[3]];
    data.phone=    [self.values valueForKey:keys[4]];
    data.wechart=  [self.values valueForKey:keys[5]];
    data.email=    [self.values valueForKey:keys[6]];
    data.age=      [self.values valueForKey:keys[7]];
    data.birthDay= [self.values valueForKey:keys[8]];
    data.company=  [self.values valueForKey:keys[9]];
    data.position= [self.values valueForKey:keys[10]];
    data.unitAddress=[self.values valueForKey:keys[11]];
    data.homeAddress=[self.values valueForKey:keys[12]];
    data.character=[self.values valueForKey:keys[13]];
    data.hobby=    [self.values valueForKey:keys[14]];
    data.dream=    [self.values valueForKey:keys[15]];
    data.economic= [self.values valueForKey:keys[16]];
    data.firstVision=[self.values valueForKey:keys[17]];
    data.need=     [self.values valueForKey:keys[18]];
    data.secondVision=[self.values valueForKey:keys[19]];
    data.suggest=  [self.values valueForKey:keys[20]];
    data.deal=     [self.values valueForKey:keys[21]];
    data.dealTime= [self.values valueForKey:keys[22]];
    data.insuranceType=[self.values valueForKey:keys[23]];
    data.policyNumber=[self.values valueForKey:keys[24]];
    data.quota=    [self.values valueForKey:keys[25]];
    data.annualPremium=[self.values valueForKey:keys[26]];
    data.instructions=[self.values valueForKey:keys[27]];
    data.icon = [NSKeyedArchiver archivedDataWithRootObject:self.pictures[0]];
    data.others=   @"";
    [[AppDelegate Share] saveContext];
    [SVProgressHUD showSuccessWithStatus:@"恭喜您又多了一个客户!"];
    self.person = nil;
    for(int i=0;i<keys.count;i++){
        SBaseCell *cell = cells[i];
        cell.subtitle = @"";//[self.person valueForKey:attributes[i]];
        [self.values setValue:@"" forKey:keys[i]];
    }
    [self.pictures removeAllObjects];
    [iconbutton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [self.pictures addObject:[UIImage imageNamed:@"icon_add"]];
}
-(void)fillTheAddress:(NSDictionary *)a :(NSDictionary *)b :(NSDictionary *)c{
    //    [super fillTheAddress:a :b :c];
    //    self.c1.subtitle =[NSString stringWithFormat:@"%@-%@-%@",a[@"name"],b[@"name"],c[@"name"]];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}
//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo{
    switch ([error code]%10000){
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:NSLog(@"暂时无法获取您的位置,请稍后重试");break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:NSLog(@"无法发起导航");break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:NSLog(@"起终点距离起终点太近");break;
        default:NSLog(@"算路失败");break;
    }
}
//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}
//安静退出导航
- (void)exitNaviUI{
    [BNCoreServices_UI exitPage:EN_BNavi_ExitTopVC animated:YES extraInfo:nil];
}
#pragma mark - BNNaviUIManagerDelegate
//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo{
    if (pageType == BNaviUI_NormalNavi){
        NSLog(@"退出导航");
    }else if (pageType == BNaviUI_Declaration){
        NSLog(@"退出导航声明页面");
    }
}
//设备协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image1=[info objectForKey:UIImagePickerControllerOriginalImage];
    float t_w=image1.size.width>640?640:image1.size.width;
    float t_h= t_w/image1.size.width * image1.size.height;
    //处理图片
    UIImage *imageTmpeLogo=[self imageWithImageSimple:image1 scaledToSize:CGSizeMake(t_w, t_h)];
    [iconbutton setImage:imageTmpeLogo forState:UIControlStateNormal];
    [self.pictures insertObject:imageTmpeLogo atIndex:0];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
+(NSString *)phoneModel{
    return [[UIDevice currentDevice] model];
}

-(void)addPicture:(UIButton*)sender{
    self.ipc=[[UIImagePickerController alloc]init];
    self.ipc.delegate = self;
    self.ipc.allowsEditing = YES;
    NSString *device = [[UIDevice currentDevice]model];
    if([device isEqualToString:@"iPhone"]){
        [self idcardoneAction:sender];
    }else if([device isEqualToString:@"iPad"]){
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.ipc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.ipc.sourceType];
    }
    self.ipc.popoverPresentationController.sourceView = sender;
    self.ipc.popoverPresentationController.delegate = self;
    [self presentViewController:self.ipc animated:YES completion:nil];
    }
}

@end
