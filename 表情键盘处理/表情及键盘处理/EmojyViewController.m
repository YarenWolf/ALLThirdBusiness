//
//  EmojyViewController.m
//  GuangFuBao
//
//  Created by 薛超 on 16/12/26.
//  Copyright © 2016年 55like. All rights reserved.
#import "EmojyViewController.h"
#import "TLExpressionProxy.h"
#import "TLEmojiGroup.h"
#import "TLEmojiKeyboard.h"
#import "TLExpressionHelper.h"
@interface EmojyViewController ()<TLEmojiKeyboardDelegate>
@property (nonatomic,strong)TLEmojiKeyboard *emojiKeyboard;
@end
@implementation EmojyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    TLExpressionProxy *proxy = [[TLExpressionProxy alloc] init];
    TLEmojiGroup *group = [[TLEmojiGroup alloc] init];
    group.groupID = @"223";
    group.groupName = @"王锡玄";
    group.groupIconURL = @"http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=10482";
    group.groupInfo = @"王锡玄 萌娃 冷笑宝宝";
    group.type = TLEmojiTypeEmoji;
    group.colNumber = 1;
    group.rowNumber = 1;
    group.groupDetailInfo = @"韩国萌娃，冷笑宝宝王锡玄表情包";
    //    http://123.57.155.230:8080/ibiaoqing/admin/expre/getByeId.do?pageNumber=3&eId=242
    [proxy requestExpressionGroupDetailByGroupID:group.groupID pageIndex:1 success:^(id data) {
        DLog(@"%@",data);
        group.data = data;
        TLExpressionHelper *help = [TLExpressionHelper sharedHelper];
        [help downloadExpressionsWithGroupInfo:group progress:nil success:^(TLEmojiGroup *group) {
            [self createEmogyKeyBoardWithGroup:group];
        } failure:^(TLEmojiGroup *group, NSString *error) {}];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
//    [self pushController:[TLExpressionViewController class] withInfo:nil withTitle:@"表情测试"];
}
-(void)createEmogyKeyBoardWithGroup:(TLEmojiGroup*)emojigroup{
    _emojiKeyboard = [TLEmojiKeyboard keyboard];
    [_emojiKeyboard setDelegate:self];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    [array addObject:emojigroup];
     [self.emojiKeyboard setEmojiGroupData:array];
    [self.emojiKeyboard showInView:self.view withAnimation:YES];
  
    
    
}
@end
