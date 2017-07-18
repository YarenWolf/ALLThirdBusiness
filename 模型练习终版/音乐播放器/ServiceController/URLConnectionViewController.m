//
//  URLConnectionViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//
#pragma mark  URLConnection已经过时仅作为了解
#import "URLConnectionViewController.h"

@interface URLConnectionViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@end

@implementation URLConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)sendSyncRequest:(id)sender {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
    NSError *error = nil;
    NSData *htmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    [self.webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
    NSLog(@"加载完毕");
}

- (IBAction)sendAsyncRequest:(id)sender {
    //尽量掌握：webView加载方式二+获取状态码
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
    //queue：主队列(block代码在主线程执行)；非主队列(block在子线程执行)
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        /*NSURLResponse:服务器返回的响应类(状态码)
         data:请求资源的数据(主页/图片。。。)
         connectionError：错误对象
         */
        NSLog(@"服务器返回:%@", [NSThread currentThread]);
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            //成功接收主页(index.html);data加载到webView(方式二)
            //baseURL:指定加载index.html主页的本地URL(沙盒/Library/Caches/)
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            [self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[NSURL fileURLWithPath:cachesPath]];
            
        } else {
            NSLog(@"返回主页失败：%@", connectionError.userInfo);
        }
    }];
    
    NSLog(@"加载完毕");
}
@end
