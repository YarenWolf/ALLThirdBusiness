//
//  TLEmojiItemCell.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLEmojiItemCell.h"
@interface TLEmojiItemCell ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation TLEmojiItemCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, H(self)-20, W(self)-20, 20)];
        _label.textAlignment = NSTextAlignmentCenter;
        [_label setFont:[UIFont systemFontOfSize:25.0f]];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setEmojiItem:(TLEmoji *)emojiItem{
    [super setEmojiItem:emojiItem];
    [self.bgView setImage:[UIImage imageNamed:[emojiItem realPath]]];
    [self.label setText:emojiItem.emojiName];
}




@end
