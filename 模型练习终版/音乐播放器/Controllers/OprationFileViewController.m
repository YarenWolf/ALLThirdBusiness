//
//  OprationFileViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "OprationFileViewController.h"
#import "UIView+Extension.h"
//使用NSFileManger来创建文件夹/文件，拷贝，移动。移动，获取子文件夹/文件
@interface OprationFileViewController ()
//文件所在的路径
@property(nonatomic,strong)NSString *filePath;
//单例对象
@property(nonatomic,strong)NSFileManager *mgr;
@property(nonatomic,strong)NSString *documentPath;
@end

@implementation OprationFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //准备工作：源文件。/documents/source.txt
    self.mgr=[NSFileManager defaultManager];
    self.documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    //1.获取沙盒根目录
    NSString *homePath=NSHomeDirectory();
    NSLog(@"模拟器上根目录:%@",homePath);
    //2.获取Documents目录.参数一：指定要搜索的文件夹。参数二：指定用户的作用域，在哪里搜（固定）。参数三：是否需要返回的路径是绝对路径。
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSLog(@"doucumentPath:%@",documentPath);
    //3.获取library目录
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
    NSLog(@"libraryPath:%@",libraryPath);
    //4.获取temp目录
    NSString *tempPath=NSTemporaryDirectory();
    NSLog(@"temp目录：%@",tempPath);
    //5.获取bundle容器中图片
    NSString *bundlePath=[[NSBundle mainBundle]pathForResource:@"test" ofType:@"jpg"];
    UIImage *image=[UIImage imageWithContentsOfFile:bundlePath];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 300, 400, 200)];
    imageView.contentMode=UIViewContentModeScaleAspectFill|UIViewContentModeCenter;
    [self.view addSubview:imageView];
    imageView.image=image;
    [self PrintCacheData:[NSString stringWithFormat:@"bundlePath:%@",bundlePath]];

}
//写入字符串
- (IBAction)writeContentByNSString:(id)sender {
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    //拼接文件的绝对路径：XXX/documents/testStr.txt
    self.filePath=[documentPath stringByAppendingPathComponent:@"testStr.txt"];
    NSString *content=@"美女你好啊！约吗？❤️";
    NSError *error=nil;
    [content writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error){
        [self PrintCacheData:@"写入失败"];
    }else{[self PrintCacheData:@"写入成功"];}
}
//写入数组
- (IBAction)writeContentByNSArray:(id)sender {
    //testArray.txt
    //拼接文件绝对路径
    NSString *documentsPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *testPath=[documentsPath stringByAppendingPathComponent:@"testArray.plist"];
    NSArray *array=@[@"conetent",@18,@[@"Bob",@19]];
    [array writeToFile:testPath atomically:YES];
    if([array writeToFile:testPath atomically:YES]){
        [self PrintCacheData:@"写入数组数据成功"];
    }
    
}
//写入字典
- (IBAction)WriteDictionaryByString:(id)sender {
    NSString *testPath=[self.documentPath stringByAppendingPathComponent:@"testDictionary.plist"];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"aaa",@"bbb",@"ccc",@"ddd",@"1",@"2",@"3",@"4",nil];
    if([dic writeToFile:testPath atomically:YES])[self PrintCacheData:@"字典写入成功"];
}
//复制文件、文件夹
- (IBAction)CopyFile:(id)sender {
    //创建文件夹.需求：在documents/test/     需求二：在documents/test/test01.txt
    NSString *testDicPath=[self.documentPath stringByAppendingPathComponent:@"test"];
    /*参数一：指定文件夹的绝对路径.
     参数二：yes：允许重复创建已经存在的文件夹。NO：不允许重复文件夹。
     参数三：指定创建文件夹的属性（权限：所有者：……）;nil 默认权限。—rwx--r--r-  读写和执行。分三组，用二进制表示：744*/
    NSError *error=nil;
    if(![self.mgr createDirectoryAtPath:testDicPath withIntermediateDirectories:YES attributes:nil error:&error]){
        [self PrintCacheData:[NSString stringWithFormat:@"创建文件夹失败:%@",error.userInfo]];
    }else{
        [self PrintCacheData:@"创建文件夹成功"];
        //拼接test01.txt路径，创建并写入
        NSString *content=@"这是我的测试内容，有许多东西可以做，这些文件的处理，拷贝，赋值，等等内容都要做。这些都是我写的文字。";
        //转成data类型
        NSString *testFilePath=[testDicPath stringByAppendingPathComponent:@"test01.txt"];
        BOOL back=[self.mgr createFileAtPath:testFilePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if(back)[self PrintCacheData:@"创建文件并写入成功"];
    }
    //复制文件：需求：test/test01.txt->testCopy.txt
    NSString *sourceFilePath=[self.documentPath stringByAppendingPathComponent:@"test/test01.txt"];
    NSString *targetFilePath=[self.documentPath stringByAppendingPathComponent:@"test/testCopy.txt"];
    //创建目标文件（没有内容）：拷贝内容。
    if([self.mgr copyItemAtPath:sourceFilePath toPath:targetFilePath error:&error])[self PrintCacheData:@"拷贝成功"];
}
//移动文件，文件夹
- (IBAction)MoveFile:(id)sender {
    //删除文件：需求：删除test/test01.txt
    NSString *deleteFilePath=[self.documentPath stringByAppendingPathComponent:@"test/test01.txt"];
    NSError *error=nil;
    if (![self.mgr removeItemAtPath:deleteFilePath error:&error]) {
        [self PrintCacheData:@"删除失败"];
    }else{
       [self PrintCacheData:@"删除成功"];
    }
    
}
//获取文件的子文件或文件夹
- (IBAction)getFile:(id)sender {
    //需求：xxx/Documents/test/子文件和文件夹
    NSString *testDicPath=[self.documentPath stringByAppendingPathComponent:@"test"];
    //方式一
    NSError *error=nil;
    //返回的是文件的名字组成的数组。
    NSArray *subFileArray= [self.mgr subpathsOfDirectoryAtPath:testDicPath error:&error];
    for (NSString *subFileName in subFileArray) {
        [self PrintCacheData:[NSString stringWithFormat:@"文件名字：%@",subFileName]];
    }
    //方式二:迭代器
    NSDirectoryEnumerator *enumerator=[self.mgr enumeratorAtPath:testDicPath];
    //循环获取子文件
    NSString *boj;
    while (boj=[enumerator nextObject]) {
        NSLog(@"第二种方式文件名：%@",boj);
    }
   [self PrintCacheData:@"已经获取了子文件和文件夹"];
    
}
//拷贝小文件=======================
- (IBAction)copySmallFileByNSFileHandle:(id)sender {
    //创建空的目标文件
    NSString *targetPath=[self.documentPath stringByAppendingPathComponent:@"target.txt"];
    NSString *sourcePath=[self.documentPath stringByAppendingPathComponent:@"source.txt"];
    [self.mgr createFileAtPath:targetPath contents:nil attributes:nil];
    //[self.mgr createFileAtPath:sourcePath contents:nil attributes:nil];
    //创建两个NSFileHandle对象，并指示读或写的功能。
    NSFileHandle *readHandle=[NSFileHandle fileHandleForReadingAtPath:sourcePath];
    NSFileHandle *writeHandle=[NSFileHandle fileHandleForWritingAtPath:targetPath];
    //执行操作。
    NSData *readData=[readHandle readDataToEndOfFile];
    [writeHandle writeData:readData];
    [self PrintCacheData:@"小文件写入成功"];
    //    [readHandle readabilityHandler];
    //    [writeHandle writeabilityHandler];
    //收尾工作：关闭
    [readHandle closeFile];
    [writeHandle closeFile];
}
//拷贝大文件======================================
- (IBAction)copyBigFileByNSFileHandle:(id)sender {
    //准备工作：/Documents/BigFile.pdf
    NSString *targetPath=[self.documentPath stringByAppendingPathComponent:@"BigFile.jpg"];
    NSString *sourcePath=[self.documentPath stringByAppendingPathComponent:@"BigFileBak.jpg"];
    [self.mgr createFileAtPath:targetPath contents:nil attributes:nil];
    NSFileHandle *readHandle=[NSFileHandle fileHandleForReadingAtPath:sourcePath];
    NSFileHandle *writeHandle=[NSFileHandle fileHandleForWritingAtPath:targetPath];
    //每次读取源文件数据大小。
    NSInteger readSizePerTime=5000;//bytes
    BOOL isEnd=YES;
    //已经读取的数据的大小是多少
    NSInteger readSize=0;
    //读取源文件的总大小
    NSDictionary *sourceFileDic= [[NSFileManager defaultManager] attributesOfItemAtPath:sourcePath error:nil];
    NSNumber *totalSize= [sourceFileDic objectForKey:NSFileSize];
    [self PrintCacheData:[NSString stringWithFormat:@"%@",sourceFileDic]];
    while(isEnd){
        NSInteger leftSize= [totalSize floatValue]-readSize;
        //不足5000
        if(leftSize<readSizePerTime){
            NSData *leftData= [readHandle readDataToEndOfFile];
            [writeHandle writeData:leftData];isEnd=NO;
        }else{
            //正常每次读5000
            NSData *readData=[readHandle readDataOfLength:readSizePerTime];
            readSize+=readSizePerTime;
            [writeHandle writeData:readData];
        }
    }
    [self PrintCacheData:@"大文件复制成功"];
    [readHandle closeFile];[writeHandle closeFile];
}
@end
