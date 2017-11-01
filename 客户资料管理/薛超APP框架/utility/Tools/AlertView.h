//
//  AlertView.h
//  GM_iOS_Outfits
//
//  Created by wzitech on 13-9-9.
//  Copyright (c) 2013年 wzitech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewCallbackBlock)(NSInteger buttonIndex);

@interface AlertView : UIAlertView
-(void) show:(AlertViewCallbackBlock) block;
@end
