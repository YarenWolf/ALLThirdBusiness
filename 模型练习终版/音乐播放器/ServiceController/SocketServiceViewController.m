//
//  SocketServiceViewController.m
//  音乐播放器
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
#import "SocketServiceViewController.h"
#import "GCDAsyncSocket.h"
#import <AudioToolbox/AudioToolbox.h>
@interface SocketServiceViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSMutableArray *connectedSockets;
//用于保存当前连接进入的客户端对象
@property(nonatomic,strong) GCDAsyncSocket *clientSocket;
@end
@implementation SocketServiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.connectedSockets = [[NSMutableArray alloc] init];
    if (!self.asyncSocket) {
        NSLog(@"初始化失败");
    } else {
        NSError *error = nil;
        uint16_t port = 8888;
        //启动监听
        if(![self.asyncSocket acceptOnPort:port error:&error]){
            NSLog(@"启动失败");
        }
    }
}
- (IBAction)sendMessageToClient:(id)sender {
    NSData *data = [self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:5 tag:0];
}
#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"Accepted new Socket from %@:%hu",[newSocket connectedHost],[newSocket connectedPort]);
    self.clientSocket = newSocket;
    //newSocket自动设置本身代理为当前控制器
    //开始读取客户端传入的数据
    //Timeout:超时。 表示读取多长时间， 传入-1代表没有超时
    //tag：读取操作的标识
    [self.clientSocket readDataWithTimeout:-1 tag:100];
    //    [self.connectedSockets addObject:newSocket];
    //    [newSocket readDataWithTimeout:5 tag:0];
    //    [newSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:5 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    AudioServicesPlaySystemSound(1000);
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.messageTextView.text = [NSString stringWithFormat:@"%@%@\n", self.messageTextView.text, dataStr];
    //触发完毕之后，则读取操作会被取消,我们需要重新再开启另一个读取
    [self.clientSocket readDataWithTimeout:-1 tag:100];
    NSLog(@"New message from client!!!");
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    self.asyncSocket = nil;
    self.asyncSocket.delegate = nil;
}
-(void)dealloc{
    [self.asyncSocket setDelegate:nil];
    [self.asyncSocket disconnect];
}
@end
