//
//  ZhangdanViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/11/9.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "ZhangdanViewController.h"
#import "Utility.h"
#import "Record.h"
#import "DrawViewController.h"
#import "AddActViewController.h"
@interface ZhangdanCell:BaseTableViewCell
-(void)setDataWithPerson:(Record*)record;
@end
@implementation ZhangdanCell{
    UILabel *phone;
    UILabel *nameLabel;
    UILabel *time;
    UILabel *wechat;
    UILabel *bname;
    UILabel *bphone;
    UILabel *ftime;
    UILabel *recorditem;
}
-(void)initUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10, 150, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(XW(nameLabel)+10, Y(nameLabel), 150, H(nameLabel))];
    bname = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel),YH(nameLabel)+20, W(nameLabel),H(nameLabel))];
    bphone = [[UILabel alloc]initWithFrame:CGRectMake(X(phone), Y(bname), W(phone), H(nameLabel))];
    wechat = [[UILabel alloc]initWithFrame:CGRectMake(XW(bphone)+10, Y(bphone), 150, 20)];
    time = [[UILabel alloc]initWithFrame:CGRectMake(XW(phone)+10, Y(nameLabel), 150, 20)];
    ftime = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, Y(nameLabel), 100, 20)];
    ftime.textAlignment = NSTextAlignmentRight;
    recorditem = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200,Y(bname),100, 20)];
    recorditem.textAlignment = NSTextAlignmentRight;
    time.font= phone.font = bphone.font = wechat.font = ftime.font = recorditem.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 79, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self addSubviews:nameLabel,phone,time,wechat,bname,bphone,ftime,recorditem,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{}
-(void)setDataWithPerson:(Record*)record{
    nameLabel.text = [NSString stringWithFormat:@"类型:%@",record.type];//收入支出预算
    phone.text = [NSString stringWithFormat:@"时间:%@",record.date];
    bname.text = [NSString stringWithFormat:@"账户:%@",record.yinhang];
    bphone.text = [NSString stringWithFormat:@"账号:%@",record.account];
    wechat.text = [NSString stringWithFormat:@"金额:%0.2lf",record.money];
    time.text = [NSString stringWithFormat:@"分类:%@",record.classItem];
    ftime.text = [NSString stringWithFormat:@"说明:%@",record.descript];
    if([record.type isEqualToString:@"收入"]){
        recorditem.text = [NSString stringWithFormat:@"收入项目:%@",record.inputItem];
    }else if([record.type isEqualToString:@"支出"]){
        recorditem.text = [NSString stringWithFormat:@"支出项目:%@",record.outputItem];
    }else{
        recorditem.text = [NSString stringWithFormat:@"预算项目:%@",record.expectItem];
    }
}
-(NSArray *)observableKeypaths{return nil;}
@end

@interface ZhangdanViewController ()<UISearchBarDelegate>{
}
@end
@implementation ZhangdanViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]init];
    self.tableView.editingStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    NSArray *a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:nil];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:a];
    self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:80 sectionN:1 rowN:self.tableView.dataArray.count cellName:@"ZhangdanCell"];
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH-46);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH-46);
        [self.tableView reloadData];
    }
}
-(void)addyinhangka{
    [self pushController:[AddActViewController class] withInfo:nil withTitle:@"添加银行卡"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZhangdanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [ZhangdanCell getInstance];
    }
    [cell setDataWithPerson:self.tableView.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Record *record = self.tableView.dataArray[indexPath.row];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end


