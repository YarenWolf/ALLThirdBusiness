//
//  TLEmojiKeyboard.h
//  TLChat
//
//  Created by 李伯坤 on 16/2/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import <UIKit/UIKit.h>
#import "TLEmojiGroup.h"
@class TLEmojiKeyboard;
@protocol TLEmojiKeyboardDelegate <NSObject>
@optional
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didSelectedEmojiItem:(TLEmoji *)emoji;
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB selectedEmojiGroupType:(TLEmojiType)type;
- (void) chatKeyboardWillShow:(id)keyboard;
- (void) chatKeyboardDidShow:(id)keyboard;
- (void) chatKeyboardWillDismiss:(id)keyboard;
- (void) chatKeyboardDidDismiss:(id)keyboard;
- (void) chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height;
@end
@interface TLEmojiKeyboard : UIView
@property (nonatomic, assign) id<TLEmojiKeyboardDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *emojiGroupData;
@property (nonatomic, strong) TLEmojiGroup *curGroup;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic ,strong)UIScrollView *groupEmojiScrollView;//表情键盘下方表情库工具栏
@property (nonatomic ,strong)UIButton *sendButton;
+ (TLEmojiKeyboard *)keyboard;
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;
- (void)reset;
@end
