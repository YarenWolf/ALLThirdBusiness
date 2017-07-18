//
//  AllTheFileTableViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/12.
//  Copyright © 2016年 tarena. All rights reserved.
#import "AllTheFileTableViewController.h"
#import "AllTheFileData.h"
#import "TRMainTableViewController.h"
#import "UIView+Extension.h"
@interface AllTheFileTableViewController ()
@property(nonatomic,strong)NSArray *allData;
@property(nonatomic,strong)NSArray *allDescription;
@end

@implementation AllTheFileTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(NSArray *)allData{
    if (!_allData) {
        _allData=[AllTheFileData damoData];
        }
    return _allData;
}
-(NSArray *)allDescription{
    if (!_allDescription) {
        _allDescription=[AllTheFileData allDescription];
    }return _allDescription;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCell" forIndexPath:indexPath];
    cell.textLabel.text=self.allDescription[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:self.allData[indexPath.row] animated:YES];
    NSLog(@"%@:%@",self.allData[indexPath.row],self.allDescription[indexPath.row]);
}

@end
