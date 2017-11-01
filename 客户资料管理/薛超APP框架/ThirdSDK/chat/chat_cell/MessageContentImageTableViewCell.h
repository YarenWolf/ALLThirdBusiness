//
//  MessageContentImageTableViewCell.h
//  YunDong55like
//
//  Created by junseek on 15-7-3.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//聊天图片cell

#import <UIKit/UIKit.h>


@class MessageContentImageTableViewCell;
@protocol MessageContentImageTableViewCellDelegate <NSObject>

@optional
//点击头像
-(void)MessageContentImageTableViewCell:(MessageContentImageTableViewCell *)messageContentImageTableViewCell iconDidClick:(NSDictionary *)dic;
//长按头像
-(void)MessageContentImageTableViewCell:(MessageContentImageTableViewCell *)messageContentImageTableViewCell iconLongPress:(NSDictionary *)dic;
-(void)MessageContentImageTableViewCell:(MessageContentImageTableViewCell *)messageContentImageTableViewCell reviewImages:(NSDictionary *)dic index:(NSIndexPath *)indexPath;

@end

@interface MessageContentImageTableViewCell : UITableViewCell

//内容更新
-(void )setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath hiddenName:(BOOL)hiddenName;




@property(nonatomic,weak)id<MessageContentImageTableViewCellDelegate>   delegate;
@end
