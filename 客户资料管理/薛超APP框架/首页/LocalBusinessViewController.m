//
//  LocalBusinessViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/11/2.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "LocalBusinessViewController.h"
#import "DetailLocalViewController.h"
#import "Utility.h"
#import "Customdata.h"
@interface LocalBusinessCell:BaseTableViewCell
-(void)setDataWithPerson:(Customdata*)person;
@end
@implementation LocalBusinessCell{
    UILabel *phone;
    UILabel *nameLabel;
    UILabel *time;
    UILabel *wechat;
    UILabel *bname;
    UILabel *bphone;
    UILabel *ftime;
}
-(void)initUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,5, 150, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(XW(nameLabel)+10, Y(nameLabel), 150, H(nameLabel))];
    bname = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel),YH(nameLabel)+10, W(nameLabel),H(nameLabel))];
    bphone = [[UILabel alloc]initWithFrame:CGRectMake(X(phone), Y(bname), W(phone), H(nameLabel))];
    wechat = [[UILabel alloc]initWithFrame:CGRectMake(XW(bphone)+10, Y(bphone), 150, 20)];
    time = [[UILabel alloc]initWithFrame:CGRectMake(XW(phone)+10, 5, 150, 20)];
    //    time.textAlignment = wechat.textAlignment = NSTextAlignmentRight;
    time.font= phone.font = bphone.font = wechat.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 59, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ftime = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, 5, 100, 20)];
    ftime.textAlignment = NSTextAlignmentRight;
    [self addSubviews:nameLabel,phone,time,wechat,bname,bphone,ftime,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{}
-(void)setDataWithPerson:(Customdata*)person{
    nameLabel.text = [NSString stringWithFormat:@"投保人:%@",person.tname];
    phone.text = [NSString stringWithFormat:@"手机号:%@",person.ttelephone];
    bname.text = [NSString stringWithFormat:@"被保人:%@",person.bname];
    bphone.text = [NSString stringWithFormat:@"手机号:%@",person.btelephone];
    wechat.text = [NSString stringWithFormat:@"保额:%@",person.tbaoe];
    time.text = [NSString stringWithFormat:@"保单号:%@",person.tid];
    ftime.text = [NSString stringWithFormat:@"%@",person.cfromtime];
}
-(NSArray *)observableKeypaths{return nil;}
@end

@interface LocalBusinessViewController ()<UISearchBarDelegate>{
}
@end
@implementation LocalBusinessViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, TopHeight, APPW-130, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = searchBar;
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH)];
    [[AppDelegate Share]readCustomData];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:[AppDelegate Share].customs];
    NSString *number = [NSString stringWithFormat:@"本地总共有 %ld 条记录。",self.tableView.dataArray.count];
    [SVProgressHUD showSuccessWithStatus:number];
    self.tableView.editingStyle = UITableViewCellEditingStyleNone;
    
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:60 sectionN:1 rowN:self.tableView.dataArray.count cellName:@"BusinessCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocalBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [LocalBusinessCell getInstance];
    }
    [cell setDataWithPerson:self.tableView.dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Customdata *person = self.tableView.dataArray[indexPath.row];
    [self pushController:[DetailLocalViewController class] withInfo:nil withTitle:person.tname withOther:person];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (searchText.length==0) {
        [del readCustomData];
        self.tableView.rowN = del.customs.count;
        self.tableView.dataArray = [NSMutableArray arrayWithArray:[AppDelegate Share].customs];
        [self.tableView reloadData];
        return;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customdata"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tname" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"tname CONTAINS %@ OR ttelephone CONTAINS %@ OR bname CONTAINS %@ OR btelephone CONTAINS %@ OR tid CONTAINS %@ OR taddress CONTAINS %@", searchText,searchText,searchText,searchText,searchText,searchText];
    NSError *error = nil;
    NSArray *b = [del.managedObjectContext executeFetchRequest:request error:&error];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:b];
//    DLog(@"%@\n\n%ld",self.tableView.dataArray,self.tableView.dataArray.count);
    self.tableView.rowN = self.tableView.dataArray.count;
    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    NSString *number = [NSString stringWithFormat:@"本地总共有 %ld 条记录。",self.tableView.dataArray.count];
    [SVProgressHUD showSuccessWithStatus:number];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
