//
//  GroupMembersViewController.m
//  ZCW55like
//
//  Created by ios-4 on 15/12/8.
//  Copyright (c) 2015年 55like. All rights reserved.
//

#import "GroupMembersViewController.h"
#import "RHTableView.h"
#import "NetEngine.h"
#import "GroupMembersViewCell.h"
#import "BodyInfoDetailViewController.h"
#import "MessageContentViewController.h"
#import "UserInfoViewController.h"



@interface GroupMembersViewController ()<UIAlertViewDelegate>{
    RHTableView *refTableView;
}

@end

@implementation GroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
}
-(void)initUI{
    refTableView = [[RHTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    refTableView.delegate = self;
    refTableView.dataSource = self;
    [refTableView setBackgroundColor:[UIColor whiteColor]];
    [refTableView showRefresh:YES LoadMore:YES];
    [refTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:refTableView];
    
    [self loadData];
}

-(void)loadData{
    refTableView.urlString = [NSString stringWithFormat:CHATJOINERINFORMATIONget,[[Utility Share] userId],[[Utility Share] userToken],[self.otherInfo valueForJSONStrKey:@"order_no"]];
    [refTableView refresh];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  refTableView.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = refTableView.dataArray[indexPath.row];
    GroupMembersViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMembersViewCell"];
    if (cell == nil) {
        cell =[[GroupMembersViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupMembersViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setValueForDictionary:dic];
    
    [cell setUserInfoListCellDidOnclickBlock:^(NSDictionary *dic, BOOL chat, BOOL phone) {
        if (chat) {
            //单独聊天
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:[dic valueForJSONStrKey:@"id"] forKey:@"id"];
            [dict setValue:@"1" forKey:@"type"];
            [dict setValue:[self.otherInfo valueForJSONStrKey:@"order_no"] forKey:@"order_no"];
            [dict setValue:[self.otherInfo valueForJSONStrKey:@"orderType"] forKey:@"orderType"];
            [self pushController:[MessageContentViewController class] withInfo:nil withTitle:@"即时通讯" withOther:dict];
        }else if (phone){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dic valueForJSONStrKey:@"mobile"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
            alert.tag = 10;
            [alert show];
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = refTableView.dataArray[indexPath.row];
    if ([[dict valueForJSONKey:@"id"] isEqualToString:[[Utility Share] userId]]) {
        [self pushController:[UserInfoViewController class] withInfo:nil withTitle:ssssss(@"个人资料", @"") withOther:nil];
    }else {
       [self pushController:[BodyInfoDetailViewController class] withInfo:@"修改" withTitle:@"保镖详情" withOther:[[NSDictionary alloc] initWithObjectsAndKeys:[refTableView.dataArray[indexPath.row] valueForJSONStrKey:@"id"],@"uid", nil]];
    }
    
}

#pragma mark - uialertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"呼叫");
        NSString *telURL = [NSString stringWithFormat:@"telprompt:%@",alertView.message];
        NSURL *url = [[NSURL alloc] initWithString:telURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}



@end
