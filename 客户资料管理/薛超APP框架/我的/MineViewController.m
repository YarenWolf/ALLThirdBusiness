//
//  MineViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
#import "MineViewController.h"
#import "UIButton+WebCache.h"
#import "AlertView.h"
#include "LibXL/libxl.h"
#import "Coredata.h"
#import "AlertView.h"
#import <MessageUI/MessageUI.h>
#import "Customdata.h"
#import "DHxlsReader.h"
#import "Record.h"
extern int xls_debug;
@interface MineViewController()<UIWebViewDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>{
    UIWebView *webV;
    NSString *dataurl;
    NSArray *items;
    NSMutableArray *cells;
    NSArray *attributes;
    NSArray *titles;
    NSMutableArray *customicons;
    
    NSArray *rattributes;
    NSArray *rtitles;
}
@property(nonatomic,strong)NSString *filepath;
@end
@implementation MineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    // 1.创建组
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    cells = [NSMutableArray arrayWithCapacity:10];
    items = [NSArray arrayWithObjects:@"验证码:",@"账号:",@"密码:",@"登录状态:",@"下载地址:",@"清空内存",@"清空客户名单",@"导出客户名单到邮箱",@"从网络下载数据",@"导出账单到邮箱",nil];
    for(int i=0;i<items.count;i++){
        SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
        c.title = items[i];
        if(i==0){
            c.isFill = YES;c.subtitle = @"5292";[self.values setValue:c.subtitle forKey:@"00"];
        }else if(i==1){
            c.isFill = YES;c.subtitle = @"498492";[self.values setValue:c.subtitle forKey:@"01"];
        }else if(i==2){
            c.isFill = YES;c.subtitle = @"y62100ff";[self.values setValue:c.subtitle forKey:@"02"];
        }else if(i==3){
            UISwitch *s = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];c.rightSwitch = s;
            [s addTarget:self action:@selector(zaixian:) forControlEvents:UIControlEventValueChanged];
            [self.values setValue:(s.isOn?@"1":@"0") forKey:@"03"];
        }else if(i==4){
            c.isFill = YES;c.subtitle = @"www.baidu.com";
        }else if(i==5){
            c.operation = ^{
                [self clearMembers];
            };
        }else if(i==6){
            c.operation = ^{
                [self clearnData];
            };
        }else if(i==7){
            c.operation = ^{
                [self readDataToExcel];
            };
        }else if(i==8){
            c.operation = ^{
                [self readXLSDataFromWeb];
            };
        }else{
            c.operation = ^{
                [self exportZhangdanToEmail];
            };
        }
        [cells addObject:c];
    }
    group1.items =cells;
    [self.groups addObject:group1];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 100)];
    UIButton *yzm = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, APPW-40, 90)];
    NSURL *url = [NSURL URLWithString:@"https://aes.aia.com.cn/isp/jcaptcha.jpg"];
    UIImage *i = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [yzm addTarget:self action:@selector(refreshyzm:) forControlEvents:UIControlEventTouchUpInside];
    [yzm setBackgroundImage:i forState:UIControlStateNormal];
    [view addSubview:yzm];
    [self fillTheTableDataWithHeadV:view footV:nil canMove:NO canEdit:YES headH:0 footH:0 rowH:44 sectionN:1 rowN:cells.count cellName:@"SBaseCell"];
    self.tableView.frame = CGRectMake(0, 64, APPW, APPH-100);
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
        [self.tableView reloadData];
    }
}
-(void)zaixian:(UISwitch*)sender{
    [self.values setValue:(sender.isOn?@"1":@"0") forKey:@"03"];
    if(sender.isOn){
        [self loginWithCaptcha:nil];
    }else{
        
    }
}
-(void)refreshyzm:(UIButton*)sender{
    NSURL *url = [NSURL URLWithString:@"https://aes.aia.com.cn/isp/jcaptcha.jpg"];
    UIImage *i = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [sender setBackgroundImage:i forState:UIControlStateNormal];
    SBaseCell *cell = cells[3];
    cell.rightSwitch.on = NO;
}
-(void)loginWithCaptcha:(NSString*)s{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    NSString *agentid = [NSString stringWithFormat:@"000%@",self.values[@"01"]];
    [parameters setObject:self.values[@"00"] forKey:@"captcha"];
    [parameters setObject:agentid forKey:@"username"];
    [parameters setObject:self.values[@"02"] forKey:@"password"];
    [parameters setObject:@"0986" forKey:@"companyId"];
    NSString *ss =@"https://aes.aia.com.cn/isp/login.sec";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager POST:ss parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"\n\n\n%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *d = [NSDictionary dictionaryWithDictionary:error.userInfo];
        NSDictionary *sd = [[d valueForJSONKey:@"NSUnderlyingError"]userInfo];
        NSURL *a = [sd valueForJSONKey:@"NSErrorFailingURLKey"];
        SBaseCell *cell = cells[3];
        if(!a.absoluteString){//登陆成功
            cell.rightSwitch.on = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.values[@"01"] forKey:@"agentId"];
            [defaults synchronize];
            [[Utility Share]setUserId:agentid];
        }else{
            cell.rightSwitch.on = NO;
        }
    }];
}
#pragma mark 清空内存
-(void)clearMembers{
    AlertView *alert =[[AlertView alloc]initWithTitle:@"提示" message:@"如果清空了内存，则所有网络缓存数据将从手机中删除。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //消除用户手势
            [defaults removeObjectForKey:[[Utility Share]userId]];
            [SVProgressHUD showSuccessWithStatus:@"网络缓存清除成功"];
        }
    }];
}
-(void)clearnData{
    AlertView *alert =[[AlertView alloc]initWithTitle:@"提示" message:@"如果清空了数据，则所有客户资料将从手机中删除，建议导出之后再清空。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coredata"];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO],
                                        [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
            NSError *error = nil;
            NSArray *a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:&error];
            [self.items removeAllObjects];
            for (Coredata *postcode in a) {
                [[AppDelegate Share].managedObjectContext deleteObject:postcode];
            }
            [[AppDelegate Share] saveContext];
            [SVProgressHUD showSuccessWithStatus:@"数据清除成功"];
        }
    }];
    
}
-(void)readDataToExcel{
    [self readData];
    customicons = [NSMutableArray arrayWithCapacity:10];
    attributes = @[@"name",@"time",@"place",@"sex",@"phone",@"wechart",@"email",@"age",@"birthDay",
                   @"company",@"position",@"unitAddress",@"homeAddress",@"character",@"hobby",@"dream",
                   @"economic",@"firstVision",@"need",@"secondVision",
                   @"suggest",@"deal",@"dealTime",@"insuranceType",@"policyNumber",@"quota",@"annualPremium",@"instructions",@"others"];
    titles = @[@"姓名",@"认识时间:",@"认识地点:",@"性别:",@"手机:",@"微信号",@"邮箱",@"年龄:",@"生日",
               @"公司",@"职位:",@"单位地址:",@"家庭地址:",@"性格特点:",@"爱好",@"梦想",
               @"经济状况",@"初次预约:",@"需求分析:",@"二次预约:",@"制作建议书:",
               @"成交面谈",@"成交时间:",@"险种:",@"保单件数:",@"保额(万):",@"年化保费",@"其他说明"];
    self.filepath = [documentPath stringByAppendingPathComponent:@"data.xls"];
    [self performSelectorInBackground: @selector(exportImpl) withObject: nil];
}
#pragma mark 第一种方法
- (void) exportImpl{
    [self saveExcelWithFileName:@"data.xls"];
    if ([MFMailComposeViewController canSendMail]) {
        NSLog(@"发送邮件");
        MFMailComposeViewController *mailCon = [MFMailComposeViewController new];
        [mailCon setMailComposeDelegate:self];
        [mailCon setSubject:[NSString stringWithFormat: @"客户资料%@发自%@", [self.filepath lastPathComponent], [[UIDevice currentDevice] model]]];
        [mailCon setToRecipients:@[@"2829969299@qq.com"]];
        [mailCon setMessageBody:@"这是我的客户资料库<font color=\"blue\"> 资料内容 </font>请审阅" isHTML:YES];
        // 附件
        for(int i=0;i<customicons.count;i++){
            [mailCon addAttachmentData:customicons[i] mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%d",i]];
        }
        NSData *database = [NSData dataWithContentsOfFile:self.filepath];
        [mailCon addAttachmentData: database mimeType:@"application/octet-stream" fileName: [self.filepath lastPathComponent]];
        [self presentViewController:mailCon animated:YES completion:nil];
    }else{
        NSLog(@"不能发邮件");
    }
}

#pragma mark 主题
-(void)saveExcelWithFileName:(NSString*)fileName{
    BookHandle book = xlCreateBook(); // use xlCreateXMLBook() for working with xlsx files
    SheetHandle sheet = xlBookAddSheet(book, "客户资料", NULL);
    //第一个参数代表插入哪个表，第二个是第几行（默认从0开始），第三个是第几列（默认从0开始）
    xlSheetWriteNum(sheet, 0, 0, 2000, 0);
    for (int m = 0; m<titles.count;m++){
        const char *name_a = [titles[m]  cStringUsingEncoding:NSUTF8StringEncoding];
        xlSheetWriteStr(sheet, 1, m, name_a, 0);
    }
    for (int i = 0; i < self.items.count; i++) {
        Coredata *person = self.items[i];
        for(int j=0;j<attributes.count;j++){
            NSString *s = [[person valueForKey:attributes[j]]notEmptyOrNull]?[person valueForKey:attributes[j]]:@"";
            const char *name_c = [s  cStringUsingEncoding:NSUTF8StringEncoding];
            xlSheetWriteStr(sheet, i+2, j,name_c, 0);
            
            
        }
        UIImage *icon = [NSKeyedUnarchiver unarchiveObjectWithData:person.icon];
        NSData *imageData = UIImagePNGRepresentation(icon);
        [customicons addObject:imageData];
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
    if(result==MFMailComposeResultSent)[SVProgressHUD showSuccessWithStatus:@"发送成功"];
    if(result==MFMailComposeResultFailed)[SVProgressHUD showErrorWithStatus:@"发送失败"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 从网络下载数据解析
-(void)readXLSDataFromWeb{
    if(![self.values[@"04"]notEmptyOrNull]){
        [SVProgressHUD showErrorWithStatus:@"请先填写网络地址，谢谢！"];
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.values[@"04"]]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *downloadURL = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //此处进入主线程了
        xls_debug = 10;
        DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:filePath.path];
        assert(reader);
        AppDelegate *dele = [AppDelegate Share];
        int row = 1;
        int col = 1;
        while(YES) {
            Coredata *data =[NSEntityDescription insertNewObjectForEntityForName:@"Coredata" inManagedObjectContext:dele.managedObjectContext];
            for(col=1;col<31;col++){
                DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:col];
//                if(cell.type == cellBlank) break;
//                if(!cell.str)break;
                switch (col) {
                    case 1:{
                        data.name=     cell.str;
                        if(cell.type == cellBlank){
                            data.icon = [NSKeyedArchiver archivedDataWithRootObject:[UIImage imageNamed:@"userLogo"]];
                            [SVProgressHUD showSuccessWithStatus:@"数据写入成功"];
                            return ;
                        }
                    }break;
                    case 2:data.time=     cell.str;break;
                    case 3:data.place=    cell.str;break;
                    case 4:data.sex=      cell.str;break;
                    case 5:data.phone=    cell.str;break;
                    case 6:data.wechart=  cell.str;break;
                    case 7:data.email=    cell.str;break;
                    case 8:data.age=      cell.str;break;
                    case 9:data.birthDay= cell.str;break;
                    case 10:data.company=  cell.str;break;
                    case 11:data.position= cell.str;break;
                    case 12:data.unitAddress=cell.str;break;
                    case 13:data.homeAddress=cell.str;break;
                    case 14:data.character=cell.str;break;
                    case 15:data.hobby=    cell.str;break;
                    case 16:data.dream=    cell.str;break;
                    case 17:data.economic= cell.str;break;
                    case 18:data.firstVision=cell.str;break;
                    case 19:data.need=     cell.str;break;
                    case 20:data.secondVision=cell.str;break;
                    case 21:data.suggest=  cell.str;break;
                    case 22:data.deal=     cell.str;break;
                    case 23:data.dealTime= cell.str;break;
                    case 24:data.insuranceType=cell.str;break;
                    case 25:data.policyNumber=cell.str;break;
                    case 26:data.quota=    cell.str;break;
                    case 27:data.annualPremium=cell.str;break;
                    case 28:data.instructions=cell.str;break;
                    case 29:data.others=   @"";break;
                    case 30:data.icon = [NSKeyedArchiver archivedDataWithRootObject:[UIImage imageNamed:@"userLogo"]];break;
                    default:break;
                }
            }
            [[AppDelegate Share] saveContext];
            row++;
            if(row>100||row==0){
                [SVProgressHUD showSuccessWithStatus:@"数据写入成功"];
                return;
            }
        }
    }];
    [downloadTask resume];
}
#pragma mark 导出账单到邮箱
-(void)exportZhangdanToEmail{
    rattributes = @[@"type",@"date",@"yinhang",@"account",@"inputItem",@"outputItem",@"expectItem",@"money",@"classItem",@"descript"];
    rtitles = @[@"类型",@"日期",@"账户",@"账号",@"收入项目",@"支出项目",@"预算项目",@"金额",@"分类",@"描述"];
    self.filepath = [documentPath stringByAppendingPathComponent:@"recordData.xls"];
    [self performSelectorInBackground: @selector(exportzdtoemail) withObject: nil];
}
#pragma mark 第一种方法
- (void) exportzdtoemail{
    [self saveRecordExcelWithFileName:@"recordData.xls"];
    if ([MFMailComposeViewController canSendMail]) {
        NSLog(@"发送邮件");
        MFMailComposeViewController *mailCon = [MFMailComposeViewController new];
        [mailCon setMailComposeDelegate:self];
        [mailCon setSubject:[NSString stringWithFormat: @"客户资料%@发自%@", [self.filepath lastPathComponent], [[UIDevice currentDevice] model]]];
        [mailCon setToRecipients:@[@"2829969299@qq.com"]];
        [mailCon setMessageBody:@"这是我的客户资料库<font color=\"blue\"> 资料内容 </font>请审阅" isHTML:YES];
        NSData *database = [NSData dataWithContentsOfFile:self.filepath];
        [mailCon addAttachmentData: database mimeType:@"application/octet-stream" fileName: [self.filepath lastPathComponent]];
        [self presentViewController:mailCon animated:YES completion:nil];
    }else{
        NSLog(@"不能发邮件");
    }
}
-(void)saveRecordExcelWithFileName:(NSString*)fileName{
    BookHandle book = xlCreateBook(); // use xlCreateXMLBook() for working with xlsx files
    SheetHandle sheet = xlBookAddSheet(book, "客户资料", NULL);
    //第一个参数代表插入哪个表，第二个是第几行（默认从0开始），第三个是第几列（默认从0开始）
    xlSheetWriteNum(sheet, 0, 0, 2000, 0);
    for (int m = 0; m<rtitles.count;m++){
        const char *name_a = [rtitles[m]  cStringUsingEncoding:NSUTF8StringEncoding];
        xlSheetWriteStr(sheet, 1, m, name_a, 0);
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    NSArray *a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:nil];
    
    for (int i = 0; i < a.count; i++) {
        Record *record = a[i];
        for(int j=0;j<rattributes.count;j++){
            NSString *s = [[record valueForKey:rattributes[j]]notEmptyOrNull]?[record valueForKey:rattributes[j]]:@"";
            const char *name_c = [s  cStringUsingEncoding:NSUTF8StringEncoding];
            xlSheetWriteStr(sheet, i+2, j,name_c, 0);
        }
    }
    //字体
    FontHandle font = xlBookAddFont(book, 0);
    xlFontSetColor(font, COLOR_RED);
    xlFontSetBold(font, true);
    FormatHandle boldFormat = xlBookAddFormat(book, 0);
    xlFormatSetFont(boldFormat, font);
    xlSheetSetCol(sheet, 1, 1, 12, 0, 0);
    NSString *filename = [documentPath stringByAppendingPathComponent:fileName];
    NSLog(@"filepath:%@",filename);
    xlBookSave(book, [filename UTF8String]);
    xlBookRelease(book);
}


@end

