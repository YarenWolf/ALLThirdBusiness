//
//  OfficialSocketCommulationViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/14.
//  Copyright © 2016年 tarena. All rights reserved.
#import "OfficialSocketCommulationViewController.h"
///////1. UITableViewDataSource,UITableViewDelegate
@interface OfficialSocketCommulationViewController () <NSStreamDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
//////  2. 存储发送消息可变数组
@property (nonatomic, strong) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraints;
@end
@implementation OfficialSocketCommulationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    /////////  3. 初始化消息数组
    self.messages = [NSMutableArray new];
    ///////// 3. 设置table view delegate
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    //创建和服务器的连接
    [self createConnectionToServer];
    /////////// 监听键盘
    //UIKeyboardWillShowNotification
    //UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)dealloc {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
////////// 键盘上移
-(void)keyboardWillAppear:(NSNotification *)notification {
    NSLog(@"%@",notification.userInfo);
    // 获取窗口的高度
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    // 键盘的Frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.viewBottomConstraints.constant = windowHeight - keyboardFrame.origin.y-44;
}
////// 版本三：界面向下滚动，键盘退出
//Tells the delegate when the scroll view is about to start scrolling the content.
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //YES if the view resigned the first responder status
    [self.view endEditing:YES];
}

- (IBAction)enterCharRoom:(id)sender {
    // 1. 准备给服务器的文本字符串
    NSString *text = @"iam:shirle";;
    // 2. 将字符串转成 NSData
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    // 3. 写入输出流
    //- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)length
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (IBAction)sendMessage:(id)sender {
    //  1.  给服务器准备字符串
    NSString *text = [NSString stringWithFormat:@"msg:%@",self.messageField.text];
    //  2.  将字符串装换成 NSData
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    //  3. 写入输出流; 发送给服务器
    [self.outputStream write:[data bytes] maxLength:[data length]];
    //  清空输入框
    self.messageField.text = @"";
}

////////////// 6. table view delegate
#pragma mark - table view delegate functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *string = self.messages[indexPath.row];
    cell.textLabel.text = string;
    return cell;
}
/////////// 7. 处理接收数据，显示在table view上
//    NSStreamEventOpenCompleted = 1UL << 0,//输入输出流打开完成
//    NSStreamEventHasBytesAvailable = 1UL << 1,//有字节可读
//    NSStreamEventHasSpaceAvailable = 1UL << 2,//可以发放字节
//    NSStreamEventErrorOccurred = 1UL << 3,// 连接出现错误
//    NSStreamEventEndEncountered = 1UL << 4// 连接结束
#pragma mark - nsstream delegate
//  处理Socket 的回调事件
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream 打开了");
            break;
            // 处理服务器返回的数据
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有新数据");
            [self readBytes:aStream];
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送字节");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@" 连接出现错误");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"连接结束");
            // 关闭输入输出流
            [self.inputStream close];
            [self.outputStream close];
            // 从主运行循环移除
            [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        default:
            break;
    }
}

- (void)readBytes:(NSStream *)aStream {
    //  1.先判断是否为输入流
    if(aStream == self.inputStream){
        //  2. 为读取数据准备缓冲
        unsigned char buffer[1024];
        long len;
        //  有数据就循环读取
        while([self.inputStream hasBytesAvailable]){
            
            //  3.  把流里面的数据读取到缓冲区
            //                    A positive number indicates the number of bytes read;
            //                    0 indicates that the end of the buffer was reached;
            //                    A negative number means that the operation failed.
            len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
            // 4. 判断实际是否写入了数据
            if (len > 0) {
                //  5. 从缓冲区中读取len bytes的数据，转换成oc的字符串
                NSString *text = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                
                if (text != nil) {
                    NSLog(@"收到服务器的消息:%@",text);
                    // 存入字符串数组
                    [self.messages addObject:text];
                    // 刷新tableView
                    [self.messageTableView reloadData];
                     ////// 版本三：解决table view的上移问题
                    //                    //获取所有消息的最上面一行
                    //                    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
                    //                    //将table view滚动到最上面一行
                    //                    [self.messageTableView scrollToRowAtIndexPath:topIndexPath
                    //                                      atScrollPosition:UITableViewScrollPositionMiddle
                    //                                              animated:YES];
                    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
                    [self.messageTableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        }
    }
    
}
- (void)createConnectionToServer {
    //终端：telnet IP 1025 ----> 建立了一个和服务器之间的通道
    //The NSStream class does not support connecting to a remote host on iOS
    //这里建立和服务器之间的连接智能使用CFStream的两个子类
    //  1. 准备输入/输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    // 2. 与服务器建立 Socket 连接
    //参数一：The allocator to use to allocate memory for the CFReadStream and CFWriteStream objects. Pass NULL or kCFAllocatorDefault to use the current default allocator.
    //参数二：The hostname to which the socket streams should connect.
    //参数三：The TCP port number to which the socket streams should connect.
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 1025, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)(readStream);
    self.outputStream = (__bridge NSOutputStream *)(writeStream);
    // 3. 设置代理，用于接收服务器发送的消息
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    // 4. 将输入/输出流注册到RunLoop中
    //把NSInputStream对象配置到一个run loop，并且有与流相关的事件(例如流中有可读数据)发生时，该对象会收到stream:handleEvent:消息
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //  5. 打开输入/输出流
    [self.inputStream open];
    [self.outputStream open];
    
}
- (IBAction)GoBackToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

