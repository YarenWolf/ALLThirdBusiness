//
//  UIControl+Addition.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/10.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "UIControl+Addition.h"

@implementation UIControl (Addition)
- (void)removeAllTargets {
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}
@end
