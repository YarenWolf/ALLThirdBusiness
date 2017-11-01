#import "PresentationViewController.h"
#import "Record.h"
#import "JHChartHeader.h"
#import "Acount.h"
#import "UIColor+expanded.h"
#define ARC4RANDOM_MAX 0x100000000
@interface PChartCell:BaseTableViewCell
-(void)setDataWithTile:(NSString*)name chartView:(UIView*)view;
@end
@implementation PChartCell{
    UILabel *nameLabel;
    UIScrollView *scrollV;
}
-(void)initUI{
    nameLabel = [Utility labelWithFrame:CGRectMake(Boardseperad, 5, APPW-20, 20) font:fontTitle color:blacktextcolor text:@""];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, YH(nameLabel)+5, APPW, 250-YH(nameLabel)-10)];
    scrollV.contentOffset = CGPointMake(0, 0);
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 249, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubviews:nameLabel,scrollV,cellline,nil];
}
-(void)setDataWithTile:(NSString *)name chartView:(UIView *)view{
    nameLabel.text = name;
    [scrollV addSubview:view];
    scrollV.contentSize = view.frame.size;
}
-(NSArray *)observableKeypaths{return nil;}
@end
@interface PresentationViewController(){
    double costMoney;//总花费
    double incomeMoney;//总收入
    NSMutableArray *costArray;//花费数组
    NSMutableArray *incomeArray;//收入数组
    NSArray *costClass;//支出分类
    NSArray *incomeClass;//收入分类
    NSArray *titles;//图表标题
    NSArray *aconts;//账号数组
    NSMutableDictionary *costDictionary;//花费字典（不同的花费种类）
    NSMutableDictionary *incomeDictionary;//收入字典（不同的收入途径）
    NSMutableArray *chartViews;//所有图表的视图数组
    UILabel *totalCost;
    UILabel *detailCost;
    UITextField *fromDate;
    UITextField *toDate;
    NSMutableDictionary *daysRecords;//日支出记录字典
    NSMutableDictionary *monthRecords;//月支出记录字典
    NSMutableDictionary *monthInRecords;//月收入记录字典
    NSMutableDictionary *costAcontsRecords;//账号支出字典
    NSMutableDictionary *incomAcontsRecords;//账号收入字典
}
@end
@implementation PresentationViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self Initialization];
    [self consult];
    [self initUI];
    [self setAllDatas];
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
-(void)Initialization{
    costMoney = 0;
    incomeMoney = 0;
    costArray = [NSMutableArray arrayWithCapacity:10];
    incomeArray = [NSMutableArray arrayWithCapacity:10];
    chartViews = [NSMutableArray arrayWithCapacity:10];
    costDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    incomeDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    daysRecords = [NSMutableDictionary dictionaryWithCapacity:10];
    monthRecords = [NSMutableDictionary dictionaryWithCapacity:10];
    monthInRecords = [NSMutableDictionary dictionaryWithCapacity:10];
    costAcontsRecords = [NSMutableDictionary dictionaryWithCapacity:10];
    incomAcontsRecords = [NSMutableDictionary dictionaryWithCapacity:10];
    costClass = @[@"交通",@"吃饭",@"衣服",@"电子",@"零食",@"房租",@"饰品",@"护理",@"人际",@"亲友",@"还款",@"其他",@"话费"];
    incomeClass = @[@"工资",@"奖金",@"转账",@"红包",@"现金"];
    titles = @[@"总收入与总支出扇形图",@"支出分类扇形图",@"收入分类扇形图",@"支出变化曲线图-日",@"支出变化曲线图-月",@"收入变化曲线图-月",
               @"支出分类雷达图",@"支出分类柱状图",@"支出变化柱状图-日",@"支出变化柱状图-月",@"支出银行卡分类图",@"收入银行卡分类图",
               @"收入支出对比柱状图",@"收入支出变化对比曲线图-月"];
    for(int i=0;i<costClass.count;i++){
        NSNumber *number = [NSNumber numberWithDouble:0.0];
        [costDictionary setObject:number forKey:costClass[i]];
    }
    for(int i=0;i<incomeClass.count;i++){
        NSNumber *number = [NSNumber numberWithDouble:0.0];
        [incomeDictionary setObject:number forKey:incomeClass[i]];
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Acount"];
    aconts = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:nil];
}
-(void)consult{
    AppDelegate *dele =[AppDelegate Share];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    //支出统计
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"type = %@",@"支出"];
    [request setPredicate:p1];
    NSArray *records1 = [dele.managedObjectContext executeFetchRequest:request error:nil];
    for(Record *c in records1){
        costMoney += c.money;
        NSNumber *number = [costDictionary objectForJSONKey:c.classItem];
        number = [NSNumber numberWithDouble:[number doubleValue]+c.money];
        [costDictionary setObject:number forKey:c.classItem];
    }
    //收入统计
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"type = %@",@"收入"];
    [request setPredicate:p2];
    NSArray *records2 = [dele.managedObjectContext executeFetchRequest:request error:nil];
    for(Record *c in records2){
        incomeMoney += c.money;
        NSNumber *number = [incomeDictionary objectForJSONKey:c.classItem];
//        DLog(@"%@",c.classItem);
        number = [NSNumber numberWithDouble:[number doubleValue]+c.money];
        [incomeDictionary setObject:number forKey:c.classItem];
    }
}
-(void)newConsult{
    [costDictionary removeAllObjects];
    [incomeDictionary removeAllObjects];
    [daysRecords removeAllObjects];
    [monthRecords removeAllObjects];
    [monthInRecords removeAllObjects];
    [chartViews removeAllObjects];
    costMoney = 0.0;incomeMoney = 0.0;
    AppDelegate *dele =[AppDelegate Share];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    //支出统计
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyyMMdd"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDateFormatter *ydf = [[NSDateFormatter alloc]init];
    [ydf setDateFormat:@"yyyyMM"];
    NSDate *fdate = [[NSDate alloc]init];
    fdate = [df dateFromString:fromDate.text];
    NSDate *tdate = [[NSDate alloc]init];
    tdate = [df dateFromString:toDate.text];
    
    long fdatedata = [fdate timeIntervalSince1970],tdatedata = [tdate timeIntervalSince1970];
    long long dayTime = 24*60*60;
    while (fdatedata < tdatedata) {
        NSDate *tempdate = [[NSDate alloc]initWithTimeIntervalSince1970:fdatedata];
        [daysRecords setObject:[NSNumber numberWithDouble:0.0] forKey:tempdate];
        fdatedata += dayTime;
    }
    
    NSPredicate *p11 = [NSPredicate predicateWithFormat:@"type = %@",@"支出"];
    NSPredicate *p12 = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@",fdate,tdate];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p11,p12]];
    [request setPredicate:predicate];
    NSArray *records1 = [dele.managedObjectContext executeFetchRequest:request error:nil];
    for(Record *c in records1){
        costMoney += c.money;
        NSNumber *number = [costDictionary objectForJSONKey:c.classItem];
        number = [NSNumber numberWithDouble:[number doubleValue]+c.money];
        [costDictionary setObject:number forKey:c.classItem];
        NSNumber *recordN = [daysRecords objectForJSONKey:c.date];
        recordN = [NSNumber numberWithDouble:[recordN doubleValue]+c.money];
        [daysRecords setObject:recordN forKey:c.date];
        NSString *key = [ydf stringFromDate:c.date];
        NSNumber *recordNY = [monthRecords objectForJSONKey:key];
        recordNY = [NSNumber numberWithDouble:[recordNY doubleValue]+c.money];
        [monthRecords setObject:recordNY forKey:key];
        
        NSNumber *acn = [costAcontsRecords objectForJSONKey:c.account];
        acn = [NSNumber numberWithDouble:[acn doubleValue]+c.money];
        [costAcontsRecords setObject:acn forKey:c.account];
    }
    //收入统计
    NSPredicate *p21 = [NSPredicate predicateWithFormat:@"type = %@",@"收入"];
    NSPredicate *p22 = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@",fdate,tdate];
    NSPredicate *predicate2 = [NSCompoundPredicate andPredicateWithSubpredicates:@[p21,p22]];
    [request setPredicate:predicate2];
    NSArray *records2 = [dele.managedObjectContext executeFetchRequest:request error:nil];
    for(Record *c in records2){
        incomeMoney += c.money;
        NSNumber *number = [incomeDictionary objectForJSONKey:c.classItem];
        number = [NSNumber numberWithDouble:[number doubleValue]+c.money];
        [incomeDictionary setObject:number forKey:c.classItem];
//        DLog(@"%@",c.classItem);
        NSString *key = [ydf stringFromDate:c.date];
        NSNumber *recordNY = [monthInRecords objectForJSONKey:key];
        recordNY = [NSNumber numberWithDouble:[recordNY doubleValue]+c.money];
        [monthInRecords setObject:recordNY forKey:key];
        
        NSNumber *acn = [incomAcontsRecords objectForJSONKey:c.account];
        acn = [NSNumber numberWithDouble:[acn doubleValue]+c.money];
        [incomAcontsRecords setObject:acn forKey:c.account];
    }
    [self setAllDatas];
    [self.tableView reloadData];
}
-(void)initUI{
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"生成报告" style:UIBarButtonItemStylePlain target:self action:@selector(newConsult)];
    self.navigationItem.rightBarButtonItem = right;
    UIView *sumView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 500)];
    sumView.backgroundColor = gradcolor;
    fromDate = [Utility textFieldlWithFrame:CGRectMake(10, 10, APPW-20, 20) font:fontTitle color:blacktextcolor placeholder:@"起始日期20160101" text:@"20160101"];
    toDate = [Utility textFieldlWithFrame:CGRectMake(X(fromDate), YH(fromDate)+10, W(fromDate), H(fromDate)) font:fontTitle color:blacktextcolor placeholder:@"结束日期" text:@"20161010"];
    totalCost = [Utility labelWithFrame:CGRectMake(X(fromDate), YH(toDate)+20, W(fromDate), 50) font:fontTitle color:blacktextcolor text:@""];
    detailCost = [Utility labelWithFrame:CGRectMake(X(fromDate), YH(totalCost)+10, W(fromDate), H(sumView)-YH(totalCost)-20) font:fontTitle color:blacktextcolor text:@""];
    fromDate.backgroundColor = toDate.backgroundColor = totalCost.backgroundColor = detailCost.backgroundColor = [UIColor whiteColor];
    totalCost.numberOfLines = 0; detailCost.numberOfLines=0;
    [sumView addSubviews:fromDate,toDate,totalCost,detailCost,nil];
    self.tableView = [[BaseTableView alloc]init];
    self.tableView.editingStyle = UITableViewCellEditingStyleNone;
    self.tableView.dataArray = [NSMutableArray arrayWithArray:titles];
    self.tableView.frame = CGRectMake(0, 0, APPW, APPH-100);
    [self fillTheTableDataWithHeadV:sumView footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:250 sectionN:1 rowN:self.tableView.dataArray.count cellName:@"PChartCell"];
    [self.view addSubview:self.tableView];
}
-(void)setAllDatas{
    NSString *cost = [NSString stringWithFormat:@"总支出:%0.2lf  \n总收入:%0.2lf",costMoney,incomeMoney];
    NSMutableString *detailcost = [NSMutableString string];
    for(int i=0;i<costClass.count;i++){
        [detailcost appendFormat:@"%@:%@\n",costClass[i],costDictionary[costClass[i]]];
    }
    for(int i=0;i<incomeClass.count;i++){
        [detailcost appendFormat:@"%@:%@\n",incomeClass[i],incomeDictionary[incomeClass[i]]];
    }
    totalCost.text = cost;
    detailCost.text = detailcost;
#pragma mark 总收入与总支出扇形图
    NSArray *values = @[[NSNumber numberWithDouble:costMoney],[NSNumber numberWithDouble:incomeMoney]];
    NSArray *colors = @[[UIColor greenColor],[UIColor redColor]];
    NSArray *descriptions =@[@"总支出",@"总收入"];
    UIView *IOPieV = [self getPieChartWithFrame:CGRectMake(APPW/2-100, 0, 200, 200) values:values colors:colors descriptions:descriptions];
    [chartViews addObject:IOPieV];
#pragma mark 支出分类扇形图
    NSArray *values1 = [costDictionary allValues];
    NSArray *colors1 = @[gradcolor,yellowcolor,redcolor,gradtextcolor,RGBCOLOR(230, 222, 10),RGBCOLOR(111, 111, 123),RGBCOLOR(10, 100, 10),RGBCOLOR(100, 10, 10),RGBCOLOR(10, 10, 100),RGBCOLOR(10, 100, 100),RGBCOLOR(100, 100, 10),RGBCOLOR(100, 10, 100),RGBCOLOR(10, 180, 50)];
    NSArray *descriptions1 = costClass;
    UIView *costclassV = [self getPieChartWithFrame:CGRectMake(APPW/2-100, 0, 200, 200) values:values1 colors:colors1 descriptions:descriptions1];
    [chartViews addObject:costclassV];
#pragma mark 收入分类扇形图
    NSArray *values2 = [incomeDictionary allValues];
    NSArray *colors2 = @[gradtextcolor,yellowcolor,redcolor,gradtextcolor,[UIColor greenColor]];
    NSArray *descriptions2 = incomeClass;
    UIView *incomeclassV = [self getPieChartWithFrame:CGRectMake(APPW/2-100, 0, 200, 200) values:values2 colors:colors2 descriptions:descriptions2];
    [chartViews addObject:incomeclassV];
#pragma mark 支出变化曲线图-日
    NSDateFormatter *ydf = [[NSDateFormatter alloc]init];//格式化
    [ydf setDateFormat:@"MM/dd"];
    [ydf setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSMutableArray *allkes =[NSMutableArray arrayWithArray:[daysRecords allKeys]];
    [allkes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = obj1;NSDate *date2 = obj2;
        return [date1 compare:date2];
    }];
    NSMutableArray *xs = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<allkes.count;i++){
        NSDate *date = allkes[i];
        NSString *s = [ydf stringFromDate:date];
        NSNumber *n = [daysRecords objectForJSONKey:allkes[i]];
        [array1 addObject:n];
        [xs addObject:s];
    }
    NSArray *xlabelsr = xs;
    NSArray *ylabelsr = @[@"0元",@"50元",@"100元",@"150元",@"200元",@"250元"];
    UIView *dayCostLineV = [self getLineChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:xlabelsr yLabels:ylabelsr array1:array1 array2:nil];
    [chartViews addObject:dayCostLineV];
    
