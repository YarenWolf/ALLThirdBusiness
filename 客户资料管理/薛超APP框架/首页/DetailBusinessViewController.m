//
//  DetailBusinessViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/26.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "DetailBusinessViewController.h"
#import "CustomHTMLParser.h"
@interface DetailBusinessCell:BaseTableViewCell
@end
@implementation DetailBusinessCell{
    UILabel *phone;
    UILabel *nameLabel;
}
-(void)initUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10, 250, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(APPW-280, 10, 250, 20)];
    phone.textAlignment = NSTextAlignmentRight;
    phone.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 43, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubviews:nameLabel,phone,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    nameLabel.text = dict[@"name"];
    phone.text = dict[@"value"];
}
-(NSArray *)observableKeypaths{
    return nil;
}
-(void)deallocTableCell{
    
}
@end
@interface CustomPerson:NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@end
@implementation CustomPerson
@end
@interface DetailBusinessViewController (){
    NSArray *urlStrings;
    NSMutableDictionary *params;
    AFHTTPSessionManager *manager;
    NSMutableArray *datas;
}

@end

@implementation DetailBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *s1 = @"https://aes.aia.com.cn/isp/iconn/multiTerm/baseInfo/search.do";//基本信息
    NSString *s2 = @"https://aes.aia.com.cn/isp/iconn/policy/renew.do";//续保信息;
    NSString *s3 = @"https://aes.aia.com.cn/isp/iconn/policy/change.do";//变更信息;
    NSString *s4 = @"https://aes.aia.com.cn/isp/iconn/policy/claim/index.do";//理赔信息;
    NSString *s5 = @"https://aes.aia.com.cn/isp/iconn/policyCusMail/policyCusMail.do";//营运信件;
    NSString *s6 = @"https://aes.aia.com.cn/isp/iconn/policy/pend/index.do";//照会信息;
    NSString *s7 = @"https://aes.aia.com.cn/isp/iconn/policy/refund/index.do";//领款/退费信息;
    NSString *s8 = @"https://aes.aia.com.cn/isp/iconn/dividendget/dividend.do";//保单红利;
    NSString *s9 = @"https://aes.aia.com.cn/isp/iconn/beneficiary/index.do";//受益人信息;
    NSString *s10 = @"https://aes.aia.com.cn/isp/iconn/campaignleads/campaignleads.do";//加保活动;
    NSString *s11 = @"https://aes.aia.com.cn/isp/iconn/ilppolicy/ilppolicy.do";//ILP客户账户价值;
    NSString *s12 = @"https://aes.aia.com.cn/isp/iconn/ulpolicy/ulpolicy.do";//万能寿险个人账户;
    NSString *s13 = @"https://aes.aia.com.cn/isp/iconn/policyreceipt/policyreceipt.do";//新单回执;
    NSString *s14 = @"https://aes.aia.com.cn/isp/iconn/policy/CashAPLLoan.do";//自动垫付保单;
    NSString *s15 = @"https://aes.aia.com.cn/isp/iconn/policy/cashValue.do";//现金价值;
    NSString *s16 = @"https://aes.aia.com.cn/isp/iconn/policy/CustomCall.do";//客户来电;
    NSString *s17 = @"https://aes.aia.com.cn/isp/iconn/policynewsinglevisit/index.do";//新单回访
    urlStrings = [NSArray arrayWithObjects:s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17, nil];
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.otherInfo[@"capolnum"],@"policyNo",@"",@"polType",@"1",@"isTab",[[Utility Share]userId],@"agentId",@"20",@"status",@"1",@"tag",nil];
    datas = [NSMutableArray arrayWithCapacity:30];
    [self searchDetailMessageWithURL:urlStrings[0]];
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-64)];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:datas];
    self.tableView.editingStyle = UITableViewCellEditingStyleDelete;
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:YES headH:0 footH:0 rowH:44 sectionN:1 rowN:datas.count cellName:@"DetailBusinessCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [DetailBusinessCell getInstance];
    }
    [cell setDataWithDict:self.tableView.dataArray[indexPath.row]];
    return cell;
}
-(void)searchDetailMessageWithURL:(NSString*)url{
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *sd = [result substringWithRange:NSMakeRange(454, result.length-1261)];
        NSString *sdds = [sd stringByReplacingOccurrencesOfString:@"&" withString:@""];
        NSString *s = [[sdds stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAppendingString:@"</html>"];
        CustomHTMLParser *parse = [[CustomHTMLParser alloc]init];
        NSArray *names = [parse parseWithData:[s dataUsingEncoding:NSUTF8StringEncoding]];
        BOOL isName = YES;NSString *temp = [NSString string];BOOL first=NO;
        for(NSString *s in names){
            if(isName){
                 if(!first) temp = s;
                if([s isEqualToString:@"姓名"]){
                    isName = !isName;first = YES;
                }else{
                    first = NO;
                }
            }else{
                NSMutableDictionary *ddi = [NSMutableDictionary dictionaryWithObjectsAndKeys:temp,@"name",s,@"value", nil];
//                CustomPerson *person = [[CustomPerson alloc]init];
//                person.name = temp;person.value = s;
                [datas addObject:ddi];
//                [datas addObject:person];
            }
            isName = !isName;
        }
        self.tableView.dataArray = datas;
        self.tableView.rowN = datas.count;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *a = error.userInfo;
        NSString *s1 = [a objectForKey:@"NSUnderlyingError"];
        NSString *s2 = [a objectForKey:@"NSErrorFailingURLKey"];
        NSString *s3 = [a objectForKey:@"_kCFStreamErrorCodeKey"];//@"NSLocalizedDescription"
        DLog(@"%@\n\n\n%@\n\n\n%@\n\n\n%@",s1,s2,s3,@"");
    }];
}
@end
