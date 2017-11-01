//
//  TLExpressionHelper.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import "TLExpressionHelper.h"
@interface TLExpressionHelper ()
//@property (nonatomic, strong) TLDBExpressionStore *store;
@end
@implementation TLExpressionHelper
+ (TLExpressionHelper *)sharedHelper{
    static TLExpressionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TLExpressionHelper alloc] init];
    });return helper;
}



- (BOOL)addExpressionGroup:(TLEmojiGroup *)emojiGroup{
//    BOOL ok = [self.store addExpressionGroup:emojiGroup forUid:[TLUserHelper sharedHelper].userID];
//    if (ok) {       // 通知表情键盘
//        [[TLEmojiKBHelper sharedKBHelper] updateEmojiGroupData];
//    }
    return YES;
}

- (BOOL)deleteExpressionGroupByID:(NSString *)groupID{
//    BOOL ok = [self.store deleteExpressionGroupByID:groupID forUid:[TLUserHelper sharedHelper].userID];
//    if (ok) {       // 通知表情键盘
//        [[TLEmojiKBHelper sharedKBHelper] updateEmojiGroupData];
//    }
    return YES;
}

- (TLEmojiGroup *)emojiGroupByID:(NSString *)groupID;{
    for (TLEmojiGroup *group in self.userEmojiGroups) {
        if ([group.groupID isEqualToString:groupID]) {
            return group;
        }
    }
    return nil;
}

- (void)downloadExpressionsWithGroupInfo:(TLEmojiGroup *)group
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(TLEmojiGroup *))success
                                 failure:(void (^)(TLEmojiGroup *, NSString *))failure{
    dispatch_queue_t downloadQueue = dispatch_queue_create([group.groupID UTF8String], nil);
    dispatch_group_t downloadGroup = dispatch_group_create();
    for (int i = 0; i <= group.data.count; i++) {
        dispatch_group_async(downloadGroup, downloadQueue, ^{
            group.path = [TLEmoji emojiPathWithGroupID:group.groupID];
            NSData *data;
            NSString *emojiPath;
            if(i==group.data.count){
                data = [NSData dataWithContentsOfURL:TLURL(group.groupIconURL)];
                emojiPath = group.groupIconPath;
            }else{
                TLEmoji *emoji = [TLEmoji replaceKeyFromDictionary:group.data[i]];
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:emoji.emojiURL]];
                emojiPath = [NSString stringWithFormat:@"%@%@", group.path, emoji.emojiPath];
            }
            [data writeToFile:emojiPath atomically:YES];
        });
    }
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        success(group);
    });
}



- (NSMutableArray *)myExpressionListData{
    NSMutableArray *myEmojiGroups = [NSMutableArray arrayWithCapacity:1];
    return myEmojiGroups;
}
- (NSArray *)userEmojiGroups{
    //    return [self.store expressionGroupsByUid:[TLUserHelper sharedHelper].userID];
    return nil;
}
- (TLEmojiGroup *)defaultFaceGroup{
    if (_defaultFaceGroup == nil) {
        _defaultFaceGroup = [[TLEmojiGroup alloc] init];
        _defaultFaceGroup.type = TLEmojiTypeFace;
        _defaultFaceGroup.groupIconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FaceEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
//        _defaultFaceGroup.data = [TLEmoji mj_objectArrayWithKeyValuesArray:data];
    }return _defaultFaceGroup;
}

- (TLEmojiGroup *)defaultSystemEmojiGroup{
    if (_defaultSystemEmojiGroup == nil) {
        _defaultSystemEmojiGroup = [[TLEmojiGroup alloc] init];
        _defaultSystemEmojiGroup.type = TLEmojiTypeEmoji;
        _defaultSystemEmojiGroup.groupIconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SystemEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
//        _defaultSystemEmojiGroup.data = [TLEmoji mj_objectArrayWithKeyValuesArray:data];
    }return _defaultSystemEmojiGroup;
}

@end
