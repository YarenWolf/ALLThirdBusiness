//
//  TLExpressionHelper.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import <Foundation/Foundation.h>
#import "TLEmojiGroup.h"
@interface TLExpressionHelper : NSObject
@property (nonatomic, strong) TLEmojiGroup *defaultSystemEmojiGroup;/// 默认系统Emoji
@property (nonatomic, strong) TLEmojiGroup *userPreferEmojiGroup;/// 用户收藏的表情
@property (nonatomic, strong) TLEmojiGroup *defaultFaceGroup;/// 默认表情（Face）
@property (nonatomic, strong) NSArray *userEmojiGroups;/// 用户表情组
+ (TLExpressionHelper *)sharedHelper;
/**
 *  根据groupID获取表情包
 */
- (TLEmojiGroup *)emojiGroupByID:(NSString *)groupID;
/**
 *  列表数据 — 我的表情
 */
- (NSMutableArray *)myExpressionListData;
/**
 *  添加表情包
 */
- (BOOL)addExpressionGroup:(TLEmojiGroup *)emojiGroup;
/**
 *  删除表情包
 */
- (BOOL)deleteExpressionGroupByID:(NSString *)groupID;
#pragma mark - 下载表情包
- (void)downloadExpressionsWithGroupInfo:(TLEmojiGroup *)group
                                progress:(void (^)(CGFloat progress))progress
                                 success:(void (^)(TLEmojiGroup *group))success
                                 failure:(void (^)(TLEmojiGroup *group, NSString *error))failure;


@end
