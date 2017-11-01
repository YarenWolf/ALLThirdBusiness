//
//  MessageContentTxtTableViewCell.h
//  YunDong55like
//
//  Created by junseek on 15-6-17.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//文本+表情。。。。

#import <UIKit/UIKit.h>

@class MessageContentTxtTableViewCell;
@protocol MessageContentTxtTableViewCellDelegate <NSObject>

@optional  //可选
//点击头像
-(void)messageContentTxtTableViewCell:(MessageContentTxtTableViewCell *)sview clickedUserLogo:(NSDictionary *)userDic;
//长按头像
-(void)messageContentTxtTableViewCell:(MessageContentTxtTableViewCell *)sview iconLongPress:(NSDictionary *)dic;

@end



@interface MessageContentTxtTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MessageContentTxtTableViewCellDelegate> delegate;
//内容更新
-(void )setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath superViewController:(BaseViewController *)baseV hiddenName:(BOOL)hiddenName;
@end
