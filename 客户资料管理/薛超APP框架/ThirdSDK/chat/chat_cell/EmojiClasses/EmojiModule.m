//
//  EmojiModule.m
//  YunDong55like
//
//  Created by junseek on 15-7-1.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "EmojiModule.h"

@implementation EmojiModule
+(id)Share{
    static EmojiModule* g_EmojiModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_EmojiModule = [[EmojiModule alloc] init];
    });
    return g_EmojiModule;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expressionImage_custom.plist"];
//        [[EmojiModule Share] setEmojiDic:[[NSDictionary alloc] initWithContentsOfFile:emojiFilePath]];
        self.EmojiDic=[[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
        
    }
    return self;
}

@end
