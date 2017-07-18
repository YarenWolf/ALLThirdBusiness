//
//  CustomXunfei.h
//  讯飞demo
//
//  Created by ZhangCheng on 14-4-4.
//  Copyright (c) 2014年 ZhangCheng. All rights reserved.
//

//zc封装语音识别有UI~1.0版本
/*
 需要添加系统的库
 AdSupport
 AddressBook
 QuartzCore
 SystemCOnfiguration
 AudioToolBox
 libz
 讯飞提供的库
 添加iflyMSC的时候需要注意，不要拖入工程，应该采用addfiles添加文件
 iflyMSC.frameWork
 
 注 讯飞语音当前并不支持arm64 所以需要删除arm64的支持
 
 代码示例
 //读取
 CustomXunfei*xunfei=[CustomXunfei shareManager];
 [xunfei playStart:@"啊啊啊啊啊啊啊啊啊啊"];
 
 //识别
 CustomXunfei*xunfei=[CustomXunfei shareManager];
 [xunfei discernBlock:^(NSString *a) {
 NSLog(@"识别出来的结果~%@",a);
 }];
 */
#import <Foundation/Foundation.h>
//读取
#import "iflyMSC/IFlySynthesizerViewDelegate.h"
#import "iflyMSC/IFlySynthesizerView.h"
//识别

#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
@interface CustomXunfei : NSObject
<IFlySynthesizerViewDelegate,IFlyRecognizerViewDelegate>
{

    IFlySynthesizerView* iFlySynthesizerView;//播放使用
    
    IFlyRecognizerView*iFlyRecognizerView;//识别

}

@property(nonatomic,copy)void(^onResult)(NSString*);
//获得指针的单例
+(id)shareManager;
//识别
-(void)discernBlock:(void(^)(NSString*))a;
//读取
-(void)playStart:(NSString*)content;
@end
