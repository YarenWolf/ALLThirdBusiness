
//
//  WebViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewController+Extension.h"
@interface WebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation WebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView=[[UIWebView alloc]initWithFrame:self.view.frame];
    //创建请求类NSURLRequest
    NSURL *url = [NSURL URLWithString:@"http://www.sina.com.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //设置代理
    self.webView.delegate = self;
    //webView加载/发送请求(异步)
    [self.webView loadRequest:request];
    [self PrintCacheData:@"发送请求完毕"];
}
#pragma mark - webViewDelegate
//开始加载(networkActivityIndicator)
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self PrintCacheData:[NSString stringWithFormat:@"%s", __func__]];
    //设置indivatorView动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
//成功返回,并加载成功
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self PrintCacheData:[NSString stringWithFormat:@"%s", __func__]];
    //停止动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//失败返回
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self PrintCacheData:[NSString stringWithFormat:@"失败原因：%@", error.userInfo]];
    //停止动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
