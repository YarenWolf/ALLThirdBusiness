//
//  TLExpressionSearchViewController.m
//  Created by 李伯坤 on 16/4/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import "TLExpressionSearchViewController.h"
#import "TLExpressionDetailViewController.h"
#import "TLExpressionProxy.h"
#import "TLExpressionCell.h"
#import "UIBarButtonItem+Action.h"
@interface TLExpressionSearchViewController () <TLExpressionCellDelegate>
@property (nonatomic, strong) TLExpressionProxy *proxy;
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation TLExpressionSearchViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.data = [NSMutableArray arrayWithCapacity:10];
    _proxy = [[TLExpressionProxy alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
#pragma mark - # Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionCell"];
    if(!cell){
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
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:detailVC];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain actionBlick:^{
        [navC dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [detailVC.navigationItem setLeftBarButtonItem:closeButton];
    [self presentViewController:navC animated:YES completion:^{}];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keyword = searchBar.text;
    if (keyword.length > 0) {
        [SVProgressHUD show];
        [self.proxy requestExpressionSearchByKeyword:keyword success:^(NSArray *data) {
            for(NSDictionary *dict in data){
                TLEmojiGroup *group = [TLEmojiGroup replaceKeyFromDictionary:dict];
                [self.data addObject:group];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSString *error) {
            self.data = nil;
            [self.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
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
//MARK: UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

@end
