//
//  DrawViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/11/9.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "DrawViewController.h"
#import "PYColor.h"
#import "PYOption.h"
#import "RMMapper.h"
#import "Utility.h"
#import "Record.h"
#import "Acount.h"
@interface AccountDetailCell:BaseTableViewCell
-(void)setDataWithPerson:(Record*)record;
@end
@implementation AccountDetailCell{
    UILabel *phone;
    UILabel *nameLabel;
    UILabel *time;
    UILabel *wechat;
    UILabel *bname;
    UILabel *bphone;
    UILabel *ftime;
    UILabel *recorditem;
}
-(void)initUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10, 150, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(XW(nameLabel)+10, Y(nameLabel), 150, H(nameLabel))];
    bname = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel),YH(nameLabel)+20, W(nameLabel),H(nameLabel))];
    bphone = [[UILabel alloc]initWithFrame:CGRectMake(X(phone), Y(bname), W(phone), H(nameLabel))];
    wechat = [[UILabel alloc]initWithFrame:CGRectMake(XW(bphone)+10, Y(bphone), 150, 20)];
    time = [[UILabel alloc]initWithFrame:CGRectMake(XW(phone)+10, Y(nameLabel), 150, 20)];
    ftime = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, Y(nameLabel), 100, 20)];
    ftime.textAlignment = NSTextAlignmentRight;
    recorditem = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200,Y(bname),100, 20)];
    recorditem.textAlignment = NSTextAlignmentRight;
    time.font= phone.font = bphone.font = wechat.font = ftime.font = recorditem.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 79, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self addSubviews:nameLabel,phone,time,wechat,bname,bphone,ftime,recorditem,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{}
-(void)setDataWithPerson:(Record*)record{
    nameLabel.text = [NSString stringWithFormat:@"类型:%@",record.type];//收入支出预算
    phone.text = [NSString stringWithFormat:@"时间:%@",record.date];
    bname.text = [NSString stringWithFormat:@"账户:%@",record.yinhang];
    bphone.text = [NSString stringWithFormat:@"账号:%@",record.account];
    wechat.text = [NSString stringWithFormat:@"金额:%0.2lf",record.money];
    time.text = [NSString stringWithFormat:@"分类:%@",record.classItem];
    ftime.text = [NSString stringWithFormat:@"说明:%@",record.descript];
    if([record.type isEqualToString:@"收入"]){
        recorditem.text = [NSString stringWithFormat:@"收入项目:%@",record.inputItem];
    }else if([record.type isEqualToString:@"支出"]){
        recorditem.text = [NSString stringWithFormat:@"支出项目:%@",record.outputItem];
    }else{
        recorditem.text = [NSString stringWithFormat:@"预算项目:%@",record.expectItem];
    }
}
-(NSArray *)observableKeypaths{return nil;}
@end

@interface DrawViewController ()<UISearchBarDelegate>{
}
@end
@implementation DrawViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]init];
    self.tableView.editingStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    Acount *acount = self.otherInfo;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"account = %@",acount.account];
    [request setPredicate:p1];
    NSArray *a = [[AppDelegate Share].managedObjectContext executeFetchRequest:request error:nil];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:a];
    self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:80 sectionN:1 rowN:self.tableView.dataArray.count cellName:@"AccountDetailCell"];
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH-50);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH-46);
        [self.tableView reloadData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [AccountDetailCell getInstance];
    }
    [cell setDataWithPerson:self.tableView.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}





