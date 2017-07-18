//
//  DownLoadViewController.h
//  音乐播放器
//
//  Created by ISD1510 on 16/1/11.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadViewController : UIViewController
-(id)initWithImageURL:(NSURL*)imageURL;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
