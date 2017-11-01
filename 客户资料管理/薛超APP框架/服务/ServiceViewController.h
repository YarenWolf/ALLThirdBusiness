//
//  ServiceViewController.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseFillTableViewController.h"
#import "Coredata.h"
@interface ServiceViewController : BaseFillTableViewController
@property(nonatomic,strong)Coredata *person;
@property(nonatomic,assign)BOOL baoliu;
@end
