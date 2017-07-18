//
//  ThreadViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ThreadViewController.h"
#import "UIView+Extension.h"
#import <pthread.h>//操作pthread必须包含这个头文件
@interface ThreadViewController ()
@property(nonatomic,assign)int soldTicketCount;
@property(nonatomic,assign)int leftTicketCount;
@property(nonatomic,strong)NSLock *lock;
@property(nonatomic,assign)int temp;
@end

@implementation ThreadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark 线程锁的概念
- (IBAction)sellTicketByTwoWindows:(id)sender {
    //已经卖出多少张，还剩多少张
    self.soldTicketCount=0;
    self.temp=0;
    self.lock=[[NSLock alloc]init];
    self.leftTicketCount=3000;
    //模拟两个窗口同时卖票
    NSThread *firstThread=[[NSThread alloc]initWithTarget:self selector:@selector(sellTicket) object:nil];
    firstThread.name=@"窗口1";
    [firstThread start];
    NSThread *secondThread=[[NSThread alloc]initWithTarget:self selector:@selector(sellTicket) object:nil];
    secondThread.name=@"窗口2";
    [secondThread start];
}
-(void)sellTicket{
    [self.lock lock];
    while(self.leftTicketCount>0){self.temp++;
    self.soldTicketCount++;self.leftTicketCount--;
    NSLog(@"卖了：%d\t剩了：%d\t%@",self.soldTicketCount,self.leftTicketCount,[NSThread currentThread]);
    }NSLog(@"卖完了%d",self.temp);
    [self.lock unlock];
}
#pragma mark 使用子线程下载图片
- (IBAction)downloadImageView:(id)sender {
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(downloadTask) object:nil];
    [thread start];
}
-(void)downloadTask{
    NSLog(@"%@",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3];//中场休息
    //NSString->NSURL->NSData(已经下载好的图片数据)->image->imageView;
    NSString *imageStr=@"http://a.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3ce4b2ec2dd9645d688d53f2075.jpg";
    //远程某台服务器上下载
    NSURL *imageURL=[NSURL URLWithString:imageStr];
    NSThread *thead=[[NSThread alloc]initWithTarget:self selector:@selector(download:) object:imageURL];
    [thead start];
}
-(void)download:(NSURL*)imageURL{
    NSData *imageData=[NSData dataWithContentsOfURL:imageURL];
    UIImage *iamge=[UIImage imageWithData:imageData];
    //回到主线程方式一
    [self performSelectorOnMainThread:@selector(getImage:) withObject:iamge waitUntilDone:YES];
}
-(void)getImage:(UIImage *)image{
    NSLog(@"111%@",[NSThread currentThread]);
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 350, 200)];
    imageView.image=image; [self.view addSubview:imageView];
}
#pragma mark NSThread线程
- (IBAction)creatThreadByInit:(id)sender {
    NSLog(@"当前线程:%@",[NSThread currentThread]);//区分线程执行。
    //1.创建NSThread对象
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(downloadTask) object:nil];
    
    //设置名字
    thread.name=@"子线程";
    //读取栈的大小
    NSUInteger stackSize=thread.stackSize;
    NSLog(@"占用大小:%lu",(unsigned long)stackSize);
    //3.执行启动线程操作
    [thread start];
    //使用场景：创建子线程和启动子线程是分离的（可以自定义什么时候启动。）
}
- (IBAction)creatThreadByDetach:(id)sender {//Detach:分离，剥离
    [NSThread detachNewThreadSelector:@selector(downloadTask) toTarget:self withObject:nil];
    //使用场景：简单滴创建并自动执行。
}
- (IBAction)creatThreadByPerform:(id)sender {
    [self performSelectorInBackground:@selector(downloadTask) withObject:nil];
    //直接让系统自动创建一个后台线程（子线程）
}
#pragma mark pthread主线程与子线程
- (IBAction)clickMainThreadButton:(id)sender {
    //执行主线程
    for (NSInteger i=0; i<10; i++) {
        [NSThread sleepForTimeInterval:3];
        NSLog(@"当前执行次数%ld",i);
    }
}
- (IBAction)clickSubThreadButton:(id)sender {
    //1.创建pthread对象
    char *data="hello";
    pthread_t pthread;//null:使用默认进程给我分配的内存  task:函数名字    第四个参数：传给task的参数
    int threadError= pthread_create(&pthread, NULL, task, data);
    if (threadError) {
        NSLog(@"创建子线程失败");
    }
    //2.指定子线程执行逻辑
}
void *task(void *data){
    //1.验证传参
    printf("data is :%s",data);
    //2.耗时操作
    for (int i=0; i<20000; i++) {
        [NSThread sleepForTimeInterval:5];
    }return 0;
}
@end
