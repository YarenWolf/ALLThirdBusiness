//
//  EmojiShowVIew.h
//  YunDong55like
//
//  Created by junseek on 15-7-1.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//
//表情展示view  高-216


#import <UIKit/UIKit.h>

@protocol EmojiShowVIewDelegate<NSObject>
-(void)insertEmojiFace:(NSString *)string;
-(void)deleteEmojiFace;
- (void)emotionViewClickSendButton;//发送

@end
@interface EmojiShowVIew : UIView

@property(assign)BOOL isOpen;
@property(nonatomic,assign)id<EmojiShowVIewDelegate>delegate;
@end
