//
//  ActionSheet.h
//  GM_iOS_Outfits
//
//  Created by wzitech on 13-9-23.
//  Copyright (c) 2013年 wzitech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetCallbackBlock)(NSInteger buttonIndex);

@interface ActionSheet : UIActionSheet

-(void)showInView:(UIView *)view callbackBlock:(ActionSheetCallbackBlock) block;

@end
