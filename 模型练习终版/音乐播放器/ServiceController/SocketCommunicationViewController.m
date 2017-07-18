
//
//  SocketCommunicationViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SocketCommunicationViewController.h"
#import "UIViewController+Extension.h"
#import "GCDAsyncSocket.h"
@interface SocketCommunicationViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *IPTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *showDataFromServer;
//客户端的socket属性
@property(nonatomic,strong)GCDAsyncSocket *clientSocket;
@end

@implementation SocketCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)connectToHost:(id)sender {
    //IP地址+port
    //初始化clientSocket对象
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接
    uint16_t port = 8888;
    NSString *ipStr = self.IPTextField.text;
    NSError *error = nil;
    [self.clientSocket connectToHost:ipStr onPort:port error:&error];
    if (error) {
        [self PrintCacheData:[NSString stringWithFormat:@"无法连接:%@", error.userInfo]];
    } else {
        [self PrintCacheData:[NSString stringWithFormat:@"可以/正在连接。。。。"]];
    }

}
- (IBAction)sendMessageToHost:(id)sender {
    //发送消息逻辑
    [self.clientSocket writeData:[self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
-(void)dealloc{
    //关闭已经连接的socket
    [self.clientSocket disconnect];
}
#pragma mark -- 协议相关方法
//是否连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self PrintCacheData:@"客户端和服务器端的socket连接成功"];
    //设置客户端处于接收数据的状态(-1：表示不设置超时时间)
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
//客户端是否发送成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self PrintCacheData:@"客户端已经发送成功"];
}
//已经接收到服务器端的数据->textView
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //data->NSString
    NSString *dataFromHost = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //显示返回的文本到textView上
    self.showDataFromServer.text = [NSString stringWithFormat:@"%@%@\n", self.showDataFromServer.text, dataFromHost];
    //设置客户端处于接收数据的状态
    [self.clientSocket readDataWithTimeout:-1 tag:0];
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
