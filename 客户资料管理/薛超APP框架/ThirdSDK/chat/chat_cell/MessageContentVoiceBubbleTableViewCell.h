//
//  MessageContentVoiceBubbleTableViewCell.h
//  YunDong55like
//
//  Created by junseek on 15-6-30.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//聊天语音cell

#import <UIKit/UIKit.h>
#import "FSVoiceBubble.h"

@class MessageContentVoiceBubbleTableViewCell;
@protocol MessageContentVoiceBubbleTableViewCellDelegate <NSObject>

@optional  //可选
//开始
-(void)MessageContentVoiceBubbleTableViewCell:(MessageContentVoiceBubbleTableViewCell *)sview PlaybackAudio:(NSIndexPath *)index;
//停止语音
-(void)MessageContentVoiceBubbleTableViewCellStopPlay:(MessageContentVoiceBubbleTableViewCell *)sview;

//点击头像
-(void)MessageContentVoiceBubbleTableViewCell:(MessageContentVoiceBubbleTableViewCell *)sview clickedUserLogo:(NSDictionary *)userDic;
//长按头像
-(void)MessageContentVoiceBubbleTableViewCell:(MessageContentVoiceBubbleTableViewCell *)sview iconLongPress:(NSDictionary *)userDic;



@end

@interface MessageContentVoiceBubbleTableViewCell : UITableViewCell
@property (nonatomic,strong) FSVoiceBubble *voiceView;
@property (nonatomic, weak) id<MessageContentVoiceBubbleTableViewCellDelegate> delegate;
//内容更新
-(void )setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath payIndexP:(NSIndexPath *)payIndex hiddenName:(BOOL)hiddenName;
@end