#pragma mark 以下是图表内容
-(void)loadthechartView{
    _kEchartView = [[PYEchartsView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-200)];
    [self.view addSubview:_kEchartView];
    [self showBasicAreaDemo];
    [_kEchartView loadEcharts];
}
//标准面积图
-(void)showBasicAreaDemo {
    PYOption *option = [[PYOption alloc] init];
    option.title = [[PYTitle alloc] init];
    option.title.text = @"某楼盘销售情况";
    option.title.subtext = @"纯属虚构";
    PYGrid *grid = [[PYGrid alloc] init];
    grid.x = @(40);
    grid.x2 = @(50);
    option.grid = grid;
    option.tooltip = [[PYTooltip alloc] init];
    option.tooltip.trigger = @"axis";
    option.legend = [[PYLegend alloc] init];
    option.legend.data = @[@"意向",@"预购",@"成交"];
    option.toolbox = [[PYToolbox alloc] init];
    option.toolbox.show = YES;
    option.toolbox.feature = [[PYToolboxFeature alloc] init];
    option.toolbox.feature.mark = [[PYToolboxFeatureMark alloc] init];
    option.toolbox.feature.mark.show = YES;
    option.toolbox.feature.dataView = [[PYToolboxFeatureDataView alloc] init];
    option.toolbox.feature.dataView.show = YES;
    option.toolbox.feature.dataView.readOnly = NO;
    option.toolbox.feature.magicType = [[PYToolboxFeatureMagicType alloc] init];
    option.toolbox.feature.magicType.show = YES;
    option.toolbox.feature.magicType.type = @[@"line", @"bar", @"stack", @"tiled"];
    option.toolbox.feature.restore = [[PYToolboxFeatureRestore alloc] init];
    option.toolbox.feature.restore.show = YES;
    option.toolbox.feature.saveAsImage = [[PYToolboxFeatureSaveAsImage alloc] init];
    option.toolbox.feature.saveAsImage.show = YES;
    option.calculable = YES;
    PYAxis *xAxis = [[PYAxis alloc] init];
    xAxis.type = @"category";
    xAxis.boundaryGap = @(NO);
    xAxis.data = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    NSMutableArray *serieses = [[NSMutableArray alloc] init];
    PYCartesianSeries *series1 = [[PYCartesianSeries alloc] init];
    series1.name = @"成交";
    series1.type = @"line";
    series1.smooth = YES;
    series1.itemStyle = [[PYItemStyle alloc] init];
    series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series1.itemStyle.normal.areaStyle = [[PYAreaStyle alloc] init];
    series1.itemStyle.normal.areaStyle.type = @"default";
    series1.data = @[@(10),@(12),@(21),@(54),@(260),@(830),@(710)];
    [serieses addObject:series1];
    PYCartesianSeries *series2 = [[PYCartesianSeries alloc] init];
    series2.name = @"预购";
    series2.type = @"line";
    series2.smooth = YES;
    series2.itemStyle = [[PYItemStyle alloc] init];
    series2.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series2.itemStyle.normal.areaStyle = [[PYAreaStyle alloc] init];
    series2.itemStyle.normal.areaStyle.type = @"default";
    series2.data = @[@(30),@(182),@(434),@(791),@(390),@(30),@(10)];
    [serieses addObject:series2];
    PYCartesianSeries *series3 = [[PYCartesianSeries alloc] init];
    series3.name = @"意向";
    series3.type = @"line";
    series3.smooth = YES;
    series3.itemStyle = [[PYItemStyle alloc] init];
    series3.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series3.itemStyle.normal.areaStyle = [[PYAreaStyle alloc] init];
    series3.itemStyle.normal.areaStyle.type = @"default";
    series3.data = @[@(1320),@(1132),@(601),@(234),@(120),@(90),@(20)];
    [serieses addObject:series3];
    [option setSeries:serieses];
    [_kEchartView setOption:option];
    
}
//不等距折线图
-(void)showIrregularLine2Demo {
    PYOption *option = [[PYOption alloc] init];
    option.title = [[PYTitle alloc] init];
    option.title.text = @"时间坐标折线图";
    option.title.subtext = @"dataZoom支持";
    PYGrid *grid = [[PYGrid alloc] init];
    grid.x = @(40);
    grid.x2 = @(50);
    option.grid = grid;
    option.tooltip = [[PYTooltip alloc] init];
    option.tooltip.trigger = @"item";
    option.tooltip.formatter = @"(function(params){var date = new Date(params.value[0]);data = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes(); return data + '<br/>' + params.value[1] + ',' + params.value[2]})";
    option.toolbox = [[PYToolbox alloc] init];
    option.toolbox.show = YES;
    option.toolbox.feature = [[PYToolboxFeature alloc] init];
    option.toolbox.feature.mark = [[PYToolboxFeatureMark alloc] init];
    option.toolbox.feature.mark.show = YES;
    option.toolbox.feature.dataView = [[PYToolboxFeatureDataView alloc] init];
    option.toolbox.feature.dataView.show = YES;
    option.toolbox.feature.dataView.readOnly = NO;
    option.toolbox.feature.restore = [[PYToolboxFeatureRestore alloc] init];
    option.toolbox.feature.restore.show = YES;
    option.toolbox.feature.saveAsImage = [[PYToolboxFeatureSaveAsImage alloc] init];
    option.toolbox.feature.saveAsImage.show = YES;
    option.dataZoom = [[PYDataZoom alloc] init];
    option.dataZoom.show = YES;
    option.dataZoom.start = @(70);
    option.legend = [[PYLegend alloc] init];
    option.legend.data = @[@"series1"];
    option.grid = [[PYGrid alloc] init];
    option.grid.y2 = @(80);
    PYAxis *xAxis = [[PYAxis alloc] init];
    xAxis.type = @"time";
    xAxis.splitNumber = @(10);
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    PYCartesianSeries *series = [[PYCartesianSeries alloc] init];
    series.name = @"series1";
    series.type = @"line";
    series.showAllSymbol = YES;
    series.symbolSize = @"(function(value) {return Math.round(value[2]/100) + 2;})";
    series.data = @"(function () {var d = [];var len = 0;var now = new Date();var value;while (len++ < 200) {d.push([new Date(2014, 9, 1, 0, len * 10000),(Math.random()*30).toFixed(2) - 0,(Math.random()*100).toFixed(2) - 0]);}return d;})()";
    option.series = [[NSMutableArray alloc] initWithObjects:series, nil];
    [_kEchartView setOption:option];
    
    
}
//标准柱状图
-(void)showBasicColumnDemo {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:5];
    NSString *basicColumnJson = @"{\"grid\":{\"x\":30,\"x2\":45},\
    \"title\":{\"text\":\"某地区蒸发量和降水量\",\"subtext\":\"纯属虚构\"},\
    \"tooltip\":{\"trigger\":\"axis\"},\
    \"legend\":{\"data\":[\"蒸发量\",\"降水量\"]},\
    \"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\
    \"calculable\":true,\
    \"xAxis\":[{\"type\":\"category\",\"data\":[\"1月\",\"2月\",\"3月\",\"4月\",\"5月\",\"6月\",\"7月\",\"8月\",\"9月\",\"10月\",\"11月\",\"12月\"]}],\
    \"yAxis\":[{\"type\":\"value\"}],\
    \"series\":[{\"name\":\"蒸发量\",\"type\":\"bar\",\"data\":[2,4.9,7,23.2,25.6,76.7,135.6,162.2,32.6,20,6.4,3.3],\"markPoint\":{\"data\":[{\"type\":\"max\",\"name\":\"最大值\"},{\"type\":\"min\",\"name\":\"最小值\"}]},\"markLine\":{\"data\":[{\"type\":\"average\",\"name\":\"平均值\"}]}},{\
    \"name\":\"降水量\",\"type\":\"bar\",\"data\":[2.6,5.9,9,26.4,28.7,70.7,175.6,182.2,48.7,18.8,6,2.3],\"markPoint\":{\"data\":[{\"name\":\"年最高\",\"value\":182.2,\"xAxis\":7,\"yAxis\":183,\"symbolSize\":18},{\"name\":\"年最低\",\"value\":2.3,\"xAxis\":11,\"yAxis\":3}]},\"markLine\":{\"data\":[{\"type\":\"average\",\"name\":\"平均值\"}]}}]}";
    
    NSData *jsonData = [basicColumnJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    
    
}
/**
 *  标准条形图
 */