#pragma mark 支出变化曲线图-月
    
    [ydf setDateFormat:@"yyyy/MM"];
    NSMutableArray *allMkes = [NSMutableArray arrayWithArray:[monthRecords allKeys]];
    [allMkes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *array1y = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<allMkes.count;i++){
        NSNumber *n = [monthRecords objectForJSONKey:allMkes[i]];
        [array1y addObject:n];
    }
    NSArray *ylabelsy = @[@"0元",@"500元",@"1000元",@"1500元",@"2000元",@"2500元"];
    UIView *yueCostLineV = [self getLineChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:allMkes yLabels:ylabelsy array1:array1y array2:nil];
    [chartViews addObject:yueCostLineV];
    
#pragma mark 收入变化曲线图-月
    NSMutableArray *allMIkes = [NSMutableArray arrayWithArray:[monthInRecords allKeys]];
    [allMIkes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *array1Iy = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<allMIkes.count;i++){
        NSNumber *n = [monthInRecords objectForJSONKey:allMIkes[i]];
        [array1Iy addObject:n];
    }
    NSArray *yIlabelsy = @[@"0元",@"100元",@"2000元",@"3000元",@"4000元",@"5000元"];
    UIView *yueIncomeLineV = [self getLineChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:allMIkes yLabels:yIlabelsy array1:array1Iy array2:nil];
    [chartViews addObject:yueIncomeLineV];
