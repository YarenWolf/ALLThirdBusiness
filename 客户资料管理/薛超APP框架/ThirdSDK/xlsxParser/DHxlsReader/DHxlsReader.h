/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *此文件的一部分，dhlibxls --允许代码读取Excel文件（TM）。
 *重新分配和使用源和二进制形式
 *允许提供下列条件：
 * 1。以源代码形式的发布必须保留上述版权声明，此列表条件及以下免责声明。
 * 2。以二进制形式重新分配必须保留上述版权声明，此列表在文件和/或其他材料的条件和以下免责声明提供分配。
 * 3。只有ObjectiveC代码在本授权下独立的许可证可以申请libxls源。阅读文件和文件的libxls您下载的源头早。*/

#import "DHcell.h"
#import <Foundation/Foundation.h>
enum {DHWorkSheetNotFound = UINT32_MAX};
@interface DHxlsReader : NSObject
+ (DHxlsReader *)xlsReaderWithPath:(NSString *)filePath;
+ (DHxlsReader *)xlsReaderFromFile:(NSString *)filePath DEPRECATED_ATTRIBUTE; // The name of this method doesn’t match conventions.
- (NSString *)libaryVersion;
// Sheet Information
- (uint32_t)numberOfSheets;
- (NSString *)sheetNameAtIndex:(uint32_t)index;
- (uint16_t)rowsForSheetAtIndex:(uint32_t)idx;
- (BOOL)isSheetVisibleAtIndex:(NSUInteger)index;
- (uint16_t)numberOfRowsInSheet:(uint32_t)sheetIndex;
- (uint16_t)numberOfColsInSheet:(uint32_t)sheetIndex;
// Random Access
- (DHcell *)cellInWorkSheetIndex:(uint32_t)sheetNum row:(uint16_t)row col:(uint16_t)col;		// uses 1 based indexing!
- (DHcell *)cellInWorkSheetIndex:(uint32_t)sheetNum row:(uint16_t)row colStr:(char *)col;		// "A"...."Z" "AA"..."ZZ"
// Iterate through all cells
- (void)startIterator:(uint32_t)sheetNum;
- (DHcell *)nextCell;
// excell Information
- (NSString *)appName;
- (NSString *)author;
- (NSString *)category;
- (NSString *)comment;
- (NSString *)company;
- (NSString *)keywords;
- (NSString *)lastAuthor;
- (NSString *)manager;
- (NSString *)subject;
- (NSString *)title;

@end
