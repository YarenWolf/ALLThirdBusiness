////业务查询
//dataurl = @"https://aes.aia.com.cn/isp/iconn/multiTerm/index.do";//订单查询的网页
#import "BusinessViewController.h"
#import "DetailBusinessViewController.h"
#import "Utility.h"
#import "Customdata.h"
#import "CustomHTMLParser.h"
@interface BusinessCell:BaseTableViewCell

@end
@implementation BusinessCell{
    UILabel *phone;
    UILabel *nameLabel;
    UILabel *time;
    UILabel *wechat;
    UILabel *bname;
    UILabel *bphone;
    UILabel *ftime;
}
-(void)initUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,5, 150, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(XW(nameLabel)+10, Y(nameLabel), 150, H(nameLabel))];
    bname = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel),YH(nameLabel)+10, W(nameLabel),H(nameLabel))];
    bphone = [[UILabel alloc]initWithFrame:CGRectMake(X(phone), Y(bname), W(phone), H(nameLabel))];
    wechat = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, 30, 150, 20)];
    time = [[UILabel alloc]initWithFrame:CGRectMake(XW(phone)+10, 5, 150, 20)];
//    time.textAlignment = wechat.textAlignment = NSTextAlignmentRight;
    time.font= phone.font = bphone.font = wechat.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 59, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ftime = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, 5, 100, 20)];
    ftime.textAlignment = NSTextAlignmentRight;
    [self addSubviews:nameLabel,phone,time,wechat,bname,bphone,ftime,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    nameLabel.text = [NSString stringWithFormat:@"投保人:%@",[dict valueForJSONKey:@"cainame"]];
    phone.text = [NSString stringWithFormat:@"手机号:%@",[dict valueForJSONKey:@"contacttel2"]];
    bname.text = [NSString stringWithFormat:@"被保人:%@",[dict valueForJSONKey:@"caoname"]];
    bphone.text = [NSString stringWithFormat:@"手机号:%@",[dict valueForJSONKey:@"contacttel"]];
    wechat.text = [NSString stringWithFormat:@"保额:%@",[dict valueForJSONKey:@"cbcovamt"]];
    time.text = [NSString stringWithFormat:@"保单号:%@",[dict valueForJSONKey:@"capolnum"]];
    ftime.text = [NSString stringWithFormat:@"%@",[dict valueForJSONKey:@"validdate"]];
}
-(NSArray *)observableKeypaths{return nil;}
@end

@interface BusinessViewController (){
    AFHTTPSessionManager *manager;
    NSMutableDictionary *params;
    NSMutableArray *datas;
    NSInteger ge;//保存第多少个
}
@end
@implementation BusinessViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithTitle:@"本地" style:UIBarButtonItemStylePlain target:self action:@selector(putToLocal2)];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(putToLocal1)];
    UIBarButtonItem *right3 = [[UIBarButtonItem alloc]initWithTitle:@"100/次" style:UIBarButtonItemStylePlain target:self action:@selector(putToLocal3)];
