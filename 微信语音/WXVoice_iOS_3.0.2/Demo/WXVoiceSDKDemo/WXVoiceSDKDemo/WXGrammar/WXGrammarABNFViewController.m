//
//  WXGrammarABNFViewController.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-1-23.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXGrammarABNFViewController.h"
@interface WXGrammarABNFViewController ()

@end

@implementation WXGrammarABNFViewController

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
}


- (NSInteger)grammarType{
    return GrammarTypeOfABNF;
}
- (NSString *)defaultGrammarWords{

    return @"#ABNF 1.0 UTF-8;\n"
    @"language zh-cn;\n"
    @"mode voice;\n"
    @"root $basicCmd;\n"
    @"public $basicCmd =[查询] $allnames [地区] 天气;\n"
    @"$allnames = (北京 | 上海 | 天津 | 广州 | 四川) ;";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
