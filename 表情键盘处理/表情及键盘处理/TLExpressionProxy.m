//
//  TLExpressionProxy.m
//  TLChat
#import "TLExpressionProxy.h"
#import "TLEmojiGroup.h"
#import "AFNetworking.h"
#import "NetEngine.h"

#import "MJRefresh.h"
#import "TLEmojiGroup.h"
#define     IEXPRESSION_HOST_URL        @"http://123.57.155.230:8080/ibiaoqing/admin/"
#define     IEXPRESSION_NEW_URL         [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=%ld&status=Y&status1=B"]
#define     IEXPRESSION_BANNER_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"advertisement/getAll.do?status=on"]
#define     IEXPRESSION_PUBLIC_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=%ld&status=Y&status1=B&count=yes"]
#define     IEXPRESSION_SEARCH_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=1&status=Y&eName=%@&seach=yes"]
#define     IEXPRESSION_DETAIL_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/getByeId.do?pageNumber=%ld&eId=%@"]
@implementation TLExpressionProxy
- (void)requestExpressionChosenListByPageIndex:(NSInteger)pageIndex success:(void (^)(id data))success failure:(void (^)(NSString *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageNumber"];
    [dict setObject:@"Y" forKey:@"status"];
    [dict setObject:@"B" forKey:@"status1"];
    [self requestWithURL:[IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do"] parameters:dict Success:success failure:failure];
}
- (void)requestExpressionChosenBannerSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"on" forKey:@"status"];
    [self requestWithURL:[IEXPRESSION_HOST_URL stringByAppendingString:@"advertisement/getAll.do"] parameters:dict Success:success failure:failure];
}
- (void)requestExpressionPublicListByPageIndex:(NSInteger)pageIndex success:(void (^)(id data))success failure:(void (^)(NSString *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageNumber"];
    [dict setObject:@"Y" forKey:@"status"];
    [dict setObject:@"B" forKey:@"status1"];
    [dict setObject:@"yes" forKey:@"count"];
    [self requestWithURL:[IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do"] parameters:dict Success:success failure:failure];
}
- (void)requestExpressionSearchByKeyword:(NSString *)keyword success:(void (^)(id data))success failure:(void (^)(NSString *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"1" forKey:@"pageNumber"];
    [dict setObject:@"Y" forKey:@"status"];
    [dict setObject:[self urlEncodeWithString:keyword] forKey:@"eName"];
    [dict setObject:@"yes" forKey:@"seach"];
    [self requestWithURL:[IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do"] parameters:dict Success:success failure:failure];
}
- (void)requestExpressionGroupDetailByGroupID:(NSString *)groupID pageIndex:(NSInteger)pageIndex success:(void (^)(id data))success failure:(void (^)(NSString *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageNumber"];
    [dict setObject:groupID forKey:@"eId"];
    [self requestWithURL:[IEXPRESSION_HOST_URL stringByAppendingString:@"expre/getByeId.do"] parameters:dict Success:success failure:failure];
}
-(NSString*)urlEncodeWithString:(NSString*)keyword{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "]invertedSet];
    return [keyword stringByAddingPercentEncodingWithAllowedCharacters:set];
}
-(void)requestWithURL:(NSString*)url Success:(void (^)(id data))success failure:(void (^)(NSString *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedFailureReason);
    }];
}
-(void)requestWithURL:(NSString*)url parameters:(NSDictionary*)dict Success:(void (^)(id data))success failure:(void (^)(NSString *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSArray *a;
        if ([responseObject isKindOfClass:[NSString class]]) {
             a = [NSJSONSerialization JSONObjectWithData:[((NSString *)responseObject) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        } else if ([responseObject isKindOfClass:[NSData class]]) {
             a = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:nil];
        }
        if([a[0]isEqualToString:@"OK"]){
            NSMutableArray *b = [NSMutableArray arrayWithArray:a[2]];
            success(b);
        }else{
            failure([NSString stringWithFormat:@"%@",a]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedFailureReason);
    }];
    
}
#pragma mark others

@end