#pragma mark 支出分类雷达图
    NSArray *valuesl1 = [costDictionary allValues];
    UIView *costClassLV = [self getRadarChartWithFrame:CGRectMake(APPW/2-100, 0, 200, 200) values:valuesl1 descriptions:costClass];
    [chartViews addObject:costClassLV];
#pragma mark 支出分类柱状图
    NSArray *costClassYlabels = @[@"0元",@"100元",@"2000元",@"3000元",@"4000元",@"5000元"];
    UIView *costClassZV = [self getBarChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:costClass yLabels:costClassYlabels yValues:valuesl1];
    [chartViews addObject:costClassZV];
#pragma mark 支出变化柱状图-日
//    DLog(@"%@,\n%@",xs,array1);
    if(xs.count>0){
        UIView *dayCostZV = [self getBarChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:xs yLabels:ylabelsr yValues:array1];
        [chartViews addObject:dayCostZV];
    }
#pragma mark 支出变化柱状图-月
    if(allMkes.count>0){
        UIView *yueCostZV = [self getBarChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:allMkes yLabels:ylabelsy yValues:array1y];
        [chartViews addObject:yueCostZV];
    }
#pragma mark 支出银行卡分类图
    NSArray *costAcontArray = [costAcontsRecords allValues];
    NSMutableArray *randomcolors = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *accontsnames = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<aconts.count;i++){
        [randomcolors addObject:[UIColor randomColor]];
        Acount *a = aconts[i];
        [accontsnames addObject:a.yinhang];
    }
    UIView *costAcontV = [self getPieChartWithFrame:CGRectMake(APPW/2-100, 0, 200, 200) values:costAcontArray colors:randomcolors descriptions:accontsnames];
    [chartViews addObject:costAcontV];
