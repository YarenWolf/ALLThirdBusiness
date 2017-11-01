//
//  TLEmojiGroup.m
#import "TLEmojiGroup.h"
@implementation TLEmoji
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"groupID" : @"eId",
             @"emojiID" : @"pId",
             @"emojiURL" : @"Url",
             @"emojiName" : @"credentialName",
             @"emojiPath" : @"imageFile",
             @"size" : @"size",
             };
}

+(instancetype)replaceKeyFromDictionary:(NSDictionary*)dict{
    NSDictionary *d = [self replacedKeyFromPropertyName];
    TLEmoji *sf = [[TLEmoji alloc]init];
    [d enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [sf setValue:dict[obj] forKey:key];
    }];
    return sf;
}
- (NSString *)emojiPath{
    if (_emojiPath == nil) {
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [NSString stringWithFormat:@"%@/Expression/%@/", document, self.groupID];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }_emojiPath = [NSString stringWithFormat:@"%@%@", path, self.emojiPath];
    }return _emojiPath;
}
-(NSString *)realPath{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/Expression/%@/%@", document, self.groupID,self.emojiPath];
    return path;
}
+(NSString*)emojiPathWithGroupID:(NSString *)groupid{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/Expression/%@/", document, groupid];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
@end
@implementation TLEmojiGroup
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"groupID" : @"eId",
             @"groupIconURL" : @"coverUrl",
             @"groupName" : @"eName",
             @"groupInfo" : @"memo",
             @"groupDetailInfo" : @"memo1",
             @"count" : @"picCount",
             
             @"bannerID" : @"aId",
             @"bannerURL" : @"URL",
             @"type":@"statusId"
             };
}
+(instancetype)replaceKeyFromDictionary:(NSDictionary*)dict{
    NSDictionary *d = [self replacedKeyFromPropertyName];
    TLEmojiGroup *sf = [[TLEmojiGroup alloc]init];
    [d enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [sf setValue:dict[obj] forKey:key];
    }];
    return sf;
}
- (id)init{
    if (self = [super init]) {
        [self setType:TLEmojiTypeImageWithTitle];
    }return self;
}

- (void)setType:(TLEmojiType)type{
    _type = type;
    switch (type) {
        case TLEmojiTypeOther:return;
        case TLEmojiTypeFace:
        case TLEmojiTypeEmoji:self.rowNumber = 3;self.colNumber = 7;break;
        case TLEmojiTypeImage:
        case TLEmojiTypeFavorite:
        case TLEmojiTypeImageWithTitle:self.rowNumber = 2;self.colNumber = 4;break;
        default:break;
    }
    self.pageItemCount = self.rowNumber * self.colNumber;
    self.pageNumber = self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}
- (void)setData:(NSMutableArray *)data{
    _data = data;
    self.count = data.count;
    self.pageItemCount = self.rowNumber * self.colNumber;
    self.pageNumber = self.count / self.pageItemCount + (self.count % self.pageItemCount == 0 ? 0 : 1);
}

- (id)objectAtIndex:(NSUInteger)index{
    return [self.data objectAtIndex:index];
}

- (NSString *)path{
    if (_path == nil && self.groupID != nil) {
        _path = [TLEmoji emojiPathWithGroupID:self.groupID];
    }return _path;
}
- (NSString *)groupIconPath{
    if (_groupIconPath == nil && self.path != nil) {
        _groupIconPath = [NSString stringWithFormat:@"%@icon_%@", self.path, self.groupID];
    }return _groupIconPath;
}

@end
