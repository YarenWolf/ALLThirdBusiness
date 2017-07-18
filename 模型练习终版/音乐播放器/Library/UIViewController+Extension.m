//
//  UIViewController+Extension.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "AllTheFileData.h"
@implementation UIViewController (Extension)
static UITextView *textView;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self isKindOfClass:[UIViewController class]]) {
        NSLog(@"%@",self.class);
    }
    if (!textView) {
    textView=[[UITextView alloc]initWithFrame:CGRectMake(20, 64, self.view.bounds.size.width-40, 0)];
    }
    textView.text=[AllTheFileData allDetailDescription:NSStringFromClass(self.class)];
    textView.font=[UIFont systemFontOfSize:17];
    textView.backgroundColor=[UIColor whiteColor];
    textView.editable=NO;
    [textView scrollRectToVisible:CGRectZero animated:YES];
    [self.view addSubview:textView];
    [UIView animateWithDuration:1 animations:^{
        textView.frame=CGRectMake(20, 64, self.view.bounds.size.width-40, self.view.bounds.size.height-100);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToView)];
        tap.numberOfTouchesRequired=1;
        tap.numberOfTapsRequired=2;
        [textView addGestureRecognizer:tap];
    }];
}
-(void)PrintCacheData:(NSString *)str{
    NSDictionary *textDictionary=@{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    if (!textView) {
        textView=[[UITextView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, 0, 0)];textView.text=str;
    }else{
    textView.text=[[textView.text stringByAppendingString:@"\n"]stringByAppendingString:str];
    }
    textView.font=[UIFont systemFontOfSize:17];
    textView.backgroundColor=[UIColor whiteColor];
    textView.editable=NO;
    [textView scrollsToTop];
    CGSize textOfSize = [textView.text boundingRectWithSize:CGSizeMake(200, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:textDictionary context:nil].size;
    [self.view addSubview:textView];
    [UIView animateWithDuration:1 animations:^{
        textView.frame=CGRectMake(20,self.view.bounds.size.height-self.tabBarController.tabBar.frame.size.height-10-textOfSize.height, self.view.bounds.size.width-40,textOfSize.height);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToView)];
        tap.numberOfTouchesRequired=1;
        tap.numberOfTapsRequired=2;
        [textView addGestureRecognizer:tap];
    }];
}
-(void)backToView{
    [UIView animateWithDuration:1 animations:^{
        textView.frame=CGRectMake(self.view.bounds.size.width/2, 0, 0, 0);
    } completion:^(BOOL finished) {
        [textView removeFromSuperview];
        textView.text=nil;
        textView=nil;
    }];
}

@end
