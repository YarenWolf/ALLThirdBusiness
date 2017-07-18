//
//  WXImageSearchViewController.m
//  WXImageSearchDemo
//
//  Created by 宫亚东 on 13-12-30.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "WXImageSearchViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>  //使用了其中(NSString *)kUTTypeImage
#import "WXResultViewController.h"
#import "WXErrorMsg.h"


@interface WXImageSearchViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation WXImageSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_320x568.png"]];
    iv.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:iv];
    [iv release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(60, 100, 200, 50);
    [btn setTitle:@"拍照识别" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.tag = 200;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(60, 200, 200, 50);
    [btn setTitle:@"选图识别" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.tag = 201;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.navigationItem setTitle:@"微信图像"];
    
}
- (void)clickBtn:(UIButton *)btn{
    
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    if (btn.tag == 200 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
    } else if (btn.tag == 201 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.allowsEditing = YES;
    } else {
        [WXErrorMsg showErrorMsg:@"无法完成操作" onView:self.view];
        return;
    }

    [self.navigationController presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = nil;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            //旋转的原图
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    WXResultViewController *rvc = [[[WXResultViewController alloc] init] autorelease];

    [self.navigationController pushViewController:rvc animated:NO];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [rvc sendImage:image];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
