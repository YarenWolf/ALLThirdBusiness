//  TLExpressionChosenViewController.m
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import "TLExpressionChosenViewController.h"
#import "TLExpressionSearchViewController.h"
#import "MJRefresh.h"
#import "TLExpressionCell.h"
#import "TLExpressionDetailViewController.h"
#import "ComerView.h"
#import "NetEngine.h"
@interface TLExpressionChosenViewController () <UISearchBarDelegate,TLExpressionCellDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) TLExpressionSearchViewController *searchVC;
@end
@implementation TLExpressionChosenViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tableView setFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
     _searchVC = [[TLExpressionSearchViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchVC];
    [_searchController setSearchResultsUpdater:self.searchVC];
    [_searchController.searchBar setPlaceholder:@"搜索表情"];
    [_searchController.searchBar setDelegate:self.searchVC];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    [self.tableView setMj_footer:footer];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 120)];
    [headview addSubview:self.searchController.searchBar];
    ComerView *com = [[ComerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 80)];
    [com isuertime:YES];
    NSDictionary *dic = @{@"type":@"4"};
    [NetEngine createPostAction:GFB_information_getbanner withParams:dic onCompletion:^(id resData, BOOL isCache) {
        if ([resData[@"status"]integerValue] == 200) {
            NSArray *adViewArr = resData[@"data"][@"list"];
            if (adViewArr != nil && adViewArr.count > 0) {
                [com setimageview:adViewArr];
                [com settimedate:[NSDate date]];
                [com setSelectpageblock:^(NSInteger tag) {
                    TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
                    [detailVC setGroup:self.data[tag]];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }];
            }
        }
    }];
    [headview addSubview:com];
    self.tableView.tableHeaderView = headview;
    _proxy = [[TLExpressionProxy alloc] init];
    [self loadDataWithLoadingView:YES];
}
- (void)loadDataWithLoadingView:(BOOL)showLoadingView{
    if (showLoadingView) {[SVProgressHUD show];}
     kPageIndex = 1;
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionChosenListByPageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        kPageIndex ++;
        weakSelf.data = [[NSMutableArray alloc] init];
        DLog(@"%@",data);
        for (NSDictionary *dict in data) {
#pragma mark  优先使用本地表情prepare TO DO
            TLEmojiGroup *group = [TLEmojiGroup replaceKeyFromDictionary:dict];
            TLEmojiGroup *localEmojiGroup = nil;
            if (localEmojiGroup) {
                [self.data addObject:localEmojiGroup];
            }else {
                [self.data addObject:group];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
    [self.proxy requestExpressionChosenBannerSuccess:^(id data) {
        self.bannerData = data;
        [self.tableView reloadData];
    } failure:^(NSString *error) { 
    }];
}
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionChosenListByPageIndex:kPageIndex success:^(NSMutableArray *data) {
        [SVProgressHUD dismiss];
        if (data.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            kPageIndex ++;
            for (NSDictionary *dict in data) {     // 优先使用本地表情
                TLEmojiGroup *group = [TLEmojiGroup replaceKeyFromDictionary:dict];
                [self.data addObject:group];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSString *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - # Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionCell"];
    if (cell == nil) {
        cell = [[TLExpressionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLExpressionCell"];
    }
    TLEmojiGroup *group = self.data[indexPath.row];
    [cell setGroup:group];
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
        TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
        [detailVC setGroup:group];
        [self.parentViewController setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//MARK: TLExpressionCellDelegate
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group{
    group.status = TLEmojiGroupStatusDownloading;
    [self.proxy requestExpressionGroupDetailByGroupID:group.groupID pageIndex:1 success:^(id data) {
    
        
        group.data = data;
        dispatch_queue_t downloadQueue = dispatch_queue_create([group.groupName UTF8String], nil);
        dispatch_group_t downloadGroup = dispatch_group_create();
        for (int i = 0; i <= group.data.count; i++) {
            
            dispatch_group_async(downloadGroup, downloadQueue, ^{
                NSString *groupPath = [TLEmoji emojiPathWithGroupID:group.groupID];
                if(i==group.data.count){
                    group.path = groupPath;
                    NSString *ss = group.groupIconPath;
                    DLog(@"%@",ss);
                    NSData *data = [NSData dataWithContentsOfURL:TLURL(group.groupIconURL)];
                    [data writeToFile:ss atomically:YES];
                }else{
                    
                    TLEmoji *emoji = [TLEmoji replaceKeyFromDictionary:group.data[i]];
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:emoji.emojiURL]];
                    NSString *emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, emoji.emojiPath];
                    // 添加表情包，本地化表情包
                    [data writeToFile:emojiPath atomically:YES];
                }
            });
        }
        dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^(){
            group.status = TLEmojiGroupStatusDownloaded;
            [self.tableView reloadData];
        });
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"\"%@\" 下载失败: %@", group.groupName, error]];
    }];
}

@end
