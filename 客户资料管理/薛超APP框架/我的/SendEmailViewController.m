//
//  SendEmailViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/20.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "SendEmailViewController.h"
#include "LibXL/libxl.h"
#import <MessageUI/MessageUI.h>
@interface SendEmailViewController ()<MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong)NSMutableArray *persons;
@property(nonatomic,strong)NSString *filepath;
@end

@implementation SendEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filepath = [documentPath stringByAppendingPathComponent:@"data.xls"];
    NSArray *person1 = @[@"ningcol",@"张三",@"李四",@"王五"];
    NSArray *person2 = @[@"男",@"女",@"男",@"男"];
    NSArray *person3 = @[@"北京大学",@"清华大学",@"复旦大学",@"家里蹲大学"];
    NSArray *person4 = @[@"18345453452",@"13045453333",@"13845451112",@"180451111"];
    self.persons = [NSMutableArray arrayWithObjects:person1,person2,person3,person4,nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(120, 100, 80, 40);
    [btn setTitle:@"导出数据" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}



#pragma mark 第一种方法
- (IBAction)export:(id)sender{[self performSelectorInBackground: @selector(exportImpl) withObject: nil];}
- (void) exportImpl{
    [self saveExcelWithFileName:@"data.xls"];
    [self performSelectorOnMainThread: @selector(sendMail:) withObject:self.filepath waitUntilDone: NO];
}
- (void)sendMail:(NSString*)filePath{
    if ([MFMailComposeViewController canSendMail]) {
        NSLog(@"发送邮件");
        MFMailComposeViewController *mailCon = [MFMailComposeViewController new];
        [mailCon setMailComposeDelegate:self];
        [mailCon setSubject:[NSString stringWithFormat: @"这是我的客户资料%@ %@", [[UIDevice currentDevice] model], [filePath lastPathComponent]]];
        [mailCon setToRecipients:@[@"2829969299@qq.com"]];
        [mailCon setMessageBody:@"这是我的客户资料库<font color=\"blue\"> 资料内容 </font>请审阅" isHTML:YES];
        // 附件
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"1.jpg"]);
        [mailCon addAttachmentData:imageData mimeType:@"image/png" fileName:@"abc.png"];
        NSData *database = [NSData dataWithContentsOfFile:filePath];
        [mailCon addAttachmentData: database mimeType:@"application/octet-stream" fileName: [filePath lastPathComponent]];
        [self presentViewController:mailCon animated:YES completion:nil];
    }else{
        NSLog(@"不能发邮件");
    }
}

