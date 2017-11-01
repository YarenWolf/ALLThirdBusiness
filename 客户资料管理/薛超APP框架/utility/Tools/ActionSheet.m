//
//  ActionSheet.m
//  GM_iOS_Outfits
//
//  Created by wzitech on 13-9-23.
//  Copyright (c) 2013年 wzitech. All rights reserved.
//

#import "ActionSheet.h"

@interface ActionSheet ()<UIActionSheetDelegate>
@property (nonatomic, copy) ActionSheetCallbackBlock callbackBlock;
@end
@implementation ActionSheet

-(void)showInView:(UIView *)view callbackBlock:(ActionSheetCallbackBlock) block {
    self.callbackBlock = block;
    if (_callbackBlock != NULL) {
        self.delegate = self;
    }
    [self showInView:view];
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (_callbackBlock != NULL) {
        _callbackBlock(buttonIndex);
    }
}

@end