//    UIBarButtonItem *right4 = [[UIBarButtonItem alloc]initWithTitle:@"地" style:UIBarButtonItemStylePlain target:self action:@selector(putToLocal4)];
    self.navigationItem.rightBarButtonItems = @[right3,right1,right2];

    datas = [NSMutableArray arrayWithCapacity:30];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, TopHeight, APPW-130, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = searchBar;
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 64, APPW, APPH-64)];
    self.tableView.dataArray = [NSMutableArray arrayWithCapacity:10];
    self.tableView.editingStyle = UITableViewCellEditingStyleNone;
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:60 sectionN:1 rowN:self.tableView.dataArray.count cellName:@"BusinessCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    params = [NSMutableDictionary dictionaryWithCapacity:10];
    if(![[[Utility Share]userId]notEmptyOrNull]){
        [[Utility Share]setUserId:@"000498492"];
    }
    [params setObject:[[Utility Share] userId] forKey:@"agentId"];//保险营销员编号
    [params setObject:@"" forKey:@"policyCode"];//保单合同编号
    [params setObject:@"" forKey:@"insuredName"];//被保险人姓名
    [params setObject:@"" forKey:@"insuredID"];//被保险人身份证号
    [params setObject:@"" forKey:@"insuredBirthMonth"];//被保险人生日MM
    [params setObject:@"" forKey:@"polOwnerName"];//投保人姓名
    [params setObject:@"" forKey:@"polOwnerID"];//投保人身份证号
    [params setObject:@"" forKey:@"polOwnerBirthMonth"];//投保人生日(月)MM
    [params setObject:@"" forKey:@"polOwnerZip"];//投保人邮政编码
    [params setObject:@"Agency" forKey:@"channel"];//渠道
    [params setObject:@"" forKey:@"polStatus"];//保险合同状态【10-49】
    [params setObject:@"" forKey:@"phoneNoMobile"];//手机号码
    [params setObject:@"" forKey:@"phoneNoDay"];//日间电话
    [params setObject:@"" forKey:@"phoneNoNight"];//夜间电话
    [params setObject:@"" forKey:@"ncltype"];//保单有借款1/0
    [params setObject:@"1" forKey:@"sortKey"];//排序条件1-10
//    NSArray *b = @[@"保险合同编号",@"保险合同生效日",@"保险费到期日",@"缴费方式",@"投保人生日",@"被保人生日",@"保险合同状态",@"付款方式",@"当期保费",@"保额"];
    [params setObject:@"1" forKey:@"sortOrder"];//排序方式1/0
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:[[Utility Share]userId]]){
        NSData *listdata =[defaults objectForKey:[[Utility Share]userId]];
        self.tableView.dataArray =  [NSKeyedUnarchiver unarchiveObjectWithData:listdata];
        self.tableView.rowN = self.tableView.dataArray.count;
        [self.tableView reloadData];
    }else if([[[AppDelegate Share]lineCustoms]count]>3){
        self.tableView.dataArray = [[AppDelegate Share]lineCustoms];
        self.tableView.rowN = self.tableView.dataArray.count;
        [self.tableView reloadData];
    }else{
        [self searchCustomMessagesWithParams:params];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, 64, APPW, APPH-64);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, 64, APPW, APPH-64);
        [self.tableView reloadData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [BusinessCell getInstance];
    }
    [cell setDataWithDict:self.tableView.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushController:[DetailBusinessViewController class] withInfo:nil withTitle:[self.tableView.dataArray[indexPath.row]valueForJSONKey:@"cainame"] withOther:self.tableView.dataArray[indexPath.row]];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBa{
    [self.view endEditing:YES];
    [params setObject:searchBa.text forKey:@"polOwnerName"];
//    [params setObject:searchBa.text forKey:@"policyCode"];
//    [params setObject:searchBa.text forKey:@"insuredName"];
//    [params setObject:searchBa.text forKey:@"phoneNoMobile"];
    [self searchCustomMessagesWithParams:params];
}
-(void)searchCustomMessagesWithParams:(NSDictionary*)param{
    DLog(@"%@",param);
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    NSString *dataurl = @"https://aes.aia.com.cn/isp/iconn/multiTerm/search.do";//订单查询
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager POST:dataurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *list = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        self.tableView.dataArray = [NSMutableArray arrayWithArray:list];
        self.tableView.rowN = list.count;
        [self.tableView reloadData];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *listdata = [NSKeyedArchiver archivedDataWithRootObject:list];
        [defaults setObject:listdata forKey:[[Utility Share]userId]];
        [defaults synchronize];
        [[AppDelegate Share]setLineCustoms:[NSMutableArray arrayWithArray:list]];
        NSString *number = [NSString stringWithFormat:@"总共检索出 %ld 条!",list.count];
        [SVProgressHUD showSuccessWithStatus:number];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *a = error.userInfo;
        NSString *s1 = [a objectForKey:@"com.alamofire.serialization.response.error.response"];//请求头
        NSData *data = [a objectForKey:@"com.alamofire.serialization.response.error.data"];//数据内容
        NSString *s2 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *s3 = [a objectForKey:@"NSLocalizedDescription"];//请求失败原因
        [SVProgressHUD showErrorWithStatus:@"网络错误，请重新尝试"];
        DLog(@"%@\n\n\n%@\n\n\n%@\n\n\n%@",s1,s2,s3,@"");
    }];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)putToLocal1{
//    dispatch_queue_t queue=dispatch_queue_create("MyConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSInteger times = ++[AppDelegate Share].times;
    ge = (times-1)*100;
    for(NSInteger i=(times-1)*100;i<times*100;i++){
        if(i>=self.tableView.dataArray.count)return;
        NSDictionary *dict = self.tableView.dataArray[i];
        NSString *baodannumber = [dict valueForJSONKey:@"capolnum"];
        DLog(@"%@\n",baodannumber);
        dispatch_async(queue, ^{
            [self searchDetailMessageWithBaodan:baodannumber tbaoe:[dict valueForJSONKey:@"cbcovamt"]];
        });
        
    }
}
-(void)putToLocal2{
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount=5;//设置最大并发数
    NSMutableArray *operations = [NSMutableArray arrayWithCapacity:30];
    
    NSInteger times = ++[AppDelegate Share].times;
    
    ge = (times-1)*100;
    for(NSInteger i=(times-1)*100;i<times*100;i++){
        if(i>=self.tableView.dataArray.count)return;
        NSDictionary *dict = self.tableView.dataArray[i];
        NSString *baodannumber = [dict valueForJSONKey:@"capolnum"];
        NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
            DLog(@"%@\n",baodannumber);
            [self searchDetailMessageWithBaodan:baodannumber tbaoe:[dict valueForJSONKey:@"cbcovamt"]];
        }];
        [operations addObject:operation];
