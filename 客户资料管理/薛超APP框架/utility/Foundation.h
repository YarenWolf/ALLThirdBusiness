
#import "Foundation_defines.h"
#import "Foundation_API.h"
#ifdef DEBUG
 #define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
 #define ELog(err) {if(err) DLog(@"%@", err)}
#else
 #define DLog(...)
 #define ELog(err)
#endif
#define TopHeight         (Version7?64:44)
#define NavY              (Version7?20:0)
#define clearcolor        [UIColor clearColor]
#define gradcolor         RGBACOLOR(224, 225, 226, 1)
#define redcolor          RGBACOLOR(229, 59, 25, 1)
#define yellowcolor       [UIColor yellowColor]
#define whitecolor        RGBACOLOR(256, 256,256,1)
#define blacktextcolor    RGBACOLOR(33, 34, 35, 1)
#define gradtextcolor     RGBACOLOR(116, 117, 118, 1)
#define graycolor         [UIColor grayColor]
#define Boardseperad      10
#define fontTitle         Font(15)
#define fontnomal         Font(13)
#define fontSmallTitle    Font(14)
#define BoldFont(x)       [UIFont boldSystemFontOfSize:x]
#define Font(x)           [UIFont systemFontOfSize:x]
#define appVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Bundle version"]
#define Version7          ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define Version8          ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
#define NetEngine         [AFHTTPSessionManager manager]
#define HOMEPATH           NSHomeDirectory()//主页路径
#define documentPath      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]//Documents路径
#define cachesPath        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define tempPath           NSTemporaryDirectory()
#define WS(weakSelf)    __weak __typeof(self)weakSelf = self;
#define RGBCOLOR(r,g,b)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define APPW              [UIScreen mainScreen].bounds.size.width
#define APPH              [UIScreen mainScreen].bounds.size.height
#define ApplicationH      [UIScreen mainScreen].applicationFrame.size.height

#define W(obj)            (!obj?0:(obj).frame.size.width)
#define H(obj)            (!obj?0:(obj).frame.size.height)
#define X(obj)            (!obj?0:(obj).frame.origin.x)
#define Y(obj)            (!obj?0:(obj).frame.origin.y)
#define XW(obj)           (X(obj)+W(obj))
#define YH(obj)           (Y(obj)+H(obj))
#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)
#define S2N(x)            [NSNumber numberWithInt:[x intValue]]
#define I2N(x)            [NSNumber numberWithInt:x]
#define F2N(x)            [NSNumber numberWithFloat:x]
#define WDLogAllIvrs -(NSString *)description{return [self wkeyValues].description;}
/*******************我的网络资源文件*****************/
#define FileResource(s)   [[NSBundle mainBundle]pathForResource:s ofType:nil]
#define JSONWebResource(s) [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.isolar88.com/upload/xuechao/json/%@",s]]];
#define APPDelegate       [[UIApplication sharedApplication]delegate]
#define alertErrorTxt     @"服务器异常,请稍后再试"
