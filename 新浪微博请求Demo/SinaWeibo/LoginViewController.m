//
//  LoginViewController.m
//  SinaWeibo
//
//  Created by Stephy_xue on 13-9-25.
//  Copyright (c) 2013年 Stephy_xue. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize completionHandler = _completionHandler;

- (id)initWithLoginCompletion:(void (^) (BOOL isLoginSuccess))isLoginSuccess
{
    if (self = [super init]) {
        self.completionHandler = isLoginSuccess;
    }
    return self;
}

- (void)dealloc
{
    [_webView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //自定义导航
    UIView *customNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    customNavBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:customNavBar];
    [customNavBar release];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setTitle:@"取消" forState:UIControlStateNormal];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    returnBtn.frame = CGRectMake(7, 7, 50, 30);
    [returnBtn addTarget:self action:@selector(Cancelbtn) forControlEvents:UIControlEventTouchUpInside];
    [customNavBar addSubview:returnBtn];
    
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,44, 320, 436)];
	_webView.delegate = self;
	[self.view addSubview:_webView];
    
    [self startRequest];
}

-(void)Cancelbtn
{
    _webView.delegate = nil;
    if(self.completionHandler)
    {
        self.completionHandler(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark 请求网络

-(void)startRequest
{
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[LPSinaEngine authorizeURL]];
	[_webView loadRequest:request];
    [request release];
}


#pragma mark -
#pragma mark UIWebView代理方法

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@"code="].location != NSNotFound) {
        NSString *code = [[request.URL.query componentsSeparatedByString:@"="] objectAtIndex:1];
        [LPSinaEngine getAccessToken:code success:^(BOOL isSuccess){
            if (isSuccess) {
                [self dismissViewControllerAnimated:YES completion:nil];
                if(self.completionHandler)
                {
                    self.completionHandler(YES);
                }
            }
        }];
        return NO;
    }
    return YES;
}

@end
