

#import <Foundation/Foundation.h>
typedef enum { cellBlank=0, cellString, cellInteger, cellFloat, cellBool, cellError, cellUnknown } contentsType;
@interface DHcell : NSObject
@property (nonatomic, assign, readonly) contentsType type;
@property (nonatomic, assign, readonly) uint16_t row;
@property (nonatomic, assign, readonly) char *colStr;		// "A" ... "Z", "AA"..."ZZZ"
@property (nonatomic, assign, readonly) uint16_t col;
@property (nonatomic, strong, readonly) NSString *str;		// typeof depends on contentsType
@property (nonatomic, strong, readonly) NSNumber *val;		// typeof depends on contentsType

+ (DHcell *)blankCell;
- (void)show;
- (NSString *)dump;

@end
