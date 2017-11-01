

#import "NSObject+expanded.h"
#import "AppDelegate.h"
#import "Coredata.h"
@implementation NSObject (expanded)
-(AppDelegate *)getAPPDelegate{
    return [UIApplication sharedApplication].delegate;
}
- (void)performSelector:(SEL)aSelector withBool:(BOOL)aValue
{
    BOOL myBoolValue = aValue; // or NO
    
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
    [invocation setTarget: self];
    [invocation setSelector: aSelector];
    [invocation setArgument: &myBoolValue atIndex: 2];
    [invocation invoke];
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        [invocation setArgument:(__bridge void *)(object) atIndex:++i];
    }
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSUInteger length = [signature numberOfArguments];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    [invocation setArgument:&firstParameter atIndex:2];
    va_list arg_ptr;
    va_start(arg_ptr, firstParameter);
    for (NSUInteger i = 3; i < length; ++i) {
        void *parameter = va_arg(arg_ptr, void *);
        [invocation setArgument:&parameter atIndex:i];
    }
    va_end(arg_ptr);
    
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}
#pragma mark 操作数据库
-(void)addCoreData{
    Coredata *weixin =[NSEntityDescription insertNewObjectForEntityForName:@"Coredata" inManagedObjectContext:[self getAPPDelegate].managedObjectContext];
    weixin.name = @"王五";
    [[self getAPPDelegate] saveContext];
}
-(void)deleteCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Coredata"];
    NSArray *persons = [[self getAPPDelegate].managedObjectContext executeFetchRequest:request error:nil];
    for (Coredata *p in persons) {
        if ([p.name isEqualToString:@"王五"]) {
            [[self getAPPDelegate].managedObjectContext deleteObject:p];
            [[self getAPPDelegate] saveContext];
        }
    }
}
-(void)reviseCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Coredata"];
    NSArray *persons = [[self getAPPDelegate].managedObjectContext executeFetchRequest:request error:nil];
    for (Coredata *p in persons) {
        if ([p.name isEqualToString:@"王五"]) {
            p.name = @"赵四";
            [[self getAPPDelegate] saveContext];
        }
    }
}
-(void)searchCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Coredata"];
    NSArray *persons = [[self getAPPDelegate].managedObjectContext executeFetchRequest:request error:nil];
    for (Coredata *p in persons) {
        NSLog(@"%@",p.name);
    }
}
///将NSArray或者NSDictionary转化为NSString
-(NSString *)JSONString
{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        DLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)tojsonstring
{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        DLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)JSONString_l{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        DLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
