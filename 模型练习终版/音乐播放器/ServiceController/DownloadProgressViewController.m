//
//  DownloadProgressViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
#import "DownloadProgressViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface DownloadProgressViewController ()<NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property(nonatomic)NSMutableData *mutableData;
@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSFileHandle *writeFileHandle;
//声明任务为了保存
@property(nonatomic,strong)NSURLSessionDownloadTask *task;
//保存点击暂停时的数据
@property(nonatomic,strong)NSData *resumeData;
//恢复下载
@property(nonatomic,strong)NSURLSession *session;

@end
@implementation DownloadProgressViewController
-(void)viewDidLoad{
    NSString *cachesPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath=[cachesPath stringByAppendingPathComponent:@"text.rmvb"];
    self.writeFileHandle=[NSFileHandle fileHandleForWritingAtPath:filePath];
    self.mutableData=[NSMutableData data];
}
#pragma mark download
-(IBAction)startOrPauseDownloadAndShowProgress:(UIButton*)sender{
    ////开始下载
    if (!sender.selected) {
    //需求：监控下载进度，更新进度视图
        if(!self.session){
            //1.和config结合的session结合.default一般选择，自动缓存文件等到磁盘中。
            //ehemeral：临时的，自动缓存文件到内存中。background后台：自动使用子线程处理缓存文件等。
            NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
            //代理方法在子线程中执行
            NSOperationQueue *queue=[NSOperationQueue new];
            self.session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
            //2.下载任务数据任务一样
            self.task=[self.session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.y.baidu.com/yinyueren/005904bbf1dbb81d2ea8480d04982207.MP3"]];
        }else{////继续下载
            //创建一个新的任务（从resumeData接着往后下载）；执行。
            self.task=[self.session downloadTaskWithResumeData:self.resumeData];
        }
    //3.执行任务
    [self.task resume];
    }else{
        ////暂停
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            //把resumeData存起来
            self.resumeData=resumeData;
            self.task=nil;
        }];
    }
    sender.selected=!sender.selected;
}
#pragma mark DownloadDelegate
//监听进度/*bytesWritten:totalBytesWritten:totalBytesExpectedToWrite:*/
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //回到主线程更新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress=totalBytesWritten*1.0/totalBytesExpectedToWrite;
    });
}
//监听下载结束(自动存到location中:/tmp文件夹下)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"已经下载完成:%@；%@", location, [NSThread currentThread]);
    //    UIImage *image = [UIImage imageWithContentsOfFile:location.path];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    if(![fileManager fileExistsAtPath:filePath]){//不存在，创建文件
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    [fileManager moveItemAtPath:location.path toPath:filePath error:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}
#pragma mark sessionDataDelegate
//调用多次,每次返回一段下载的数据
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"返回数据%lu",(unsigned long)data.length);
    //v2使用文件句柄对象将每次返回的data写入文件
    [self.writeFileHandle writeData:data];
    //将每次服务器返回的新的数据data存储到mutableData的后面。
    [self.mutableData appendData:data];
    //更新进度视图
    self.progressView.progress=dataTask.countOfBytesReceived*1.0/dataTask.countOfBytesExpectedToReceive;
    //更新imageView
    //self.imageView.image=[UIImage imageWithData:self.mutableData];
}
//监听下载完毕
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"下载完成：%@",error.userInfo);
    //self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:&error];
    self.player=[[AVAudioPlayer alloc]initWithData:self.mutableData error:nil];
    [self.player play];
}
@end
