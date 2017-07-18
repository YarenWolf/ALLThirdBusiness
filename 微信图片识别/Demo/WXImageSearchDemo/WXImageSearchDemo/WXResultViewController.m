//
//  WXResultViewController.m
//  WXImageSearchDemo
//
//  Created by 宫亚东 on 13-12-31.
//  Copyright (c) 2013年 Tencent Research. All rights reserved.
//

#import "WXResultViewController.h"
#import "WXImageSearch.h"

@interface WXResultViewController ()<WXImageSearchDelegate>

@end

@implementation WXResultViewController
{
    UIImageView *_imageView;
    UILabel *_resultLabel;
    UITextView *_testView;
    
    UILabel *_picDescLabel;
    UILabel *_md5Label;
    
}
- (void)dealloc
{
    [WXImageSearch releaseImageSearch];
    [_imageView release];
    [_resultLabel release];
    [_picDescLabel release];
    [_md5Label release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 120, 120)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 30)];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.font = [UIFont systemFontOfSize:20];
        _resultLabel.textColor=[UIColor blackColor];
        _resultLabel.text = @"识别中";
        

        
        _md5Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 310, 20)];
        _md5Label.backgroundColor = [UIColor clearColor];
        _md5Label.textColor = [UIColor blackColor];
        _md5Label.textAlignment = NSTextAlignmentLeft;
        _md5Label.font = [UIFont systemFontOfSize:15];
        _md5Label.text = @"MD5:";
        
        _picDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 310, 20)];
        _picDescLabel.backgroundColor = [UIColor clearColor];
        _picDescLabel.textColor = [UIColor blackColor];
        _picDescLabel.textAlignment = NSTextAlignmentLeft;
        _picDescLabel.text = @"picDesc:";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
	// Do any additional setup after loading the view.
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView addSubview:_imageView];
    [topView addSubview:_resultLabel];
    [topView release];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 148, 320, 2)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
    [lineView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 300, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"识别结果";
    [self.view addSubview:label];
    [label release];
    
    [self.view addSubview:_picDescLabel];
    [self.view addSubview:_md5Label];

//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(100, 300, 120, 30);
//    [btn setTitle:@"返回启动页" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];

}
- (void)addTestStr:(NSString *)str{
    _testView.text =[NSString stringWithFormat:@"%@%@\n",_testView.text,str];
    NSRange range = NSMakeRange(_testView.text.length, 0);
    [_testView scrollRangeToVisible:range];
}

- (void)goback{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)sendImage:(UIImage *)image{
    
    [[WXImageSearch sharedImageSearch] setDelegate:self];
    [[WXImageSearch sharedImageSearch] setAppID:@"wxbe96cb06cc4fa1c9"];
    //开始进行识别
    [[WXImageSearch sharedImageSearch] startWithImage:image];
    
    static int k = 1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSData *data = UIImageJPEGRepresentation(image, 0);
    [data writeToFile:[NSString stringWithFormat:@"%@/%2d_full.jpg",docDir,k] atomically:YES];
    
    
    double bl = image.size.width * image.size.height /400 /400;
    if (bl>1) {
        //压缩？
        bl = sqrt(bl);
        CGSize size = CGSizeMake(image.size.width/bl, image.size.height/bl);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0,size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    data = UIImageJPEGRepresentation(image, 0);
    [data writeToFile:[NSString stringWithFormat:@"%@/%2d_00.jpg",docDir,k] atomically:YES];
    data = UIImageJPEGRepresentation(image, 0.1);
    [data writeToFile:[NSString stringWithFormat:@"%@/%2d_01.jpg",docDir,k] atomically:YES];
    data = UIImageJPEGRepresentation(image, 0.2);
    [data writeToFile:[NSString stringWithFormat:@"%@/%2d_02.jpg",docDir,k] atomically:YES];
    data = UIImageJPEGRepresentation(image, 0.5);
    [data writeToFile:[NSString stringWithFormat:@"%@/%2d_05.jpg",docDir,k] atomically:YES];
    data = UIImageJPEGRepresentation(image, 1);
    [data writeToFile:[NSString stringWithFormat:@"%@/%2d_10.jpg",docDir,k] atomically:YES];
    k++;
}
- (void)imageSearchResultArray:(NSArray *)resultArray{
    if (resultArray) {
        NSLog(@"resultArray.count=%d", (int)resultArray.count);
        WXImageSearchResult *result = [resultArray objectAtIndex:0];
        _resultLabel.text = @"";// @"识别成功";
        [self.navigationItem setTitle:@"识别成功"];
        _picDescLabel.text = [NSString stringWithFormat:@"picDesc:%@", result.picDesc];
        _md5Label.text = [NSString stringWithFormat:@"MD5:%@",result.md5];
        [self performSelectorInBackground:@selector(setImageUrl:) withObject:result.url];
    } else {
        _resultLabel.text = @"未找到对应图片";
        [self.navigationItem setTitle:@"识别失败"];
    }
}

- (void)setImageUrl:(NSString *)url{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [self performSelectorOnMainThread:@selector(changeImage:) withObject:image waitUntilDone:NO];
}
- (void)changeImage:(UIImage *)image{
    _imageView.image = image;
}

- (void)imageSearchMakeError:(NSInteger)error{
    _resultLabel.text = [NSString stringWithFormat:@"errorCode:%d",(int)error];
    [self.navigationItem setTitle:@"识别失败"];
}
- (void)imageSearchDidCancel{
    _resultLabel.text = @"已取消";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
