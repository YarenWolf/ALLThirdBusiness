
//
//  AddActViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/11/9.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "AddActViewController.h"
#import "Acount.h"
@interface AddActViewController (){
    NSMutableArray *cells;
    NSArray *titles;
    NSMutableArray *accounts;
    NSArray *a;
}
@end
@implementation AddActViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    cells = [NSMutableArray arrayWithCapacity:10];
    if([self.title isEqualToString:@"增加提醒"]){
        NSArray *titlesA = @[@"提醒日期",@"名称",@"内容",@"时间",@"地点",@"资源",@"对象",@"时长"];
        for(int i=0;i<8;i++){
            SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
            c.title = titlesA[i];
            c.isFill = YES;
            [cells addObject:c];
        }
    }else{
        NSArray *titlesA = @[@"类型",@"名称",@"账号",@"余额",@"额度",@"欠款",@"最低还款",@"提醒",@"其他"];
        NSArray *yinhangArray = @[@"微信",@"支付宝",@"现金",@"中国银行",@"建设银行",@"招商银行",@"交通银行",@"工商银行",@"邮政银行",@"浦发银行",@"农业银行",@"华夏银行",@"兴业银行",@"其他银行"];
        for(int i=0;i<8;i++){
            SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
            c.title = titlesA[i];
            if(i==0){
                c.cellArray = @[@"银行卡",@"信用卡",@"微信",@"支付宝",@"现金"];
            }else if(i==1){
                c.cellArray = yinhangArray;
            }else{
                c.isFill = YES;
            }
            [cells addObject:c];
        }
    }
    group1.items = cells;
    [self.groups addObject:group1];
    self.tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 50)];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, APPW-50, 40)];
    [next setTitle:@"提   交" forState:UIControlStateNormal];
    next.layer.cornerRadius = 20;next.tag = 1;
    next.backgroundColor = redcolor;
    if([self.title isEqualToString:@"增加提醒"]){
        [next addTarget:self action:@selector(addTips) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [next addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.tableFootView addSubview:next];
    [self fillTheTableDataWithHeadV:nil footV:self.tableFootView canMove:NO canEdit:NO headH:0 footH:0 rowH:44 sectionN:1 rowN:titles.count cellName:@"SBaseCell"];
    self.tableView.frame = CGRectMake(0, -40, APPW, APPH+20);
    [self.tableView reloadData];
}
-(void)submit{
    if(![[self.values valueForKey:@"00"]notEmptyOrNull]||![[self.values valueForKey:@"01"]notEmptyOrNull]||![[self.values valueForKey:@"02"]notEmptyOrNull]||![[self.values valueForKey:@"03"]notEmptyOrNull]||![[self.values valueForKey:@"04"]notEmptyOrNull]||![[self.values valueForKey:@"05"]notEmptyOrNull]){
        [SVProgressHUD showErrorWithStatus:@"请把信息填写完整"];return;
    }
    if([self.values[@"00"]isEqualToString:@"微信"]||[self.values[@"00"]isEqualToString:@"支付宝"]||[self.values[@"00"]isEqualToString:@"现金"]){
        if(![self.values[@"01"]isEqualToString:self.values[@"00"]]){
            [SVProgressHUD showErrorWithStatus:@"类型与名称不符"];return;
        }
    }
    AppDelegate *dele =[AppDelegate Share];
    Acount *acd =[NSEntityDescription insertNewObjectForEntityForName:@"Acount" inManagedObjectContext:dele.managedObjectContext];
    acd.type = self.values[@"00"];
    acd.yue = [self.values[@"03"]doubleValue];
    acd.yinhang = self.values[@"01"];
    acd.account = self.values[@"02"];
    acd.tips = [self.values[@"07"]notEmptyOrNull]?self.values[@"07"]:@"";
    acd.edu = [self.values[@"04"]doubleValue];
    acd.arrears = [self.values[@"05"]doubleValue];
    acd.least = [self.values[@"06"]doubleValue];
    acd.descript= [self.values[@"08"]notEmptyOrNull]?self.values[@"08"]:@"";
    [[AppDelegate Share] saveContext];
    [SVProgressHUD showSuccessWithStatus:@"恭喜提交成功!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)addTips{
    [SVProgressHUD showSuccessWithStatus:@"恭喜提交成功!"];
}
@end

