//  TLEmojiGroup.h
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TLEmojiType) {
    TLEmojiTypeEmoji,
    TLEmojiTypeFavorite,
    TLEmojiTypeFace,
    TLEmojiTypeImage,
    TLEmojiTypeImageWithTitle,
    TLEmojiTypeOther,
};typedef NS_ENUM(NSInteger, TLEmojiGroupStatus) {
    TLEmojiGroupStatusUnDownload,
    TLEmojiGroupStatusDownloaded,
    TLEmojiGroupStatusDownloading,
};
@interface TLEmoji : NSObject
@property (nonatomic, assign) TLEmojiType type;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *emojiID;
@property (nonatomic, strong) NSString *emojiName;
@property (nonatomic, strong) NSString *emojiPath;
@property (nonatomic, strong) NSString *emojiURL;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic,strong)NSString *realPath;
+(instancetype)replaceKeyFromDictionary:(NSDictionary*)dict;
+(NSString*)emojiPathWithGroupID:(NSString*)groupid;
@end
@interface TLEmojiGroup : NSObject
@property (nonatomic, assign) TLEmojiType type;
/// 基本信息
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *groupIconPath;
@property (nonatomic, strong) NSString *groupIconURL;
/// Banner用
@property (nonatomic, strong) NSString *bannerID;
@property (nonatomic, strong) NSString *bannerURL;
/// 总数
@property (nonatomic, assign) NSUInteger count;
/// 详细信息
@property (nonatomic, strong) NSString *groupInfo;
@property (nonatomic, strong) NSString *groupDetailInfo;
@property (nonatomic, strong) NSDate *date;
/// 作者
@property (nonatomic, strong) NSString *authName;
@property (nonatomic, strong) NSString *authID;
@property (nonatomic, strong) NSMutableArray *data;///本地信息
#pragma mark - 展示用
@property (nonatomic, assign) NSUInteger pageItemCount;/// 每页个数
@property (nonatomic, assign) NSUInteger pageNumber;/// 页数
@property (nonatomic, assign) NSUInteger rowNumber;/// 行数
@property (nonatomic, assign) NSUInteger colNumber;/// 列数

@property (nonatomic, assign) TLEmojiGroupStatus status;
- (id)objectAtIndex:(NSUInteger)index;
+(instancetype)replaceKeyFromDictionary:(NSDictionary*)dict;
@end
