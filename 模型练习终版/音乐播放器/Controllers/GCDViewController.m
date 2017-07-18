//
//  GCDViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "GCDViewController.h"
#import "UIView+Extension.h"
@interface GCDViewController ()

@end

@implementation GCDViewController
-(void)viewDidLoad{
}
//只执行一次的任务的方法。
- (IBAction)dispatchOnceTask:(id)sender {
for (int i=0; i<10; i++) {
    NSLog(@"进入for循环%d",i);
    static dispatch_once_t onceToken;
    //2.调用一次性任务的方法
    dispatch_once(&onceToken, ^{
        NSLog(@"============");
    });
}
}
//使用GCD方式下载图片
- (IBAction)downloadImageWithGCD:(id)sender {
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:self.view.frame];
        //NSString->NSURL->NSData(已经下载好的图片数据)->image->imageView;
        NSString *imageStr=@"http://a.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3ce4b2ec2dd9645d688d53f2075.jpg";
        NSURL *imageURL=[NSURL URLWithString:imageStr];
        NSData *imageData=[NSData dataWithContentsOfURL:imageURL];
        UIImage *image=[UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[NSThread currentThread]);
            imageview.image=image;imageview.alpha=0;
            [self.view addSubview:imageview];
            [UIView animateWithDuration:3 animations:^{
                imageview.alpha=1;
            }];
            
        });
    });
}
//串行队列同步执行
- (IBAction)serialQueueSync:(id)sender {
    //1.创建空串行队列//参数1：指定队列的名字   参数2：队列类型
    dispatch_queue_t queque=dispatch_queue_create("FirstSerialQueue", DISPATCH_QUEUE_SERIAL);
    //2.创建任务到串行队列
    dispatch_sync(queque, ^{
        //任务逻辑
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%d",i);
        }
        
    }); NSLog(@"打印完毕");
    dispatch_sync(queque, ^{
        for(int i=0;i<5;i++){
            [NSThread sleepForTimeInterval:1];
            NSLog(@"-------");
        }
    });
    [NSThread sleepForTimeInterval:1];
    NSLog(@"打印——————————完毕");
    //3.同步执行
    
}
//串行队列异步执行
- (IBAction)serialQueueAsync:(id)sender {
    dispatch_queue_t queue=dispatch_queue_create("SecondSerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"++++++++");
        }
    });
    [NSThread sleepForTimeInterval:3];
    NSLog(@"打印+++++++完毕");
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"-------------");
        }
    });
    [NSThread sleepForTimeInterval:1];
    NSLog(@"打印————————完毕");
}
//并行队列同步执行
- (IBAction)concurrentQueSync:(id)sender {
    dispatch_queue_t queue=dispatch_queue_create("FirstConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for(int i=0;i<5;i++){
            [NSThread sleepForTimeInterval:1];
            NSLog(@"并行队列同步");
        }
    });NSLog(@"同步完成");
    dispatch_sync(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"并行队列2");
        }
    });NSLog(@"好了");
}
//并行队列异步执行
- (IBAction)concurrentQueueAsync:(id)sender {
    dispatch_queue_t queue=dispatch_queue_create("SecondConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"异步执行");
        }
    });NSLog(@"异步好了");
    dispatch_async(queue, ^{
        
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"正在异步");
        }
    });NSLog(@"一步完成");
}
//全局队列异步执行
- (IBAction)GlobalQueueAsync:(id)sender {
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@",[NSThread currentThread]);
        }
    });[NSThread sleepForTimeInterval:4];NSLog(@"全局队列同步执行完毕");
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@",[NSThread currentThread]);
        }
    });[NSThread sleepForTimeInterval:2];NSLog(@"全局队列好了");
    NSLog(@"%@",[NSThread currentThread]);
}
//主队列同步执行
- (IBAction)MainQueueSync:(id)sender {
    NSLog(@"主线程%@",[NSThread currentThread]);
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"first%@",[NSThread currentThread]);
        }
    });NSLog(@"主队列同步执行完毕");
    dispatch_sync(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@",[NSThread currentThread]);
        }
    });NSLog(@"主队列好了");
}
//主队列异步执行
- (IBAction)MainQueueAsync:(id)sender {
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"first%@",[NSThread currentThread]);
        }
    });
    [NSThread sleepForTimeInterval:3];
    NSLog(@"完成");
    dispatch_async(queue, ^{
        for (int i=0; i<5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@",[NSThread currentThread]);
        }
    });  [NSThread sleepForTimeInterval:3];NSLog(@"主队列异步执行完毕");
}
//=====================================组下载/创建队列
- (IBAction)groupTask:(id)sender {
dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
//创建组
dispatch_group_t group=dispatch_group_create();
//创建任务放到指定的队列和组中
dispatch_group_async(group, queue, ^{
    NSLog(@"开始下载图片1");
    [NSThread sleepForTimeInterval:3];
});
dispatch_group_async(group, queue, ^{
    NSLog(@"开始下载图片2");
    [NSThread sleepForTimeInterval:5];
});
dispatch_group_async(group, queue, ^{
    NSLog(@"开始下载图片3");
    [NSThread sleepForTimeInterval:2];
});
//通知组中的所有任务执行完毕（合成）
dispatch_group_notify(group, queue, ^{
    //回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"回到主线程%@",[NSThread currentThread]);
    });
});
}
#pragma mark NSoperation
- (IBAction)aboutNSOperation:(id)sender {
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadTask) object:nil];
    NSInvocationOperation *otherOperation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadTask1) object:nil];
    //子线程执行（创建非主队列）
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    //添加的一瞬间立即执行operation对象中的select方法。
    [queue addOperation:operation];
    [queue addOperation:otherOperation];
}
-(void)downloadTask{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"第一个任务%@",[NSThread currentThread]);
}
-(void)downloadTask1{[NSThread sleepForTimeInterval:2];
    NSLog(@"第二个任务%@",[NSThread currentThread]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NSOperation同步异步
- (IBAction)creataSyncOperation:(id)sender {
    //创建方式一
    NSBlockOperation *operation=[[NSBlockOperation alloc]init];
    [operation addExecutionBlock:^{
        //任务：
        NSLog(@"下载图片%@",[NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"下载图片二%@",[NSThread currentThread]);
    }];
    [operation start];
}
- (IBAction)createAsyncOperation:(id)sender {
    //创建方式二（创建对象和添加任务二合一）
    NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载中%@",[NSThread currentThread]);
    }];
    NSBlockOperation *otherOperation=[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载二%@",[NSThread currentThread]);
    }];
    //第二步创建非主队列
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    [queue addOperation:otherOperation];
}
#pragma mark NSOperation相关设置，依赖关系，最大并发数
- (IBAction)preferranceNsoperation:(id)sender {
NSOperationQueue *queue=[[NSOperationQueue alloc]init];
NSBlockOperation *operation1=[NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"1:%@",[NSThread currentThread]);
}];
NSBlockOperation *operation2=[NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"2:%@",[NSThread currentThread]);
}];
NSBlockOperation *operation3=[NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:5];
    NSLog(@"3:%@",[NSThread currentThread]);
}];
NSBlockOperation *operation4=[NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"4:%@",[NSThread currentThread]);
}];
NSBlockOperation *operation5=[NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"5:%@",[NSThread currentThread]);
}];
queue.maxConcurrentOperationCount=3;//设置最大并发数
//设置依赖关系.1要在2和3之后执行
[operation1 addDependency:operation2];
[operation1 addDependency:operation3];
[queue addOperations:@[operation1,operation2,operation3,operation4,operation5] waitUntilFinished:YES];
}
#pragma mark NSOperation回到主线程
- (IBAction)returnMainThread:(id)sender {
    NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"这是回到主线程的方法%@",[NSThread currentThread]);
        //回到主线程：
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSLog(@"%@回到主线程了吗",[NSThread currentThread]);
        }];
    }];
    NSOperationQueue *queue=[NSOperationQueue new];
    [queue addOperation:operation];//添加的同时就自动执行。
}
@end
