//
//  ReadXMLDataViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/24.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "ReadXMLDataViewController.h"
#import "DHxlsReader.h"
#import "Coredata.h"
extern int xls_debug;
@interface ReadXMLDataViewController ()

@end

@implementation ReadXMLDataViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self ParseMyExcelToCoreData];
    [SVProgressHUD showSuccessWithStatus:@"数据写入成功"];
}
-(void)ParseMyExcelToCoreData{
    xls_debug = 10;
    
    //https://dl81.yunpan.360.cn/intf.php?method=Download.downloadFile&qid=2661772966&fname=%2FSalesBuilding.xlsm&fhash=65b4d27554361732de496f2ea9fcfa9226ba3dbd&dt=81_81.f634d3d8ad65a757e034df0b12ee6ec3&v=1.0.1&rtick=14768655015267&open_app_id=0&devtype=web&sign=7d3f5b3973559be45d416d3f9ed7a1aa&
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"person.xls"];// pathForResource:@"person" ofType:@"xls"];//
    DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:path];
    assert(reader);
    NSString *text = [NSString stringWithFormat:@"这是此Excel的属性信息:\nApp名称: %@\n作者: %@\n扩展: %@\n评论: %@\n公司: %@\n关键词: %@\n最终作者: %@\n经理: %@\n项目: %@\n标题: %@\n\n表格数目: %u\n",
                      reader.appName,reader.author,reader.category,reader.comment,reader.company,reader.keywords,reader.lastAuthor,reader.manager,reader.subject,reader.title,reader.numberOfSheets];
    DLog(@"%@",text);
    
    AppDelegate *dele = [AppDelegate Share];
    //    [reader startIterator:0];
    //    while(YES) {
    //        DHcell *cell = [reader nextCell];
    //        if(cell.type == cellBlank) break;
    //        text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
    //    }
    int row = 1;
    int col = 1;
    while(YES) {
        for(col=1;col<28;col++){
            DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:col];if(cell.type == cellBlank) break;
            Coredata *data =[NSEntityDescription insertNewObjectForEntityForName:@"Coredata" inManagedObjectContext:dele.managedObjectContext];
            switch (col) {
                case 1:data.name=cell.str;break;
                case 2:data.name=     cell.str;break;
                case 3:data.time=     cell.str;break;
                case 4:data.place=    cell.str;break;
                case 5:data.sex=      cell.str;break;
                case 6:data.phone=    cell.str;break;
                case 7:data.wechart=  cell.str;break;
                case 8:data.email=    cell.str;break;
                case 9:data.age=      cell.str;break;
                case 10:data.birthDay= cell.str;break;
                case 11:data.company=  cell.str;break;
                case 12:data.position= cell.str;break;
                case 13:data.unitAddress=cell.str;break;
                case 14:data.homeAddress=cell.str;break;
                case 15:data.character=cell.str;break;
                case 16:data.hobby=    cell.str;break;
                case 17:data.dream=    cell.str;break;
                case 18:data.economic= cell.str;break;
                case 19:data.firstVision=cell.str;break;
                case 20:data.need=     cell.str;break;
                case 21:data.secondVision=cell.str;break;
                case 22:data.suggest=  cell.str;break;
                case 23:data.deal=     cell.str;break;
                case 24:data.dealTime= cell.str;break;
                case 25:data.insuranceType=cell.str;break;
                case 26:data.policyNumber=cell.str;break;
                case 27:data.quota=    cell.str;break;
                case 28:data.annualPremium=cell.str;break;
                case 29:data.instructions=cell.str;break;
                case 30:data.others=   @"";
                default:break;
            }
            [[AppDelegate Share] saveContext];
        }
        row++;
        if(row>20||row==0)return;
    }
    
}

@end
