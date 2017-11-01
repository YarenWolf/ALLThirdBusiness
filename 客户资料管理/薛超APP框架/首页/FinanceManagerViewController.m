//
//  FinanceManagerViewController.m
//  薛超APP框架
#import "FinanceManagerViewController.h"
#import "Acount.h"
#import "Record.h"
@interface FinanceManagerViewController (){
    NSMutableArray *cells;
    NSArray *titles;
    NSMutableArray *accounts;
    NSArray *a;
}
@end
@implementation FinanceManagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    cells = [NSMutableArray arrayWithCapacity:10];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Acount"];
    a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:nil];
    if(!a.count){
        [SVProgressHUD showErrorWithStatus:@"请先添加银行卡"];return;
    }
    accounts = [NSMutableArray arrayWithCapacity:3];
    for(int i=0;i<a.count;i++){
        Acount *at = a[i];
        NSString *name = [NSString stringWithFormat:@"%@%@",at.yinhang,[at.account substringFromIndex:at.account.length-4]];
        [accounts addObject:name];
    }
    if([self.title isEqualToString:@"支出管理"]){
        titles = @[@"日期:",@"账户:",@"支出项目:",@"金额(元):",@"分类",@"说明"];
        for(int i=0;i<titles.count;i++){
            SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
            c.title = titles[i];
           if(i==1){
               c.cellArray = accounts;
           }else if(i==4){
               c.cellArray = @[@"交通",@"吃饭",@"衣服",@"电子",@"零食",@"房租",@"饰品",@"护理",@"人际",@"亲友",@"还款",@"其他",@"话费"];
           }else{
               c.isFill = YES;
           }
            [cells addObject:c];
        }

    }else if([self.title isEqualToString:@"收入管理"]){
        titles = @[@"日期:",@"账户:",@"收入项目:",@"金额(元):",@"分类",@"说明"];
        for(int i=0;i<titles.count;i++){
            SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
            c.title = titles[i];
            if(i==1){
                c.cellArray = accounts;
            }else if(i==4){
                c.cellArray = @[@"工资",@"奖金",@"转账",@"红包",@"现金"];
            }else{
                c.isFill = YES;
            }
            [cells addObject:c];
        }
    }else if([self.title isEqualToString:@"未来规划"]){
        titles = @[@"日期:",@"规划项目:",@"金额(元):",@"说明"];
        for(int i=0;i<titles.count;i++){
            SBaseCell *c = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
            c.title = titles[i];
            c.isFill = YES;
            [cells addObject:c];
        }
    }
    SBaseCell *c= cells[0];
    c.subtitle = dateString;
    [self.values setValue:dateString forKey:@"00"];
    c.isFill = YES;
    group1.items = cells;
    [self.groups addObject:group1];
    self.tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 50)];
    UIButton *next = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, APPW-50, 40)];
    [next setTitle:@"提   交" forState:UIControlStateNormal];
    next.layer.cornerRadius = 20;next.tag = 1;
    next.backgroundColor = redcolor;
    [next addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:next];
    [self fillTheTableDataWithHeadV:nil footV:self.tableFootView canMove:NO canEdit:NO headH:0 footH:0 rowH:44 sectionN:1 rowN:titles.count cellName:@"SBaseCell"];
//    self.tableView.frame = CGRectMake(0, 30, APPW, APPH-30);
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, -20, APPW, APPH+20);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, -20, APPW, APPH+20);
        [self.tableView reloadData];
    }
}
-(void)submit{
    if(![[self.values valueForKey:@"00"]notEmptyOrNull]||![[self.values valueForKey:@"01"]notEmptyOrNull]||![[self.values valueForKey:@"02"]notEmptyOrNull]){
        [SVProgressHUD showErrorWithStatus:@"请把信息填写完整"];return;
    }
    Acount *act;
    for(int i=0;i<accounts.count;i++){
        if([accounts[i]isEqualToString:self.values[@"01"]]){
            act = a[i];
        }
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSDate *dt = [[NSDate alloc] init];
    dt = [df dateFromString:self.values[@"00"]];
    AppDelegate *dele =[AppDelegate Share];
    Record *record =[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:dele.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Acount"];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Acount" inManagedObjectContext:dele.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account = %@",act.account];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    NSArray *acounts = [dele.managedObjectContext executeFetchRequest:request error:nil];
    Acount * account = [accounts lastObject];
    if([self.title isEqualToString:@"支出管理"]){
        record.type = @"支出";
        record.date=dt;
        record.yinhang=act.yinhang;
        record.account = act.account;
        record.inputItem = @"";
        record.outputItem = self.values[@"02"];
        record.expectItem = @"";
        record.money = [self.values[@"03"]doubleValue];
        record.classItem = self.values[@"04"];
        record.descript = self.values[@"05"];
        
        act.yue -= record.money;//更新账户余额
    }else if([self.title isEqualToString:@"收入管理"]){
        record.type = @"收入";
        record.date=dt;
        record.yinhang=act.yinhang;
        record.account = act.account;
        record.inputItem = self.values[@"02"];
        record.outputItem =@"";
        record.expectItem = @"";
        record.money = [self.values[@"03"]doubleValue];
        record.classItem = self.values[@"04"];
        record.descript = self.values[@"05"];
        act.yue += record.money;
    }else if([self.title isEqualToString:@"未来规划"]){
        record.type = @"预算";
        record.date=dt;
        record.yinhang=@"";
        record.account = @"";
        record.inputItem = @"";
        record.outputItem =@"";
        record.expectItem = self.values[@"01"];
        record.money = [self.values[@"02"]doubleValue];
        record.classItem = @"";
        record.descript = self.values[@"03"];
    }
   if([act.type isEqualToString:@"信用卡"]){
        act.arrears += record.money;
        act.least = act.arrears/10.0;
    }
    NSError *Error = nil;
    if ([dele.managedObjectContext save:&Error]) {
    }else {
        [SVProgressHUD showErrorWithStatus:@"更新失败"];return;
    }
    [[AppDelegate Share] saveContext];
    [SVProgressHUD showSuccessWithStatus:@"恭喜提交成功!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
@end