#pragma mark 第二种方法
//   设置bitcode为no,other linker flag也要改为-lstdc++并下载LibXL.framework拖进项目即可http://www.libxl.com/download.html
-(void)clickBtn{
    [self saveExcelWithFileName:@"data.xls"];
    // 分享出去
    UIDocumentInteractionController *docu = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filepath]];
    docu.delegate = self;
    CGRect rect = CGRectMake(0, 0, 320, 300);
    [docu presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    [docu presentPreviewAnimated:YES];
}
- ( UIViewController *)documentInteractionControllerViewControllerForPreview:( UIDocumentInteractionController *)interactionController{
    return self;
}
#pragma mark 主题
-(void)saveExcelWithFileName:(NSString*)fileName{
    BookHandle book = xlCreateBook(); // use xlCreateXMLBook() for working with xlsx files
    SheetHandle sheet = xlBookAddSheet(book, "Sheet1", NULL);
    //第一个参数代表插入哪个表，第二个是第几行（默认从0开始），第三个是第几列（默认从0开始）
    xlSheetWriteNum(sheet, 0, 0, 2000, 0);
    xlSheetWriteStr(sheet, 1, 0, "姓名", 0);xlSheetWriteStr(sheet, 1, 1, "性别", 0);xlSheetWriteStr(sheet, 1, 2, "学校", 0);xlSheetWriteStr(sheet, 1, 3, "电话", 0);
    for (int i = 0; i < self.persons.count; i++) {
        const char *name_c = [self.persons[i][0] cStringUsingEncoding:NSUTF8StringEncoding];
        xlSheetWriteStr(sheet, i+2, 0,name_c, 0);
        const char *sex_c = [self.persons[i][1] cStringUsingEncoding:NSUTF8StringEncoding];
        xlSheetWriteStr(sheet, i+2, 1,sex_c, 0);
        const char *school_c = [self.persons[i][2] cStringUsingEncoding:NSUTF8StringEncoding];
        xlSheetWriteStr(sheet, i+2, 2,school_c, 0);
        const char *phone_c = [self.persons[i][3] cStringUsingEncoding:NSUTF8StringEncoding];
        xlSheetWriteStr(sheet, i+2, 3,phone_c, 0);
    }
    //字体
    FontHandle font = xlBookAddFont(book, 0);
    xlFontSetColor(font, COLOR_RED);
    xlFontSetBold(font, true);
    FormatHandle boldFormat = xlBookAddFormat(book, 0);
    xlFormatSetFont(boldFormat, font);
    //写公式
    xlSheetWriteFormula(sheet, 0, 1, "SUM(B5:B6)", boldFormat);
    //写日期
    FormatHandle dateFormat = xlBookAddFormat(book, 0);
    xlFormatSetNumFormat(dateFormat, NUMFORMAT_DATE);
    xlSheetWriteNum(sheet, 0, 2, xlBookDatePack(book, 2016, 10, 20, 1, 7, 0, 5), dateFormat);
    xlSheetSetCol(sheet, 1, 1, 12, 0, 0);
    NSString *filename = [documentPath stringByAppendingPathComponent:fileName];
    NSLog(@"filepath:%@",filename);
    xlBookSave(book, [filename UTF8String]);
    xlBookRelease(book);
}
#pragma mark Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result==MFMailComposeResultSent)NSLog(@"发送成功");
    if(result==MFMailComposeResultFailed)NSLog(@"发送失败");
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(void) exportFile: (NSString*) filename{
//    self.tempFile = filename;
//    sqlite3* database;
//    if (sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK){
//        [self createTempFile: filename];
//        NSOutputStream* output = [[NSOutputStream alloc] initToFileAtPath: filename append: YES];
//        [output open];
//        if (![output hasSpaceAvailable]) {
//            NSLog(@"No space available in %@", filename);
//        } else {
//            NSString* header = @"Source,Time,Latitude,Longitude,Accuracy\n";
//            NSInteger result = [output write: [header UTF8String] maxLength: [header length]];
//            if (result <= 0) {NSLog(@"exportCsv encountered error=%d from header write", result);}
//            BOOL errorLogged = NO;
//            NSString* sqlStatement = @"select timestamp,latitude,longitude,horizontalAccuracy from my_sqlite_table";
//            sqlite3_stmt* compiledStatement;
//            if (sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
//                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
//                    NSInteger secondsSinceReferenceDate = (NSInteger)sqlite3_column_double(compiledStatement, 0);
//                    float lat = (float)sqlite3_column_double(compiledStatement, 1);
//                    float lon = (float)sqlite3_column_double(compiledStatement, 2);
//                    float accuracy = (float)sqlite3_column_double(compiledStatement, 3);
//                    if (lat != 0 && lon != 0) {
//                        NSDate* timestamp = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate: secondsSinceReferenceDate];
//                        NSString* line = [[NSString alloc] initWithFormat: @"%@,%@,%f,%f,%d\n",table, [dateFormatter stringFromDate: timestamp], lat, lon, (NSInteger)accuracy];
//                        result = [output write: [line UTF8String] maxLength: [line length]];
//                        if (!errorLogged && (result <= 0)) {
//                            NSLog(@"exportCsv write returned %d", result);errorLogged = YES;}
//                    }sqlite3_finalize(compiledStatement);
//                }
//            }
//        }
//        [output close];
//    }
//    sqlite3_close(database);
//}
//-(void)createTempFile:(NSString*)filename {
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:filename error: nil];
//    NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong: 0640], NSFilePosixPermissions,nil];
//    if (![fileManager createFileAtPath:filename contents:nil attributes:attributes]){NSLog(@"创建文件失败");}
//}
@end
