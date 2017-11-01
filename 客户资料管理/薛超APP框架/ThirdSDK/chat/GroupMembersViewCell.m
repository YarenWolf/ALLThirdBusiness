//
//  GroupMembersViewCell.m
//  ZCW55like
//
//  Created by ios-4 on 15/12/8.
//  Copyright (c) 2015年 55like. All rights reserved.
//

#import "GroupMembersViewCell.h"

@interface GroupMembersViewCell(){
    UIImageView *refAvatar;
    UILabel *refNickName;
    
    NSDictionary *dict;
    
}
@end


@implementation GroupMembersViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    refAvatar = [RHMethods imageviewWithFrame:CGRectMake(10, 10, 50, 50) defaultimage:@""];
    refAvatar.clipsToBounds=YES;
    refAvatar.layer.cornerRadius = 25;
    [contentView addSubview:refAvatar];
    
    
    refNickName = [RHMethods labelWithFrame:CGRectMake(XW(refAvatar) + 10, 10, 120, 50) font:Font(13) color:[UIColor blackColor] text:@""];
    [contentView addSubview:refNickName];
    
    UIButton *btn1 = [RHMethods buttonWithFrame:CGRectMake(kScreenWidth - 50, 10, 50, 50) title:@"" image:@"cont02" bgimage:@""];
    [btn1 addTarget:self action:@selector(remarkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn1];
    
    UIButton *btn2 = [RHMethods buttonWithFrame:CGRectMake(X(btn1) - 50, 10, 50, 50) title:@"" image:@"cont01" bgimage:@""];
    [btn2 addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn2];
    
    [contentView addSubview:[RHMethods imageviewWithFrame:CGRectMake(0, 69.5, kScreenWidth, 0.5) defaultimage:@"userLine"]];
    
}

-(void)setValueForDictionary:(NSDictionary *)dic{
    dict = [dic copy];
    [refAvatar imageWithURL:[dic valueForJSONStrKey:@"icon"] useProgress:NO useActivity:NO];
    refNickName.text = [dic valueForJSONStrKey:@"realname"];
}



#pragma mark - btn点击事件
- (void)statusBtnClick{
    //单聊
    _userInfoListCellDidOnclickBlock(dict,YES,NO);
}

- (void)remarkBtnClick{
    //电话
    _userInfoListCellDidOnclickBlock(dict,NO,YES);
}


@end
