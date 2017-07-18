//
//  DownloadWebResourceViewController.m
//  音乐播放器
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
#pragma mark   DownloadWithURLSession
#import "DownloadWebResourceViewController.h"
@interface DownloadWebResourceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation DownloadWebResourceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)startDownloadByDataTask:(id)sender {
    //准备工作：图片url
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.egouz.com/uploadfile/2015/0305/20150305103644803.jpg"]];
    //1.获取单例session对象(不想监控下载进度)
    NSURLSession *session = [NSURLSession sharedSession];
    //2.创建数据任务//它自动进入子线程下载。
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"服务器返回:%@", [NSThread currentThread]);
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            //data -> imageView
            UIImage *image = [UIImage imageWithData:data];
            //主队列异步执行 -》 回到主线程赋值
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        } else {
            NSLog(@"下载失败:%@", error.userInfo);
        }
    }];
    //3.执行任务
    [dataTask resume];
}

- (IBAction)startDownlodByDownloadTask:(id)sender {
    //准备工作
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.egouz.com/uploadfile/2015/0305/20150305103644803.jpg"]];
    //1.单例session
    NSURLSession *session = [NSURLSession sharedSession];
    //2.创建下载任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"服务器返回:%@", [NSThread currentThread]);
        NSLog(@"图片存到:%@", location);
        //需求二：直接显示,不想保存
        //        UIImage *image = [UIImage imageWithContentsOfFile:location.path];
        //需求一：移动Caches下面，再显示
        //为防止瞬间就被删除缓存，在location下的文件移动到/Libary/Caches/...
        //只要是在block中，图片在；location下的文件移动到/Libary/Caches/...(响应的另一个属性)
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        //MIME: image/png; image/jpeg; image/gif
        //移动
        NSError *fileError = nil;
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:&fileError];
        if ([(NSHTTPURLResponse*)response statusCode]==200||(!fileError)) {
            //UIImage从filePath读取
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            //回到主线程显示
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    }];
    //3.执行任务
    [task resume];
}


@end
