//
//  AccountViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/11/8.
//  Copyright © 2016年 薛超. All rights reserved.
//银行卡，账号，余额，提醒，点进去月度年度曲线图

#import "AccountViewController.h"
#import "Utility.h"
#import "Acount.h"
#import "DrawViewController.h"
#import "AddActViewController.h"
@interface AccountCell:BaseTableViewCell
-(void)setDataWithPerson:(Acount*)acount;
@end
@implementation AccountCell{
    UILabel *phone;
    UILabel *nameLabel;
    UILabel *time;
    UILabel *wechat;
    UILabel *bname;
    UILabel *bphone;
    UILabel *ftime;
}
-(void)initUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10, 150, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(XW(nameLabel)+10, Y(nameLabel), 150, H(nameLabel))];
    bname = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel),YH(nameLabel)+20, W(nameLabel),H(nameLabel))];
    bphone = [[UILabel alloc]initWithFrame:CGRectMake(X(phone), Y(bname), W(phone), H(nameLabel))];
    wechat = [[UILabel alloc]initWithFrame:CGRectMake(XW(bphone)+10, Y(bphone), 150, 20)];
    time = [[UILabel alloc]initWithFrame:CGRectMake(XW(phone), Y(nameLabel), 150, 20)];
    ftime = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, Y(nameLabel), 100, 20)];
    ftime.textAlignment = NSTextAlignmentRight;
    time.font= phone.font = bphone.font = wechat.font = ftime.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 79, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubviews:nameLabel,phone,time,wechat,bname,bphone,ftime,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{}
-(void)setDataWithPerson:(Acount*)acount{
    nameLabel.hidden = phone.hidden = bname.hidden = bphone.hidden = wechat.hidden = time.hidden = ftime.hidden = NO;
    nameLabel.text = [NSString stringWithFormat:@"银行:%@",acount.yinhang];
    phone.text = [NSString stringWithFormat:@"账号:%@",acount.account];
    bname.text = [NSString stringWithFormat:@"提示:%@",acount.tips];
    bphone.text = [NSString stringWithFormat:@"最低还款:%0.2lf",acount.least];
    wechat.text = [NSString stringWithFormat:@"额度:%0.2lf",acount.edu];
    time.text = [NSString stringWithFormat:@"余额:%0.2lf",acount.yue];
    ftime.text = [NSString stringWithFormat:@"欠款:%0.2lf",acount.arrears];
    if([acount.type isEqualToString:@"银行卡"]){
        bphone.hidden = wechat.hidden = ftime.hidden = YES;
    }else if([acount.type isEqualToString:@"信用卡"]){
        
    }else if([acount.type isEqualToString:@"微信"]){
        bphone.hidden = wechat.hidden = ftime.hidden = YES;
    }else if([acount.type isEqualToString:@"支付宝"]){
        bphone.hidden = wechat.hidden = ftime.hidden = YES;
    }else{//现金
        bphone.hidden = wechat.hidden =YES;
    }
}
-(NSArray *)observableKeypaths{return nil;}
@end

@interface AccountViewController ()<UISearchBarDelegate>{
}
@end
@implementation AccountViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *add1= [[UIBarButtonItem alloc]initWithTitle:@"增加银行卡" style:UIBarButtonItemStylePlain target:self action:@selector(addyinhangka1)];
    UIBarButtonItem *add2= [[UIBarButtonItem alloc]initWithTitle:@"任务提醒" style:UIBarButtonItemStylePlain target:self action:@selector(addyinhangka2)];
    self.navigationItem.rightBarButtonItems = @[add1,add2];
    self.tableView = [[BaseTableView alloc]init];
    self.tableView.editingStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Acount"];
    NSArray *a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:nil];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:a];
    self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:80 sectionN:1 rowN:self.tableView.dataArray.count cellName:@"AccountCell"];
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
        [self.tableView reloadData];
    }
}
-(void)addyinhangka1{
    [self pushController:[AddActViewController class] withInfo:nil withTitle:@"添加银行卡"];
}
-(void)addyinhangka2{
    [self pushController:[AddActViewController class] withInfo:nil withTitle:@"增加提醒"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [AccountCell getInstance];
    }
    [cell setDataWithPerson:self.tableView.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Acount *account = self.tableView.dataArray[indexPath.row];
    [self pushController:[DrawViewController class] withInfo:nil withTitle:account.yinhang withOther:account];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end