//        [queue addOperation:operation];
//        [queue addOperationWithBlock:^{
//            [self searchDetailMessageWithBaodan:baodannumber];
//        }];
    }
    [queue addOperations:operations waitUntilFinished:YES];
   
    
}
-(void)putToLocal3{
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    dispatch_group_t group=dispatch_group_create();
    NSInteger times = ++[AppDelegate Share].times;
    ge = (times-1)*100;
    //创建任务放到指定的队列和组中
    for(NSInteger i=(times-1)*100;i<times*100;i++){
        if(i>=self.tableView.dataArray.count)return;
        NSDictionary *dict = self.tableView.dataArray[i];
        NSString *baodannumber = [dict valueForJSONKey:@"capolnum"];
        dispatch_group_async(group, queue, ^{
//            DLog(@"%@\n",baodannumber);
            [self searchDetailMessageWithBaodan:baodannumber tbaoe:[dict valueForJSONKey:@"cbcovamt"]];
        });
    }
    //通知组中的所有任务执行完毕（合成）
    dispatch_group_notify(group, queue, ^{
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"数据全部准备成功！"];
        });
    });
}
-(void)putToLocal4{
//    [self performSelectorInBackground: @selector(putToLocal1) withObject: nil];
    for (int i=0; i<self.tableView.dataArray.count; ++i) {
        NSDictionary *dict = self.tableView.dataArray[i];
        NSString *baodannumber = [dict valueForJSONKey:@"capolnum"];
        NSDictionary *dicts = [NSDictionary dictionaryWithObjectsAndKeys:baodannumber,@"baodan",[dict valueForJSONKey:@"cbcovamt"],@"baoe", nil];
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(tempSearch:) object:dicts];
        thread.name=[NSString stringWithFormat:@"Thread%i",i];//设置线程名称
        [thread start];
    }
    
