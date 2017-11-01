//
//  PlanViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/21.
//  Copyright © 2016年 薛超. All rights reserved.
//工作计划

#import "PlanViewController.h"

@interface PlanViewController (){
    NSString *dataurl;
    NSMutableArray *cells;
    NSArray *titles;
}
//工作计划页面https://aes.aia.com.cn/isp/esb/maintain/getWorkPlanList.do
@end

@implementation PlanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建组
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    cells = [NSMutableArray arrayWithCapacity:10];
    titles = [NSArray arrayWithObjects:@"电话/面对面预约:",@"确定预约:",@"转介绍名单:",@"其他名单:",@"仅夜间:",@"夜间和白天",@"初次",@"后续:",@"完整的需求调查",@"其他",
              @"制作建议书的新单",@"成交面谈",@"保单件数",@"保额",@"年化保费",@"电话",@"现场展业",@"办公室",@"工作小时数",nil];
    for(int i=0;i<19;i++){
        SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
        c.title = titles[i];c.isFill = YES;
        [cells addObject:c];
    }
    group1.items = @[cells[0],cells[1],cells[2],cells[3],cells[4],cells[5],cells[6],cells[7],cells[8],cells[9],cells[10],cells[11],cells[12],cells[13],cells[14],cells[15],cells[16],cells[17],cells[18]];
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
-(void)submit{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
    [dict setObject:@"2015" forKey:@"year"];
    [dict setObject:@"10" forKey:@"month"];
    [dict setObject:@"4244" forKey:@"planDate1"];
    [dict setObject:@"add" forKey:@"update1"];
    [dict setObject:@"add" forKey:@"type1"];
    [dict setObject:@"2" forKey:@"updateId1"];
    [dict setObject:@"2" forKey:@"phoneAppoint1"];//电话/面对面预约
    [dict setObject:@"5" forKey:@"confirmAppoint1"];//确定预约
    [dict setObject:@"7" forKey:@"referralList1"];//转介绍名单
    [dict setObject:@"7" forKey:@"otherList1"];//其他名单
    [dict setObject:@"5" forKey:@"night1"];//仅夜间
    [dict setObject:@"75" forKey:@"dayAndNight1"];//夜间和白天
    [dict setObject:@"5" forKey:@"newMeeting1"];//初次
    [dict setObject:@"5" forKey:@"oldMeeting1"];//后续
    [dict setObject:@"7" forKey:@"allDemand1"];//完整的需求调查
    [dict setObject:@"8" forKey:@"other1"];//其他
    [dict setObject:@"9" forKey:@"suggestList1"];//制作建议书的新单
    [dict setObject:@"7" forKey:@"dealInterview1"];//成交面谈
    [dict setObject:@"5" forKey:@"policyCount1"];//保单件数
    [dict setObject:@"6" forKey:@"amount1"];//保额
    [dict setObject:@"7" forKey:@"yearPremium1"];//年化保费
    [dict setObject:@"18" forKey:@"telephone1"];//电话
    [dict setObject:@"5" forKey:@"localExhibition1"];//现场展业
    [dict setObject:@"5" forKey:@"office1"];//办公室
    [dict setObject:@"8" forKey:@"hourCount1"];//工作小时数
    dataurl = @"https://aes.aia.com.cn/isp/esb/maintain/saveWorkPlan.do";
    [NetEngine POST:dataurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        DLog(@"%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];//数据内容
        NSString *s2 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@",s2);
    }];
}


@end
