//  SignthebillViewController.m
//  薛超APP框架
//  Created by 薛超 on 16/10/21.
//  Copyright © 2016年 薛超. All rights reserved.
//每月签单记录
#import "SignthebillViewController.h"
@interface SignthebillViewController (){
    NSString *dataurl;
    NSMutableArray *cells;
    NSArray *titles;
}
@end
//每月签单记录https://aes.aia.com.cn/isp/esb/maintain/listSignBillRecord.do
//    dataurl = @"https://aes.aia.com.cn/isp/iconn/multiTerm/index.do";//订单查询的网页
@implementation SignthebillViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    cells = [NSMutableArray arrayWithCapacity:10];
    titles = [NSArray arrayWithObjects:@"记录日期yyyy-MMdd:",@"客户姓名:",@"预估保额:",@"预估保费:",@"是否本月制作建议书:",@"是否已签单（已付费）:",@"签单日期yyyy-MMdd",@"放弃;不采用",nil];
    for(int i=0;i<8;i++){
        SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
        c.title = titles[i];
        if(i==4||i==5||i==7){
            c.cellArray = @[@"是",@"否"];
        }else{
            c.isFill = YES;
        }
        [cells addObject:c];
    }
    SBaseCell *cell = cells[0];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    cell.subtitle = dateString;[self.values setValue:dateString forKey:@"00"];
    group1.items = @[cells[0],cells[1],cells[2],cells[3],cells[4],cells[5],cells[6],cells[7]];
    [self.groups addObject:group1];
    
    self.tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 50)];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, APPW-50, 40)];
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
        self.tableView.frame = CGRectMake(0, -30, APPW, APPH-40);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0,-30, APPW, APPH-40);
        [self.tableView reloadData];
    }
}
-(void)submit{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
    [dict setObject:self.values[@"00"] forKey:@"recordTime"];//记录日期yyyy-MMdd
    [dict setObject:self.values[@"01"] forKey:@"customerName"];//客户姓名
    [dict setObject:self.values[@"02"] forKey:@"predictAmount"];//预估保额
    [dict setObject:self.values[@"03"] forKey:@"predictCost"];//预估保费
    [dict setObject:[self.values[@"04"]isEqualToString:@"是"]?@"Y":@"N" forKey:@"isMakeSuggest"];//是否本月制作建议书
    [dict setObject:[self.values[@"05"]isEqualToString:@"是"]?@"Y":@"N" forKey:@"isPay"];//是否已签单（已付费）
    [dict setObject:self.values[@"06"] forKey:@"signBillTime"];//签单日期yyyy-MMdd
    [dict setObject:[self.values[@"07"]isEqualToString:@"是"]?@"Y":@"N" forKey:@"isGiveUp"];//放弃;不采用
    dataurl = @"https://aes.aia.com.cn/isp/esb/maintain/addRecord.do";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager POST:dataurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        [SVProgressHUD showSuccessWithStatus:@"💐提交成功!"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];//数据内容
        NSString *s2 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@",s2);
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
    
    
}
@end