//    NSMutableArray *threads=[NSMutableArray array];
//    int count = (int)self.tableView.dataArray.count;
//    for (int i=0; i<count; ++i) {
//        NSDictionary *dict = self.tableView.dataArray[i];
//        NSString *baodannumber = [dict valueForJSONKey:@"capolnum"];
//        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(searchDetailMessageWithBaodan:) object:baodannumber];
//        thread.name=[NSString stringWithFormat:@"Thread%i",i];//设置线程名称
//        if(i==(count-1)){
//            thread.threadPriority=1.0;
//        }else{
//            thread.threadPriority=0.0;
//        }
//        [threads addObject:thread];
//    }
//    for (int i=0; i<count; i++) {
//        NSThread *thread=threads[i];
//        [thread start];
//    }
    
}
-(void)tempSearch:(NSDictionary*)dict{
    [self searchDetailMessageWithBaodan:dict[@"baodan"] tbaoe:dict[@"baoe"]];
}
-(void)searchDetailMessageWithBaodan:(NSString *)baodanNumber tbaoe:(NSString*)baoe{
    NSString *url = @"https://aes.aia.com.cn/isp/iconn/multiTerm/baseInfo/search.do";
    NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:baodanNumber,@"policyNo",@"",@"polType",@"1",@"isTab",[[Utility Share]userId],@"agentId",@"20",@"status",@"1",@"tag",nil];
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *sd = [result substringWithRange:NSMakeRange(454, result.length-1261)];
        NSString *sdds = [sd stringByReplacingOccurrencesOfString:@"&" withString:@""];
        NSString *s = [[sdds stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAppendingString:@"</html>"];
        CustomHTMLParser *parse = [[CustomHTMLParser alloc]init];
        NSArray *names = [parse parseWithData:[s dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableArray *names1 = [NSMutableArray arrayWithCapacity:100];
        NSMutableArray *titles1 = [NSMutableArray arrayWithCapacity:100];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:100];
        int tempNumber=300;
        for(int i=0;i<names.count;i++){
            if([names[i] isEqualToString:@"投保人"] || [names[i] isEqualToString:@"被投保人1"]){
                tempNumber = i;i+=2;
            }
            if(i<54){
                if(i%2){
                    [titles1 addObject:names[i]];
                }else{
                    [names1 addObject:names[i]];
                }
            }else if(i>=tempNumber){
                long j =i-names.count+tempNumber;
                if(j%2){
                    [names1 addObject:names[i]];
                }else{
                    [titles1 addObject:names[i]];
                }
            }else{
                [tempArray addObject:names[i]];
            }
        }
//        for(int i=0;i<names1.count;i++){
//            if([names1[i]isEqualToString:titles1[i]]){
//                titles1[i] = @"--";
//            }
        //        }
        [titles1 insertObject:baodanNumber atIndex:0];
        [titles1 insertObject:baoe atIndex:1];
        [self addCoreDataWithArray1:titles1 andArray2:tempArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *a = error.userInfo;
        NSString *s1 = [a objectForKey:@"NSUnderlyingError"];
        NSString *s2 = [a objectForKey:@"NSErrorFailingURLKey"];
        NSString *s3 = [a objectForKey:@"_kCFStreamErrorCodeKey"];//@"NSLocalizedDescription"
        DLog(@"%@\n\n\n%@\n\n\n%@\n\n\n%@",s1,s2,s3,@"");
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
    }];
}

