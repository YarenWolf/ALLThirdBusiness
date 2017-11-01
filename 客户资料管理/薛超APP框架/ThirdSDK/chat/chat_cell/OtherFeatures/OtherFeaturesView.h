//
//  OtherFeaturesView.h
//  YunDong55like
//
//  Created by junseek on 15-7-2.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//其他功能模块（选择照片、拍照）

#import <UIKit/UIKit.h>
@class OtherFeaturesView;
@protocol OtherFeaturesViewDelegate <NSObject>

@optional  //可选
-(void)OtherFeaturesViewSelectPhoto:(OtherFeaturesView *)view;//选择照片
-(void)OtherFeaturesViewCamera:(OtherFeaturesView *)view;//拍照

@end

@interface OtherFeaturesView : UIView

@property(nonatomic,assign)id<OtherFeaturesViewDelegate>delegate;
@end
