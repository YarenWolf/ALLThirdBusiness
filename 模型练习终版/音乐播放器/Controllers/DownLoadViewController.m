//
//  DownLoadViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "DownLoadViewController.h"
#import "Student.h"
#import "UIView+Extension.h"
@interface DownLoadViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,strong)NSURL *imageURL;
@property(nonatomic,strong)UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
-(void)updateImageView:(UIImage*)image;
@end
@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.scrollView.frame=self.view.frame=CGRectMake(self.view.bounds.size.width/2, 10, 0, 0);
        [UIView animateWithDuration:2 animations:^{
            self.scrollView.frame=self.view.frame=CGRectMake(100, 100, 300, 600);
        }];
    //动画开始
    [self.activity startAnimating];
    //实现图片缓存的原理
    //首先判断字典中是否有图片
    Student *imageCenter=[Student sharedImageCenter];
    UIImage *image=imageCenter.mutableDic[self.imageURL.absoluteString];
    if (image) {
        //字典中有数据，直接显示
        [self updateImageView:image];
    }else{
        //字典中没有数据，从沙盒指定的文件中读取
        NSString *imagePath=[self getImagePathFromSandbox:self.imageURL];
        NSData *imageData=[NSData dataWithContentsOfFile:imagePath];
        if (imageData) {
            //沙盒中有
            [self updateImageView:[UIImage imageWithData:imageData]];
        }else{
            //字典和沙盒都没有，从网络下。
            [self startDownloadAndStore];
        }
    }
}
-(id)initWithImageURL:(NSURL*)imageURL{
    self=[super initWithNibName:@"View" bundle:nil];;
    //赋值
    if (self) {
        self.imageURL=imageURL;
    }return self;
}
-(void)updateImageView:(UIImage*)image{
    //设置scroll的代理
    self.scrollView.delegate=self;
    self.scrollView.maximumZoomScale=2;
    self.scrollView.minimumZoomScale=0.1;
    self.imageView=[[UIImageView alloc]initWithImage:image];
    self.scrollView.contentSize=image.size;
    [self.scrollView addSubview:self.imageView];
    //停止动画刷新
    [self.activity stopAnimating];
}
-(void)startDownloadAndStore{
    //使用GCD下载图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData=[NSData dataWithContentsOfURL:self.imageURL];
        UIImage *image=[UIImage imageWithData:imageData];
        //存入字典中
        Student *imageCenter=[Student sharedImageCenter];
        imageCenter.mutableDic[self.imageURL] = image;
        //存到沙盒中
        NSString *imagePath = [self getImagePathFromSandbox:self.imageURL];
        [imageData writeToFile:imagePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI
            [self updateImageView:image];
        });
    });
}
-(NSString*)getImagePathFromSandbox:(NSURL*)imageURL{
    //需求：XXX/library/caches/photo_%d.jpg
    NSString *caches=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //NSURL取地址的最后一个组件。component
    return [caches stringByAppendingPathComponent:[imageURL lastPathComponent]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
