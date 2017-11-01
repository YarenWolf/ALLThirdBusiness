
#import "DHcell-Private.h"
#if ! __has_feature(objc_arc)
#error THIS CODE MUST BE COMPILED WITH ARC ENABLED!
#endif
@implementation DHcell{
	char colString[3];
}
@synthesize row;
@synthesize type;
@dynamic colStr;
@synthesize col;
@synthesize str;
@synthesize val;

+ (DHcell *)blankCell{
	return [DHcell new];
}
- (char *)colStr{
	return colString;
}
- (void)setColStr:(char *)colS{
	colString[0] = colS[0];
	colString[1] = colS[1];
	colString[2] = '\0';
}

- (void)show{
	NSLog(@"%@", [self dump]);
}

- (NSString *)dump{
	NSMutableString *s = [NSMutableString stringWithCapacity:128];
	const char *name;
	switch(type) {
	case cellBlank:	name = "空";		break;
	case cellString:name = "字符串";	break;
	case cellInteger:name = "整数";	break;
	case cellFloat:	name = "单精度数";break;
	case cellBool:	name = "布尔类型";break;
	case cellError:	name = "错误单元格";break;
	default:		name = "未知单元格";break;
	}
	[s appendFormat:@"单元格类型: %s row=%u col=%s/%u 内容:%@  值:%@\n", name, row, colString, col,str,[val longValue]];
	return s;
}

@end
