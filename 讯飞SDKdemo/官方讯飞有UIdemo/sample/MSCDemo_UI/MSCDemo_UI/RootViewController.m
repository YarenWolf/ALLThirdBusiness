//
//  MainViewController.m
//  MSC
//
//  Created by iflytek on 13-4-7.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"讯飞语音演示";
        
        NSArray *ttsArray = [NSArray arrayWithObjects:@"语音合成", nil];
        NSArray *isrArray = [NSArray arrayWithObjects:@"普通文本转写",@"语法识别", nil];
        _dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:ttsArray,@"语音合成",isrArray,@"语音识别", nil];
//        _ttsTextViewController = [[TTSTextViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [_dictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[_dictionary objectForKey:@"语音合成"] count];
    }
    else {
        return [[_dictionary objectForKey:@"语音识别"] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"语音合成";
    }
    else if (section == 1) {
        return @"语音识别";
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.textLabel.text = [[_dictionary objectForKey:@"语音合成"] objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [[_dictionary objectForKey:@"语音识别"] objectAtIndex:indexPath.row];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSArray *tempArray = nil;
        if (indexPath.row == 0) {
            tempArray = [NSArray arrayWithObjects:@"sms",@"上传联系人",@"上传用户词表",nil];
            if (_smsViewController == nil) {
                _smsViewController = [[CustomViewController alloc] initWithStyle:UITableViewStyleGrouped array:tempArray];
            }
            [self.navigationController pushViewController:_smsViewController animated:YES];

        }
        else if (indexPath.row == 1) {
            tempArray = [NSArray arrayWithObjects:@"asr",@"上传命令词",@"上传语法文件",nil];
            if (_asrViewController == nil) {
                _asrViewController = [[CustomViewController alloc] initWithStyle:UITableViewStyleGrouped array:tempArray];
            }
            [self.navigationController pushViewController:_asrViewController animated:YES];
        }
            }
    if (indexPath.section == 0) {
        if (!_ttsTextViewController) {

            _ttsTextViewController = [[TTSTextViewController alloc] init];
        }

        [self.navigationController pushViewController:_ttsTextViewController animated:YES];
    }
}

- (void) dealloc
{
    [_dictionary release];
    [super dealloc];
}
@end