#pragma mark 增加custom名单
-(void)addCoreDataWithArray1:(NSMutableArray*)a1 andArray2:(NSArray*)a2{
    if(a1.count<55){
        long aaa = a1.count;
        long temp = 55-aaa;
        for(int j=0;j<temp;j++){
            [a1 addObject:@"-"];
        }
    }
    AppDelegate *dele =[AppDelegate Share];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Customdata"];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Customdata" inManagedObjectContext:dele.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tid = %@",a1[0]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    NSArray *persons = [dele.managedObjectContext executeFetchRequest:request error:nil];
    Customdata *custom;
    if ([persons count] > 0) {
        Customdata * lastPerson = [persons lastObject];
        if(![lastPerson.bname isEqualToString:@"-"]){//如果这个人信息完整
            return;
        }else{//信息不完整，但是有这个人
            custom = lastPerson;
        }
        
    }else{
        custom =[NSEntityDescription insertNewObjectForEntityForName:@"Customdata" inManagedObjectContext:dele.managedObjectContext];
    }
    
    NSArray *atts = @[@"tid",@"tbaoe",@"cfromtime",@"ctoime",@"cpaytype",@"clastmoney",@"cjiaofeitype",@"ccurrentmoney",@"cpaytime",@"cfapiaodata",
                      @"mpaymoney",@"movermoney",@"mlastpay",@"mbalance",@"mhandle",@"mfleave",@"mfhandle",@"myearleave",@"myearhandle",@"mmoneyleave",@"mmoneyhandle",@"mreceiveman",@"mnotselect",
                      @"mdiedeal",@"mstory",@"mwanneng",@"mbaodan",@"mcardnumber",@"mcarddate",
                      @"tname",@"tbirthday",@"tsex",@"tIDnumber",@"tdayphone",@"tnightphone",@"ttelephone",@"tacceptM",@"tworknumber",@"tEmail",@"tZipcode",@"towner",@"tpaybank",@"treceivebank",@"taddress",
                      @"bname",@"bname",@"bbirthday",@"bsex",@"bIDnumber",@"bdayphone",@"bnightphone",@"btelephone",@"bacceptM",@"bworknumber",@"breceivebank"];
    for(int m=0;m<atts.count;m++){
        [custom setValue:a1[m] forKey:atts[m]];
    }
    NSMutableArray *ar1 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar2 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar3 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar4 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar5 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar6 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar7 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *ar8 = [NSMutableArray arrayWithCapacity:3];
    NSArray *totalar = @[ar1,ar2,ar3,ar4,ar5,ar6,ar7,ar8];
    for(int i=8;i<a2.count;i++){
        [totalar[i%8] addObject:a2[i]];
    }
    custom.cnumber = [NSKeyedArchiver archivedDataWithRootObject:totalar[0]];
//    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:custom.cnumber];
    custom.cname = [NSKeyedArchiver archivedDataWithRootObject:totalar[1]];
    custom.cbnames = [NSKeyedArchiver archivedDataWithRootObject:totalar[2]];
    custom.cstatus= [NSKeyedArchiver archivedDataWithRootObject:totalar[3]];
    custom.cedu = [NSKeyedArchiver archivedDataWithRootObject:totalar[4]];
    custom.ccost= [NSKeyedArchiver archivedDataWithRootObject:totalar[5]];
    custom.cendtime= [NSKeyedArchiver archivedDataWithRootObject:totalar[6]];
    [[AppDelegate Share] saveContext];ge++;
    NSString *discrip = [NSString stringWithFormat:@"💐保存成功！%ld",ge];
    [SVProgressHUD showSuccessWithStatus:discrip];
}
#pragma mark 以下是多余的参考资料
- (IBAction)groupTask:(id)sender {
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    dispatch_group_t group=dispatch_group_create();
    //创建任务放到指定的队列和组中
    dispatch_group_async(group, queue, ^{});
    dispatch_group_async(group, queue, ^{});
    dispatch_group_async(group, queue, ^{});
    //通知组中的所有任务执行完毕（合成）
    dispatch_group_notify(group, queue, ^{
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程%@",[NSThread currentThread]);
        });
    });
}
#pragma mark NSOperation相关设置，依赖关系，最大并发数
- (IBAction)preferranceNsoperation:(id)sender {
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    NSBlockOperation *operation1=[NSBlockOperation blockOperationWithBlock:^{}];
    NSBlockOperation *operation2=[NSBlockOperation blockOperationWithBlock:^{}];
    NSBlockOperation *operation3=[NSBlockOperation blockOperationWithBlock:^{}];
    NSBlockOperation *operation4=[NSBlockOperation blockOperationWithBlock:^{}];
    NSBlockOperation *operation5=[NSBlockOperation blockOperationWithBlock:^{}];
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
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSLog(@"%@回到主线程了吗",[NSThread currentThread]);
        }];
    }];
    NSOperationQueue *queue=[NSOperationQueue new];
    [queue addOperation:operation];//添加的同时就自动执行。
}
@end
