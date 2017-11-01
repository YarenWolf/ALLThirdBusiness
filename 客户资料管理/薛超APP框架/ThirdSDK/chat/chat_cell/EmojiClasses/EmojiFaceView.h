//
//  DDEmojiFaceView.h
//  YunDong55like
//
//  Created by junseek on 15-5-25.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.

#import <UIKit/UIKit.h>
@protocol facialViewDelegate

//选中
-(void)selectedFacialView:(NSString*)str;

@end
@interface EmojiFaceView : UIView
@property(nonatomic,assign)id<facialViewDelegate>delegate;
-(void)loadFacialView:(int)page size:(CGSize)size;
@end