#pragma mark 收入银行卡分类图
    NSArray *incomeAcontArray = [incomAcontsRecords allValues];
    if(incomeAcontArray.count){
        UIView *incomeAcontV = [self getPieChartWithFrame:CGRectMake(APPW/2-100, 0, 200, 200) values:incomeAcontArray colors:randomcolors descriptions:accontsnames];
        [chartViews addObject:incomeAcontV];
    }
#pragma mark 收入支出对比柱状图-月
    if(array1y.count && array1Iy.count){
        UIView *IOZYV = [self getTwoColumnViewWithFrame:CGRectMake(0, 0, 2*APPW, 200) array1:array1y array2:array1Iy names:allMkes];
        [chartViews addObject:IOZYV];
    }
#pragma mark 收入支出变化对比曲线图-月
    UIView *IOLYV = [self getLineChartWithFrame:CGRectMake(0, 0, 2*APPW, 200) xLabels:allMkes yLabels:yIlabelsy array1:array1y array2:array1Iy];
    [chartViews addObject:IOLYV];
    
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    [chartViews addObject:[self getChartViewWithFrame:CGRectZero]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(UIView*)getChartViewWithFrame:(CGRect)frame{
    UILabel *la = [Utility labelWithFrame:CGRectMake(0, 20, 200, 200) font:fontTitle color:redcolor text:@"暂无数据"];
    return la;
}
#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [PChartCell getInstance];
    }
    [cell setDataWithTile:self.tableView.dataArray[indexPath.row] chartView:chartViews[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark 图表
///折线图
//xlabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]
//ylabels:@[ @"0 min", @"50 min", @"100 min",@"150 min",@"200 min",@"250 min",@"300 min",]
//array1: @[@60.1, @160.1, @126.4, @0.0, @186.2, @127.2, @176.2]
-(UIView*)getLineChartWithFrame:(CGRect)frame xLabels:(NSArray*)xlabels yLabels:(NSArray*)ylabels array1:(NSArray*)array1 array2:(NSArray*)array2{
    self.lineChart = [[PNLineChart alloc] initWithFrame:frame];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:xlabels];
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.yGridLinesColor = [UIColor clearColor];
    self.lineChart.showYGridLines = YES;
    self.lineChart.yFixedValueMax = 300.0;
    self.lineChart.yFixedValueMin = 0.0;
    [self.lineChart setYLabels:ylabels];
    // Line Chart #1
    NSArray * data01Array =array1;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = PNFreshGreen;
    data01.alpha = 0.3f;
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = PNRed;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart #2
    NSArray * data02Array = array2;
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"Beta";
    data02.color = PNTwitterColor;
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    self.lineChart.chartData = @[data01, data02];
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
    [self.lineChart addSubview:legend];
    return self.lineChart;
}
///柱状图
-(UIView*)getBarChartWithFrame:(CGRect)frame xLabels:(NSArray*)xlabels yLabels:(NSArray*)ylabels yValues:(NSArray*)values{
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    self.barChart = [[PNBarChart alloc] initWithFrame:frame];
    //self.barChart.showLabel = NO;
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    [self.barChart setXLabels:xlabels];
    //self.barChart.yLabels = @[@-10,@0,@10];
    [self.barChart setYValues:values];
    [self.barChart setYLabels:ylabels];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<values.count;i++){
        [colors addObject:PNGreen];
    }
    [self.barChart setStrokeColors:colors];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    [self.barChart strokeChart];
    self.barChart.delegate = self;
    return self.barChart;
}
///扇形图
-(UIView*)getPieChartWithFrame:(CGRect)frame values:(NSArray*)values colors:(NSArray*)colors descriptions:(NSArray*)descriptions{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<values.count;i++){
        [items addObject:[PNPieChartDataItem dataItemWithValue:[values[i]floatValue] color:colors[i] description:descriptions[i]]];
    }
    self.pieChart = [[PNPieChart alloc] initWithFrame:frame items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = YES;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(frame.size.width/2-W(legend)/2, frame.size.height/2-H(legend)/2, legend.frame.size.width, legend.frame.size.height)];
    [self.pieChart addSubview:legend];
    return self.pieChart;
}
///散点图
-(void)createScatterChart{
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6.0 - 30, 135, 280, 200)];
    //self.scatterChart.yLabelFormat = @"xxx %1.1f";
    [self.scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
    [self.scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];
    [self.scatterChart setAxisXLabel:@[@"x1", @"x2", @"x3", @"x4", @"x5", @"x6"]];
    [self.scatterChart setAxisYLabel:@[@"y1", @"y2", @"y3", @"y4", @"y5"]];
    NSMutableArray *data01Array = [NSMutableArray array];
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25 ; i++) {
        [XAr addObject:[NSString stringWithFormat:@"%1.f",(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisX_maxValue - self.scatterChart.AxisX_minValue) + self.scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:@"%1.f",(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisY_maxValue - self.scatterChart.AxisY_minValue) + self.scatterChart.AxisY_minValue)]];
    }
    [data01Array addObject:XAr];
    [data01Array addObject:YAr];
    PNScatterChartData *data01 = [PNScatterChartData new];
    data01.strokeColor = PNGreen;
    data01.fillColor = PNFreshGreen;
    data01.size = 2;
    data01.itemCount = [[data01Array objectAtIndex:0] count];
    data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
    __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
    __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
    data01.getData = ^(NSUInteger index) {
        CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
        CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    [self.scatterChart setup];
    self.scatterChart.chartData = @[data01];
    /***
     this is for drawing line to compare
     CGPoint start = CGPointMake(20, 35);
     CGPoint end = CGPointMake(80, 45);
     [self.scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
     ***/
    self.scatterChart.delegate = self;
    [self.view addSubview:self.scatterChart];

}
///雷达图
-(UIView*)getRadarChartWithFrame:(CGRect)frame values:(NSArray*)values descriptions:(NSArray*)descriptions{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:10];
    for(int i=0;i<values.count;i++){
        [items addObject:[PNRadarChartDataItem dataItemWithValue:[values[i]floatValue] description:descriptions[i]]];
    }
    self.radarChart = [[PNRadarChart alloc] initWithFrame:frame items:items valueDivider:1];
    self.radarChart.isShowGraduation = YES;
    self.radarChart.displayAnimated = YES;
    [self.radarChart strokeChart];
    return self.radarChart;
}
#pragma mark ChartDelegate
- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"点击了线上的点%f,%f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex{
    NSLog(@"Click on bar %@", @(barIndex));
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [bar.layer addAnimation:animation forKey:@"Float"];
}

