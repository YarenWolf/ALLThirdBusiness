//
//  DataPersistenceViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "DataPersistenceViewController.h"
#import "Student.h"
#import "UIView+Extension.h"
@interface DataPersistenceViewController ()
//plist文件路径
@property(nonatomic,strong)NSString *plistPath;
//归档路径
@property(nonatomic,strong)NSString *archivingFilePath;
@end

@implementation DataPersistenceViewController
-(NSString*)archivingFilePath{
    if(!_archivingFilePath){
        NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _archivingFilePath=[documentPath stringByAppendingPathComponent:@"archivingFile"];
    }
    return _archivingFilePath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
//写入文件
- (IBAction)writeDataToFile:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"logIn"];
    [defaults setInteger:24 forKey:@"count"];
    NSArray *array=@[@"Maggie",@"Jonny"];
    [defaults setObject:array forKey:@"name"];
    //强制把设置的值写入文件中
    [defaults synchronize];
}
//获取数据
- (IBAction)getDataFromFile:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL log=[defaults boolForKey:@"logIn"];
    NSInteger count=[defaults integerForKey:@"count"];
    NSArray *myName=[defaults objectForKey:@"name"];
    NSLog(@"bool:%d\tInteger:%ld\nNSObject:%@",log,count,myName);
}
//写入和读取plist数据
- (IBAction)writeAndReadFromPlist:(id)sender {
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    self.plistPath=[documentPath stringByAppendingPathComponent:@"test.plist"];
    NSDictionary *dic=@{@"name":@"Jonny",@"skills":@[@"fly",@"job",@"Ruby",@"Python"]};
    [dic writeToFile:self.plistPath atomically:YES];
    //从指定路径读取plist文件中的数据
    NSDictionary *readDic=[[NSDictionary alloc]initWithContentsOfFile:self.plistPath];
    NSLog(@"读取的数据：%@",readDic);
}
//Xcode创建plist文件，添加数据，读出来。
- (IBAction)createPlistAndReadData:(id)sender {
    //获取test.plist文件路径
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"test" ofType:@"plist"];
    NSArray *dataArray=[[NSArray alloc]initWithContentsOfFile:plistPath];
    for(NSDictionary *dic in dataArray){
        NSLog(@"dic:%@",dic);
    }
    NSLog(@"%@",[dataArray[0] valueForKey:@"name"]);
}
//使用归档的方式把数组中的数据存到指定的文件。(写入的过程）
- (IBAction)writeDataByArchiving:(id)sender {
    //数据源
    NSArray *array=@[@"Jonny",@18,@[@"Swift",@"Java",@"C"]];
    //1.创建可变数据类型
    NSMutableData *mutableData=[NSMutableData data];
    //2.创建归档对象
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:mutableData];
    //3.对存入的数据进行二进制编码
    [archiver encodeObject:array forKey:@"array"];
    //4.执行完成编码操作
    [archiver finishEncoding];
    //5.将编码完的对象写入文件中。
    [mutableData writeToFile:self.archivingFilePath atomically:YES];
    NSLog(@"编码后的文件长度：%ld",mutableData.length);
}
//使用解档的方式读取数据
- (IBAction)readDataByUnarchiving:(id)sender {
    //1.从文件中读取数据
    NSData *readData=[NSData dataWithContentsOfFile:self.archivingFilePath];
    //2.创建解码对象
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:readData];
    //3.进行解码
    NSArray *array=[unarchiver decodeObjectForKey:@"array"];
    //4.执行完成解码
    [unarchiver finishDecoding];
    NSLog(@"解档之后的数据：%@",array);
    
}
#pragma mark 自定义归档解档
- (IBAction)CustomEncoding:(id)sender {
    NSLog(@"自定义归档:%s",__func__);//这句话写在方法里面会打印提示这个方法什么时候调用
    Student *firstStudent=[[Student alloc]initWithName:@"旺财" Age:18];
    Student *secondStudent=[[Student alloc]initWithName:@"阿黄" Age:22];
    //归档
    NSMutableData *data=[NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:firstStudent forKey:@"first"];
    [archiver encodeObject:secondStudent forKey:@"secend"];
    [archiver finishEncoding];
    [data writeToFile:self.archivingFilePath atomically:YES];
    //解档
    NSData *readData=[NSData dataWithContentsOfFile:self.archivingFilePath];
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:readData];
    Student *firstStudentFromFile=[unarchiver decodeObjectForKey:@"first"];
    Student *secondStudentFromFile=[unarchiver decodeObjectForKey:@"secend"];
    [unarchiver finishDecoding];
    NSLog(@"name:%@;%@;age:%ld,%ld",firstStudentFromFile.name,secondStudentFromFile.name,firstStudentFromFile.age,secondStudentFromFile.age);
}
@end



