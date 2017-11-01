//
//  GroupMembersViewCell.h
//  ZCW55like
//
//  Created by ios-4 on 15/12/8.
//  Copyright (c) 2015年 55like. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMembersViewCell : UITableViewCell
@property (nonatomic, copy) void (^userInfoListCellDidOnclickBlock)(NSDictionary *dic,BOOL chat ,BOOL phone);

-(void)setValueForDictionary:(NSDictionary *)dic;
@end