#pragma mark 新添加的别处的类
- (UIView*)getTwoColumnViewWithFrame:(CGRect)frame array1:(NSArray*)array1 array2:(NSArray*)array2 names:(NSArray*)names{
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 100, APPW, APPW)];
    /* 创建数据源数组 每个数组即为一个模块数据 例如第一个数组可以表示某个班级的不同科目的平均成绩 下一个数组表示另外一个班级的不同科目的平均成绩*/
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0;i<array1.count;i++){
        NSArray *temp = @[array1[i],array2[i]];
        [valueArray addObject:temp];
    }
    column.valueArr = valueArray;
    /*该点 表示原点距左下角的距离*/
    column.originSize = CGPointMake(30, 30);
    /*第一个柱状图距原点的距离*/
    column.drawFromOriginX = 10;
    /*柱状图的宽度*/
    column.columnWidth = 40;
    /*X、Y轴字体颜色*/
    column.drawTextColorForX_Y = [UIColor greenColor];
    /*X、Y轴线条颜色*/
    column.colorForXYLine = [UIColor greenColor];
    /*每个模块的颜色数组 例如A班级的语文成绩颜色为红色 数学成绩颜色为绿色         */
    column.columnBGcolorsArr = @[[UIColor redColor],[UIColor greenColor]];
    /*模块的提示语*/
    column.xShowInfoText = names;
    [column showAnimation];
    return column;
}
@end

