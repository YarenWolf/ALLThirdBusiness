//
//  DiscoveryViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "Coredata.h"
#import "ServiceViewController.h"
#import "HomeNavigationController.h"
@interface DiscoveryCell:BaseTableViewCell
-(void)setDataWithPerson:(Coredata*)person;
@end
@implementation DiscoveryCell{
    UILabel *phone;
    UILabel *nameLabel;
    UILabel *time;
    UILabel *wechat;
}
-(void)initUI{
    self.iconV =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    self.iconV.contentMode = UIViewContentModeScaleToFill;
    self.iconV.layer.cornerRadius = 5;
    self.iconV.clipsToBounds  = YES;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(XW(self.iconV)+10,5, 250, 20)];
    phone = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), 30, 250, 20)];
    wechat = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, 30, 150, 20)];
    time = [[UILabel alloc]initWithFrame:CGRectMake(APPW-200, 5, 150, 20)];
    time.textAlignment = wechat.textAlignment = NSTextAlignmentRight;
    time.font= phone.font = wechat.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    
    UIView *cellline = [[UIView alloc]initWithFrame:CGRectMake(Boardseperad, 59, APPW - 2*Boardseperad, 1)];
    cellline.backgroundColor = gradcolor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubviews:nameLabel,phone,time,wechat,self.iconV,cellline,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{}
-(NSArray *)observableKeypaths{
    return nil;
}
-(void)setDataWithPerson:(Coredata*)person{
    nameLabel.text = [NSString stringWithFormat:@"姓名:%@",person.name];
    phone.text = person.phone;
    wechat.text = person.wechart;
    time.text = person.time;
    UIImage *icon = [NSKeyedUnarchiver unarchiveObjectWithData:person.icon];
    self.iconV.image = icon;
}
@end
@interface DiscoveryViewController (){
    UISearchBar *searchBar;
}
@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, TopHeight, APPW-110, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = searchBar;
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110)];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:self.items];
    self.tableView.editingStyle = UITableViewCellEditingStyleDelete;
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:YES headH:0 footH:0 rowH:60 sectionN:1 rowN:self.items.count cellName:@"DiscoveryCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self readData];
    self.tableView.dataArray = [NSMutableArray arrayWithArray:self.items];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:YES canEdit:YES headH:0 footH:0 rowH:60 sectionN:1 rowN:self.items.count cellName:@"DiscoveryCell"];
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation=(UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {//翻转为竖屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH-110);
        [self.tableView reloadData];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {//翻转为横屏时
        self.tableView.frame = CGRectMake(0, 0, APPW, APPH-110);
        [self.tableView reloadData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [DiscoveryCell getInstance];
    }
    [cell setDataWithPerson:self.items[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self.tabBarController.viewControllers objectAtIndex:1]popToRootViewControllerAnimated:NO];
    HomeNavigationController *v = [self.tabBarController.viewControllers objectAtIndex:1];
    ServiceViewController *vv = (ServiceViewController*)v.topViewController; // v.viewControllers[0];
    vv.person =self.items[indexPath.row];
    vv.baoliu = NO;
     self.tabBarController.selectedIndex = 1;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Coredata"];
        AppDelegate *dele =[AppDelegate Share];
        NSEntityDescription * entity = [NSEntityDescription entityForName:@"Coredata" inManagedObjectContext:dele.managedObjectContext];
        [request setEntity:entity];
        Coredata *person = self.tableView.dataArray[indexPath.row];
        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"name = %@",person.name];
        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"phone = %@",person.phone];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1,p2]];
        [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
        NSArray *persons = [dele.managedObjectContext executeFetchRequest:request error:nil];
        if ([persons count] > 0) {
            Coredata * lastPerson = [persons lastObject];
            [dele.managedObjectContext deleteObject:lastPerson];
            [dele saveContext];
        }
        [self.tableView.dataArray removeObjectAtIndex:indexPath.row];
        self.tableView.rowN = self.tableView.dataArray.count;
        [tableView reloadData];
    }];
    // 2 添加一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        [self.tableView.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    topRowAction.backgroundColor = gradcolor;
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction,topRowAction];
}
#pragma mark others
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length==0) {
        [self readData];
        self.tableView.rowN = self.items.count;
        [self.tableView reloadData];
        return;
    }
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coredata"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ OR phone CONTAINS %@ OR wechart CONTAINS %@ OR time MATCHES %@ OR time CONTAINS %@", searchText, searchText,searchText,searchText,searchText];
    NSError *error = nil;
    NSArray *b = [del.managedObjectContext executeFetchRequest:request error:&error];
    self.items = [[NSMutableArray alloc] initWithArray:b];
    DLog(@"%@\n\n%ld",self.items,self.items.count);
    self.tableView.rowN = self.items.count;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBa{
    [searchBar resignFirstResponder];
}

@end
