//
//  SystemMessageTableViewCell.h
//  YunDong55like
//
//  Created by junseek on 15/8/7.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//系统消息

#import <UIKit/UIKit.h>

@interface SystemMessageTableViewCell : UITableViewCell
//内容更新
-(void )setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath;
@end
