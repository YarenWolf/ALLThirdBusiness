//
//  TLEmojiBaseCell.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/9.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLEmojiBaseCell.h"

@implementation TLEmojiBaseCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _bgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setCornerRadius:5.0f];
        [self.contentView addSubview:self.bgView];
    }
    return self;
}

- (void)setShowHighlightImage:(BOOL)showHighlightImage{
    if (showHighlightImage) {
        [self.bgView setImage:self.highlightImage];
    }else {
        [self.bgView setImage:nil];
    }
}

@end
