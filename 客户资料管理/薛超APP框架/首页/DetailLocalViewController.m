//  DetailLocalViewController.m
//  薛超APP框架
//  Created by 薛超 on 16/11/2.
//  Copyright © 2016年 薛超. All rights reserved.
#import "DetailLocalViewController.h"
#import "AppDelegate.h"
#import "Customdata.h"
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
@interface DetailLocalViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>{
    NSMutableArray *cells;
    NSArray *titles;
    NSArray *attributes;
    CLGeocoder *geocoder;
}
@end
@implementation DetailLocalViewController
-(void)call{
    SBaseCell *cell = cells[6];
    NSString *phoneNumber = [cell.subtitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
}
-(void)letUsChat{
    SBaseCell *cell = cells[6];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.subtitle;
    //打开微信 , 没有配置
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}
-(void)daohang{
    SBaseCell *cell1 = cells[14];
    NSString *officeAddress = cell1.subtitle;
    [geocoder geocodeAddressString:officeAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        //设置白天黑夜模式
        [BNCoreServices_Strategy setDayNightType:BNDayNight_CFG_Type_Auto];
        CLLocationCoordinate2D wgs84llCoordinate;
        CLLocationCoordinate2D bd09McCoordinate;
        bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
        // 进入导航页面
        if(![BNCoreServices_Instance isServicesInited]){[SVProgressHUD showErrorWithStatus:@"引擎尚未初始化完成，请稍后再试"];return;}
        NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
        //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
        CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
        BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
        startNode.pos = [[BNPosition alloc] init];
        startNode.pos.x = myLocation.coordinate.longitude;
        startNode.pos.y = myLocation.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_OriginalGPS;
        [nodesArray addObject:startNode];
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
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithTitle:@"电话" style:UIBarButtonItemStylePlain target:self action:@selector(call)];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithTitle:@"微信" style:UIBarButtonItemStylePlain target:self action:@selector(letUsChat)];
    UIBarButtonItem *right3 = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(daohang)];
    self.navigationItem.rightBarButtonItems = @[right1,right2,right3];
    cells = [NSMutableArray arrayWithCapacity:28];
    attributes = @[@"tname",@"tbirthday",@"tsex",@"tIDnumber",@"tdayphone",@"tnightphone",@"ttelephone",@"tacceptM",@"tworknumber",@"tEmail",@"tZipcode",@"towner",@"tpaybank",@"treceivebank",@"taddress",
                   @"bname",@"bbirthday",@"bsex",@"bIDnumber",@"bdayphone",@"bnightphone",@"btelephone",@"bacceptM",@"bworknumber",@"breceivebank",
                   @"tid",@"cfromtime",@"ctoime",@"cpaytype",@"clastmoney",@"cjiaofeitype",@"ccurrentmoney",@"cpaytime",@"cfapiaodata",
                   @"mpaymoney",@"movermoney",@"mlastpay",@"mbalance",@"mhandle",@"mfleave",@"mfhandle",@"myearleave",@"myearhandle",@"mmoneyleave",@"mmoneyhandle",@"mreceiveman",@"mnotselect",
                   @"mdiedeal",@"mstory",@"mwanneng",@"mbaodan",@"mcardnumber",@"mcarddate",
                   ];
    titles = @[@"投保人",@"出生年月",@"性别",@"身份证号",@"投保人日间电话",@"投保人夜间电话",@"投保人手机",@"投保人短信接收",@"投保人职业代码",@"客户电子邮箱",@"邮编",@"账户所有人",@"银行转账付款账号",@"投保人银行转账给付账号",@"通讯地址",
               @"被保险人1",@"出生年月",@"性别",@"身份证号",@"被保人日间电话",@"被保人夜间电话",@"被保险人手机",@"被保人短信接收",@"被保人职业代码",@"被保险人银行转账给付账号",
               @"保单号",@"保险合同生效日期",@"保险合同到期日",@"付款方式",@"上期保险费",@"缴费方式",@"到期保险费",@"缴费到期日",@"发票打印日期",
               @"贷款本金及利息",@"溢缴保险费",@"最后一次缴费记录",@"主合同生存现金结余",@"主合同生存现金处理方式",@"附加合同生存现金结余",@"附加合同生存现金处理方式",@"年金结余",@"年金处理方式",@"现金红利结余",@"现金红利处理方式",@"年金受领人",@"保险费过期未付选择",
               @"全残保险金的处理方式",@"是否有理赔史",@"万能险年金领取",@"电子保单",@"服务卡卡号",@"服务卡有效期"];
    for(int i=0;i<titles.count;i++){
        SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
        c.title = titles[i];
        c.subtitle = [self.otherInfo valueForKey:attributes[i]];
        [cells addObject:c];
    }
    // 1.创建组
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    SBaseGroup *group2 = [[SBaseGroup alloc]init];
    SBaseGroup *group3 = [[SBaseGroup alloc]init];
    SBaseGroup *group4 = [[SBaseGroup alloc]init];
    SBaseGroup *group5 = [[SBaseGroup alloc]init];
    // 2.设置组的基本数据
    group1.items = @[cells[0],cells[1],cells[2],cells[3],cells[4],cells[5],cells[6],cells[7],cells[8],cells[9],cells[10],cells[11],cells[12],cells[13],cells[14]];
    [self.groups addObject:group1];
    group1.header = @"投保人信息";
    group2.items = @[cells[15],cells[16],cells[17],cells[18],cells[19],cells[20],cells[21],cells[22],cells[23],cells[24]];
    [self.groups addObject:group2];
    group2.header = @"被保险人信息";
    group3.items = @[cells[25],cells[26],cells[27],cells[28],cells[29],cells[30],cells[31],cells[32],cells[33]];
    [self.groups addObject:group3];
    group3.header = @"保单信息";
    group4.items = @[cells[34],cells[35],cells[36],cells[37],cells[38],cells[39],cells[40],cells[41],cells[42],cells[43],cells[44],cells[45],cells[46]];
    [self.groups addObject:group4];
    group4.header = @"资金信息";
    group5.items = @[cells[47],cells[48],cells[49],cells[50],cells[51],cells[52]];
    [self.groups addObject:group5];
    group5.header = @"其他信息";
    self.tableFootView = [self getTableFooterView];
    [self fillTheTableDataWithHeadV:nil footV:self.tableFootView canMove:NO canEdit:NO headH:20 footH:0 rowH:44 sectionN:self.groups.count rowN:0 cellName:@"SBaseCell"];
    self.tableView.frame = CGRectMake(0, -36, APPW, APPH+30);
    
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark 下边显示一个保单列表。
-(UIView*)getTableFooterView{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW,230)];
    Customdata *custom = self.otherInfo;
    NSArray* array1 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cnumber];
    NSArray* array2 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cname];
    NSArray* array3 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cbnames];
    NSArray* array4 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cstatus];
    NSArray* array5 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cedu];
    NSArray* array6 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.ccost];
    NSArray* array7 = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cendtime];
    UILabel *a = [Utility labelWithFrame:CGRectMake(10, 0, 70, 20) font:fontnomal color:blacktextcolor text:@"合同代码:"];
    UILabel *b = [Utility labelWithFrame:CGRectMake(X(a), YH(a)+10, W(a), 20) font:fontnomal color:blacktextcolor text:@"合同名称:"];
    UILabel *c = [Utility labelWithFrame:CGRectMake(X(a), YH(b)+10, W(a), 20) font:fontnomal color:blacktextcolor text:@"被保险人:"];
    UILabel *d = [Utility labelWithFrame:CGRectMake(X(a), YH(c)+10, W(a), 20) font:fontnomal color:blacktextcolor text:@"合同状态:"];
    UILabel *e = [Utility labelWithFrame:CGRectMake(X(a), YH(d)+10, W(a), 20) font:fontnomal color:blacktextcolor text:@"保额:"];
    UILabel *f = [Utility labelWithFrame:CGRectMake(X(a), YH(e)+10, W(a), 20) font:fontnomal color:blacktextcolor text:@"保费:"];
    UILabel *g = [Utility labelWithFrame:CGRectMake(X(a), YH(f)+10, W(a), 20) font:fontnomal color:blacktextcolor text:@"缴费期满:"];
    NSArray *arrays = @[array1,array2,array3,array4,array5,array6,array7];
    for(int j=0;j<7;j++){
        for(int i=0;i<array1.count;i++){
            CGFloat w = (APPW-100)/array1.count;
            CGFloat h = 20;
            NSArray *temp = arrays[j];
            UILabel *vl = [Utility labelWithFrame:CGRectMake(90+i*(w+2), j*(h+10), w, h) font:fontnomal color:blacktextcolor text:temp[i]];
            
            [foot addSubview:vl];
        }
    }
    [foot addSubviews:a,b,c,d,e,f,g,nil];
    
    return foot;
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
//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo{
    if (pageType == BNaviUI_NormalNavi){
        NSLog(@"退出导航");
    }else if (pageType == BNaviUI_Declaration){
        NSLog(@"退出导航声明页面");
    }
}






@end
