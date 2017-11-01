//
//  SalesViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/21.
//  Copyright © 2016年 薛超. All rights reserved.
//每日销售情况记录

#import "SalesViewController.h"

@interface SalesViewController (){
    NSString *dataurl;
    NSMutableArray *cells;
    NSArray *titles;
}
//每日销售建设https://aes.aia.com.cn/isp/esb/maintain/record.do
@end
@implementation SalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    cells = [NSMutableArray arrayWithCapacity:10];
    titles = [NSArray arrayWithObjects:@"日期:",@"预约:",@"确定预约:",@"转介绍名单:",@"其他名单:",@"仅夜间:",@"夜间和白天",@"初次:",@"后续:",@"完整的需求调查",@"其他:",
                            @"制作建议书的新单",@"成交面谈:",@"保单件数:",@"保额(K):",@"年化保费:",@"电话:",@"现场展业:",@"办公室:",@"工作小时数",nil];
    for(int i=0;i<20;i++){
        SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
        c.title = titles[i];c.isFill = YES;
        [cells addObject:c];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    SBaseCell *ce = cells[0];
    ce.subtitle = dateString;
    [self.values setValue:dateString forKey:@"00"];
    group1.items =cells;
    [self.groups addObject:group1];
    
    self.tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 250)];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, APPW-50, 40)];
    [next setTitle:@"提   交" forState:UIControlStateNormal];
    next.layer.cornerRadius = 20;next.tag = 1;
    next.backgroundColor = redcolor;
    [next addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:next];
    
    [self fillTheTableDataWithHeadV:nil footV:self.tableFootView canMove:NO canEdit:NO headH:0 footH:0 rowH:44 sectionN:1 rowN:titles.count cellName:@"SBaseCell"];
    self.tableView.frame = CGRectMake(0, 44, APPW, APPH-44);
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
-(void)submit{
    DLog(@"%@",self.values);
if(self.values[@"00"]&&self.values[@"01"]&&self.values[@"02"]&&self.values[@"03"]&&self.values[@"04"]&&self.values[@"05"]&&self.values[@"06"]&&self.values[@"07"]&&self.values[@"08"]&&self.values[@"09"]&&self.values[@"010"]&&self.values[@"011"]&&self.values[@"012"]&&self.values[@"013"]&&self.values[@"014"]&&self.values[@"015"]&&self.values[@"016"]&&self.values[@"017"]&&self.values[@"018"]&&self.values[@"019"]){
    }else{
        [SVProgressHUD showErrorWithStatus:@"请把信息填写完整"];return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
    [dict setObject:[self.values valueForJSONKey:@"00"] forKey:@"date1"];//"yyyy-MM-dd
    [dict setObject:@"add" forKey:@"update1"];
    [dict setObject:@"add" forKey:@"type1"];
    [dict setObject:@"" forKey:@"updateId1"];
    [dict setObject:[self.values valueForJSONKey:@"00"] forKey:@"yuyue1"];//电话/面对面预约
    [dict setObject:[self.values valueForJSONKey:@"01"] forKey:@"quedingyuyue1"];//确定预约
    [dict setObject:[self.values valueForJSONKey:@"02"] forKey:@"jieshaomingdan1"];//转介绍名单
    [dict setObject:[self.values valueForJSONKey:@"03"] forKey:@"qitamingdan1"];//其他名单
    [dict setObject:[self.values valueForJSONKey:@"04"] forKey:@"onlynight1"];//仅夜间
    [dict setObject:[self.values valueForJSONKey:@"05"] forKey:@"daynight1"];//夜间和白天
    [dict setObject:[self.values valueForJSONKey:@"06"] forKey:@"chuci1"];//初次
    [dict setObject:[self.values valueForJSONKey:@"07"] forKey:@"houxu1"];//后续
    [dict setObject:[self.values valueForJSONKey:@"08"] forKey:@"xuqiudiaocha1"];//完整的需求调查
    [dict setObject:[self.values valueForJSONKey:@"09"] forKey:@"qita1"];//其他
    [dict setObject:[self.values valueForJSONKey:@"010"] forKey:@"xindan1"];//制作建议书的新单
    [dict setObject:[self.values valueForJSONKey:@"011"] forKey:@"miantan1"];//成交面谈
    [dict setObject:[self.values valueForJSONKey:@"012"] forKey:@"baodanjianshu1"];//保单件数
    [dict setObject:[self.values valueForJSONKey:@"013"] forKey:@"baoe1"];//保额
    [dict setObject:[self.values valueForJSONKey:@"014"] forKey:@"nianhuabaofei1"];//年化保费
    [dict setObject:[self.values valueForJSONKey:@"015"] forKey:@"dianhua1"];//电话
    [dict setObject:[self.values valueForJSONKey:@"016"] forKey:@"xianchangzhanye1"];//现场展业
    [dict setObject:[self.values valueForJSONKey:@"017"] forKey:@"bangongshi1"];//办公室
    [dict setObject:[self.values valueForJSONKey:@"018"] forKey:@"zongshu1"];//工作小时数
    [dict setObject:[self.values valueForJSONKey:@"019"] forKey:@"num"];//工作小时数
    dataurl = @"https://aes.aia.com.cn/isp/esb/maintain/saveSaleRecord.do";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager POST:dataurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"💐提交成功！"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];//数据内容
        NSString *s2 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, APPW, 500)];
        [web loadHTMLString:s2 baseURL:nil];
        [self.view addSubview:web];
        DLog(@"%@",s2);
        [SVProgressHUD showErrorWithStatus:@"网络请求错误，请重新登录。"];
    }];
}
@end
