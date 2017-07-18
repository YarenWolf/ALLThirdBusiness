//
//  RootViewController.m
//  MSCDemo
//
//  Created by iflytek on 13-6-6.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "RootViewController.h"
#import "ISRViewController.h"
#import "ASRViewController.h"
#import "ABNFViewController.h"
#import "TTSViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation RootViewController
- (id) init
{
    self = [super init];
    _functions = [[NSArray alloc]initWithObjects:@"语音转写",@"命令词识别",@"语法识别",@"语音合成",nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"讯飞语音示例";
    //int top = Margin;
    
    //adjust the UI for iOS 7
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
     if ( IOS7_OR_LATER )
     {
         self.edgesForExtendedLayout = UIRectEdgeNone;
         self.extendedLayoutIncludesOpaqueBars = NO;
         self.modalPresentationCapturesStatusBarAppearance = NO;
         self.navigationController.navigationBar.translucent = NO;
     }
    #endif
    
    UITextView* thumbView = [[UITextView alloc] initWithFrame:CGRectMake(Margin, Margin, self.view.frame.size.width-Margin*2, 170)];
    thumbView.text =@"      本示例为讯飞语音iPhone平台开发者提供语音转写，语音识别（包括命令词和语法文件识别）和语音合成代码样例，旨在让用户能够依据该示例快速开发出基于语音接口的应用程序。";
    //thumbView.numberOfLines = 0;
    thumbView.layer.borderWidth = 1;
    thumbView.layer.cornerRadius = 8;
    [self.view addSubview:thumbView];
    thumbView.editable = NO;
    _thumbView = thumbView;
    
    thumbView.font = [UIFont systemFontOfSize:17.0f];
    
    [thumbView sizeToFit];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, thumbView.frame.origin.y + thumbView.frame.size.height+Margin , self.view.frame.size.width, self.view.frame.size.height- thumbView.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    _popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 300, 0, 0)];
    
    
    [thumbView release];
    [tableView release];
    return self;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_functions objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell ;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ISRViewController * isr = [[ISRViewController alloc]init];
            [self.navigationController pushViewController:isr animated:YES];
            [isr release];
            break;
        }
        case 1:
        {
            ASRViewController * asr = [[ASRViewController alloc]init];
            [self.navigationController pushViewController:asr animated:YES];
            [asr release];
            break;
        }
        case 2:
        {
            ABNFViewController * abnf = [[ABNFViewController alloc]init];
            [self.navigationController pushViewController:abnf animated:YES];
            [abnf release];
            break;
        }
        case 3:
        {
            TTSViewController * tts = [[TTSViewController alloc]init];
            [self.navigationController pushViewController:tts animated:YES];
            [tts release];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

}


-(void) dealloc
{
    [_popUpView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //[_functions release];
   // _functions = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