-(void)showBasicBarDemo {
    NSString *basicBarJson = @"{\"grid\":{\"x\":30,\"x2\":45},\
    \"title\":{\"text\":\"世界人口总量\",\"subtext\":\"数据来自网络\"},\
    \"tooltip\":{\"trigger\":\"axis\"},\
    \"legend\":{\"data\":[\"2011年\",\"2012年\"]},\
    \"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\
    \"calculable\":true,\
    \"xAxis\":[{\"type\":\"value\",\"boundaryGap\":[0,0.01]}],\
    \"yAxis\":[{\"type\":\"category\",\"data\":[\"巴西\",\"印尼\",\"美国\",\"印度\",\"中国\",\"世界人口(万)\"]}],\
    \"series\":[{\"name\":\"2011年\",\"type\":\"bar\",\"data\":[18203,23489,29034,104970,131744,630230]},{\
    \"name\":\"2012年\",\"type\":\"bar\",\"data\":[19325,23438,31000,121594,134141,681807]}]}";
    
    NSData *jsonData = [basicBarJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    
}

/**
 *  搭配时间轴
 */
-(void)showTimelineDemo {
    NSString *timelineJson = @"{\"timeline\":{\
    \"data\":[\"2013-01-01\",\"2013-02-01\",\"2013-03-01\",\"2013-04-01\",\"2013-05-01\",{\"name\":\"2013-06-01\",\"symbol\":\"emptyStar6\",\"symbolSize\":8},\"2013-07-01\",\"2013-08-01\",\"2013-09-01\",\"2013-10-01\",\"2013-11-01\",{\"name\":\"2013-12-01\",\"symbol\":\"star6\",\"symbolSize\":8}],\
    \"label\":{\"formatter\":\"(function(s) {return s.slice(0, 7);})\"}},\
    \"options\":[{\"title\":{\"text\":\"浏览器占比变化\",\"subtext\":\"纯属虚构\"},\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{a} <br/>{b} : {c} ({d}%)\"},\"legend\":{\"data\":[\"Chrome\",\"Firefox\",\"Safari\",\"IE9+\",\"IE8-\"]},\"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"pie\",\"funnel\"],\"option\":{\"funnel\":{\"x\":\"25%\",\"width\":\"50%\",\"funnelAlign\":\"left\",\"max\":1700}}},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"center\":[\"50%\",\"45%\"],\"radius\":\"50%\",\"data\":[{\"value\":208,\"name\":\"Chrome\"},{\"value\":224,\"name\":\"Firefox\"},{\"value\":352,\"name\":\"Safari\"},{\"value\":656,\"name\":\"IE9+\"},{\"value\":1288,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":336,\"name\":\"Chrome\"},{\"value\":288,\"name\":\"Firefox\"},{\"value\":384,\"name\":\"Safari\"},{\"value\":672,\"name\":\"IE9+\"},{\"value\":1296,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":464,\"name\":\"Chrome\"},{\"value\":352,\"name\":\"Firefox\"},{\"value\":416,\"name\":\"Safari\"},{\"value\":688,\"name\":\"IE9+\"},{\"value\":1304,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":592,\"name\":\"Chrome\"},{\"value\":416,\"name\":\"Firefox\"},{\"value\":448,\"name\":\"Safari\"},{\"value\":704,\"name\":\"IE9+\"},{\"value\":1312,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":720,\"name\":\"Chrome\"},{\"value\":480,\"name\":\"Firefox\"},{\"value\":480,\"name\":\"Safari\"},{\"value\":720,\"name\":\"IE9+\"},{\"value\":1320,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":848,\"name\":\"Chrome\"},{\"value\":544,\"name\":\"Firefox\"},{\"value\":512,\"name\":\"Safari\"},{\"value\":736,\"name\":\"IE9+\"},{\"value\":1328,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":976,\"name\":\"Chrome\"},{\"value\":608,\"name\":\"Firefox\"},{\"value\":544,\"name\":\"Safari\"},{\"value\":752,\"name\":\"IE9+\"},{\"value\":1336,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1104,\"name\":\"Chrome\"},{\"value\":672,\"name\":\"Firefox\"},{\"value\":576,\"name\":\"Safari\"},{\"value\":768,\"name\":\"IE9+\"},{\"value\":1344,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1232,\"name\":\"Chrome\"},{\"value\":736,\"name\":\"Firefox\"},{\"value\":608,\"name\":\"Safari\"},{\"value\":784,\"name\":\"IE9+\"},{\"value\":1352,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1360,\"name\":\"Chrome\"},{\"value\":800,\"name\":\"Firefox\"},{\"value\":640,\"name\":\"Safari\"},{\"value\":800,\"name\":\"IE9+\"},{\"value\":1360,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1488,\"name\":\"Chrome\"},{\"value\":864,\"name\":\"Firefox\"},{\"value\":672,\"name\":\"Safari\"},{\"value\":816,\"name\":\"IE9+\"},{\"value\":1368,\"name\":\"IE8-\"}]}]},{\
    \"series\":[{\"name\":\"浏览器（数据纯属虚构）\",\"type\":\"pie\",\"data\":[{\"value\":1616,\"name\":\"Chrome\"},{\"value\":928,\"name\":\"Firefox\"},{\"value\":704,\"name\":\"Safari\"},{\"value\":832,\"name\":\"IE9+\"},{\"value\":1376,\"name\":\"IE8-\"}]}]}]}";
    
    NSData *jsonData = [timelineJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    
}

/**
 *  标准雷达图
 */
-(void)showBasicRadarDemo {
    NSString *json = @"{\"title\":{\"text\":\"预算 vs 开销（Budget vs spending）\",\"subtext\":\"纯属虚构\"},\
    \"tooltip\":{\"trigger\":\"axis\"},\
    \"legend\":{\"orient\":\"vertical\",\"x\":\"right\",\"y\":\"bottom\",\"data\":[\"预算分配（Allocated Budget）\",\"实际开销（Actual Spending）\"]},\
    \"toolbox\":{\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\
    \"polar\":[{\"radius\":\"50%\",\"indicator\":[{\"text\":\"销售（sales）\",\"max\":6000},{\"text\":\"管理（Admin）\",\"max\":16000},{\"text\":\"信息技术（Infor Tec）\",\"max\":30000},{\"text\":\"客服（Customer Support）\",\"max\":38000},{\"text\":\"研发（Development）\",\"max\":52000},{\"text\":\"市场（Marketing）\",\"max\":25000}]}],\
    \"calculable\":true,\
    \"series\":[{\"name\":\"预算 vs 开销（Budget vs spending）\",\"type\":\"radar\",\"data\":[{\"value\":[4300,10000,28000,35000,50000,19000],\"name\":\"预算分配（Allocated Budget）\"},{\
    \"value\":[5000,14000,28000,31000,42000,21000],\"name\":\"实际开销（Actual Spending）\"}]}]}";
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    
}

@end
