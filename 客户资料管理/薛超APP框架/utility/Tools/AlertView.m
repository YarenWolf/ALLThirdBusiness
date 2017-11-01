//
//  AlertView.m
//  GM_iOS_Outfits
//
//  Created by wzitech on 13-9-9.
//  Copyright (c) 2013年 wzitech. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()<UIAlertViewDelegate>
@property (nonatomic, copy) AlertViewCallbackBlock callbackBlock;
@end
@implementation AlertView
-(void)show:(AlertViewCallbackBlock)block {
    self.callbackBlock = block;
    if (_callbackBlock != NULL) {
        self.delegate = self;
    }
    [self show];
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (_callbackBlock != NULL) {
        _callbackBlock(buttonIndex);
        self.callbackBlock = NULL;
    }
}
@end
