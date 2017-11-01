//
//  AppDelegate.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "AppDelegate.h"
#import "Coredata.h"
#import "FirstViewController.h"
#import "BNCoreServices.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#define NAVI_BUNDLE_ID @"com.isolar88.SalesBuilding"  //sdk自测bundle ID
#define NAVI_APP_KEY   @"jEagWVqklzb9iagdGEFQgV5QYN53aDeZ"  //sdk自测APP KEY
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//#import <ShareSDK/ShareSDK.h>
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//#import <TencentOpenAPI/TencentOAuth.h>//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/QQApiInterface.h>
//#import "WXApi.h"//微信SDK头文件//以下是腾讯SDK的依赖库：//libsqlite3.dylib
//#import "WeiboSDK.h"//新浪微博SDK头文件//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//#import "APOpenAPI.h"//支付宝SDK
//#import "APService.h"
//#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate (){//<WXApiDelegate,UIAlertViewDelegate>{
    NSMutableDictionary *userdict;
      NSMutableArray *items;
}
@end
@implementation AppDelegate
+ (AppDelegate *)Share{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Utility Share] readUserInfoFromDefault];
    [self createjpush:launchOptions];
    [[Utility Share]getCurrentLanguage];
//    [[Utility Share]upDataVersion];
    //检查初次使用标识
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"firstUse"] != YES) {
        [prefs setBool:YES forKey:@"firstUse"];
        [prefs synchronize];
        [self readData];
        [[Utility Share]showStartTransitionView];
    }else{
        [[Utility Share]hiddenStartTransitionView];
    }
    //数据操作提交并检查错误
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"创建或加载数据库的时候失败: %@", [error domain]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{  });
    //    [WXApi registerApp:@"wx3ea1e6ebce6a1838" withDescription:@"demo 2.0"];
    [[Utility Share]loadUserLocation];


    [self initshardSDK];
    [self chushihua];
    return YES;
}
-(void)initshardSDK{
//    [ShareSDK registerApp:@"10704ee49bab2"];
//    //新浪微博
//    [ShareSDK connectSinaWeiboWithAppKey:@"3338320077"
//                               appSecret:@"c8d9a43d9312189f6cecc89f5d8086e6"
//                             redirectUri:@"http://www.baidu.com"
//                             weiboSDKCls:[WeiboSDK class]];
//    //微信登陆的时候需要初始化
//    [ShareSDK connectWeChatWithAppId:@"wx3ea1e6ebce6a1838"
//                           appSecret:@"d4624c36b6795d1d99dcf0547af5443d"
//                           wechatCls:[WXApi class]];
//    [WXApi registerApp:@"wx3ea1e6ebce6a1838" withDescription:@"demo 2.0"];
//    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"571351833"
//                               appSecret:@"fb98e3d5efd5b958d29348eafae566a7"
//                             redirectUri:@"https://www.baidu.com"];
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"a8eb86c84ef0"
//                                appSecret:@"fb98e3d5efd5b958d29348eafae566a7"
//                              redirectUri:@"https://www.baidu.com"
//                              weiboSDKCls:[WeiboSDK class]];
//    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"];
//    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
//    [ShareSDK connectQZoneWithAppKey:@"1104787027"
//                           appSecret:@"Lrewt7n2neNt5Wa0"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    //添加QQ应用  注册网址   http://mobile.qq.com/api/
//    [ShareSDK connectQQWithQZoneAppKey:@"QQ41d9b653"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    [ShareSDK connectQQWithQZoneAppKey:@"QQ41dd4913"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    [ShareSDK importQQClass:[QQApiInterface class]
//            tencentOAuthCls:[TencentOAuth class]];
//    //QQ空间
//    [ShareSDK connectQZoneWithAppKey:@"1105021203"
//                           appSecret:@"4suavakVdRqawzLI"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
}

-(void)chushihua{
//    [[Utility Share] clearUserInfoInDefault];
//    [NetEngine createPostAction:@"index/home" withParams:[[NSDictionary alloc] initWithObjectsAndKeys:@"en",@"type", nil] onCompletion:^(id resData, BOOL isCache) {
//        if ([[resData valueForJSONStrKey:@"status"] isEqualToString:@"200"]) {
//            [[Utility Share] setUserBannerPic:[[[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"] valueForKey:@"pic"]];
//            [[Utility Share] saveUserInfoToDefault];
//            [[Utility Share] readUserInfoFromDefault];
//            if ([[Utility Share] userBannerPic] != nil && [[Utility Share] userBannerPic].count > 0 ) {
//                [[Utility Share] showStartGuideTransitionView];
//            }else {
//                [[Utility Share] hiddenStartTransitionView];
//            }
//        }else{
//            [SVProgressHUDX showErrorWithStatus:[resData valueForJSONKey:@"info"]];
//        }
//    }];
//    NSLog(@"------%ld",[[Utility Share] userBannerPic].count);
    // 要使用百度地图，请先启动BaiduMapManager
    self.times = 0;
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:NAVI_APP_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [BNCoreServices_Instance initServices:NAVI_APP_KEY];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
}

-(void)createjpush:(NSDictionary *)launchOptions{
//    // Required
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound |UIUserNotificationTypeAlert)categories:nil];
//    } else {
//        //categories 必须为nil
//        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)categories:nil];
//    }
//    // Required
//    [APService setupWithOption:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[Utility Share]setIsActivate:NO];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[Utility Share] setIsActivate:YES];
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application {
     [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [self saveContext];
}

#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    //    if ([url.host isEqualToString:@"pay"]){
//    //        return   [WXApi handleOpenURL:url delegate:self];
//    //    }else{
//    //        return [ShareSDK handleOpenURL:url wxDelegate:self];
//    //    }
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            if ([[resultDic valueForJSONStrKey:@"resultStatus"] isEqualToString:@"9000"]){
//                [SVProgressHUD showImage:nil status:@"交易成功!"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"yes"];
//            }else{
//                [SVProgressHUD showImage:nil status:@"交易失败!"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"NO"];
//            }
//        }];
//        
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//             NSLog(@"result = %@",resultDic);
//             // NSString *resultStr = resultDic[@"result"];
//             if ([[resultDic valueForJSONStrKey:@"resultStatus"] isEqualToString:@"9000"]){
//                 [SVProgressHUD showImage:nil status:@"交易成功!"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"yes"];
//             }else{
//                 [SVProgressHUD showImage:nil status:@"交易失败!"];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"NO"];
//             }
//         }];
//        return YES;
//    }else if ([url.host isEqualToString:@"pay"]){
//        return   [WXApi handleOpenURL:url delegate:self];
//    }else{
//        return [ShareSDK handleOpenURL:url wxDelegate:self];
//    }
    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    DLog(@"application____%@",url.host);
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            //NSString *resultStr = resultDic[@"result"];
//            if ([[resultDic valueForJSONStrKey:@"resultStatus"] isEqualToString:@"9000"]){
//                [SVProgressHUD showImage:nil status:@"交易成功!"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"yes"];
//            }else{
//                [SVProgressHUD showImage:nil status:@"交易失败!"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"NO"];
//            }
//        }];
//        
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//             NSLog(@"result = %@",resultDic);
//             if ([[resultDic valueForJSONStrKey:@"resultStatus"] isEqualToString:@"9000"]){
//                 [SVProgressHUD showImage:nil status:@"交易成功!"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"yes"];
//             }else{
//                 [SVProgressHUD showImage:nil status:@"交易失败!"];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipaySDK_success" object:@"NO"];
//             }
//         }];
//        return YES;
//    }else if ([url.host isEqualToString:@"pay"]){
//        return   [WXApi handleOpenURL:url delegate:self];
//    }else{
//        return [ShareSDK handleOpenURL:url wxDelegate:self];
//    }
//    return YES;
//}
#pragma mark - jpushdelegate
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // Required
//    [APService registerDeviceToken:deviceToken];
//}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // Required
//    [APService handleRemoteNotification:userInfo];
//}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    if ([[Utility Share] isforeGround])[[NSNotificationCenter defaultCenter] postNotificationName:@"houtaitiaoguolai" object:nil userInfo:userInfo];
//    // IOS 7 Support Required
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//-(void)onResp:(BaseResp*)resp{
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//    NSString *strTitle;
//    NSString *paysuccess;
//    if([resp isKindOfClass:[SendMessageToWXResp class]]){
//        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//    }
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        strTitle = [NSString stringWithFormat:@"支付结果"];
//        switch (resp.errCode) {
//            case WXSuccess:strMsg = @"支付结果：成功！";
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPay" object:nil];
//                paysuccess = @"1";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                strMsg = @"支付成功";
//                break;
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                paysuccess = @"0";
//                NSLog(@"支付失败！，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                strMsg = @"支付失败！";
//                break;
//        }
//        userdict = [[NSMutableDictionary alloc]init];
//        [userdict setValue:paysuccess forKey:@"paytype"];
//        [userdict setValue:strMsg forKey:@"msg"];
//        [userdict setValue:strTitle forKey:@"title"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}
#pragma mark - alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payweixin" object:nil userInfo:userdict];
    }
}
-(void)readCustomData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customdata"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tname" ascending:NO]];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    DLog(@"%@", error);
    self.customs = [NSArray arrayWithArray:a];
}

- (void)readData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coredata"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    DLog(@"%@", error);
//    if (!a || ([a isKindOfClass:[NSArray class]] && [a count] <= 0)) {
//        // 添加数据到数据库
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@"txt"];
//            NSString *text = [NSString stringWithContentsOfFile:strPath encoding:NSUTF16StringEncoding error:nil];
//            NSArray *lineArr = [text componentsSeparatedByString:@"\n"];
//            AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//            NSEntityDescription *description = [NSEntityDescription entityForName:@"Coredata" inManagedObjectContext:del.managedObjectContext];
//            for (NSString *line in lineArr) {
//                NSArray *icons = [line componentsSeparatedByString:@"\t"];
//                Coredata *data = [[Coredata alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
//                data.name = icons[0];
////                data.time = icons[1];
//            }
//            [del saveContext];
//            //从数据库中读
//            NSError *error = nil;
//            NSArray *b = [del.managedObjectContext executeFetchRequest:request error:&error];
//            if (error) {
//                DLog(@"%@", error);
//            } else {
//                self.items = [NSArray arrayWithArray:b];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // [collectionView reloadData];
//                });
//            }
//        });
//    } else {
//        self.items = [NSArray arrayWithArray:a];
//        //        [collectionView reloadData];
//    }
    self.items = [NSArray arrayWithArray:a];
    //     删除所有数据
//    for (Coredata *postcode in a) {
//        [self.managedObjectContext deleteObject:postcode];
//    }[self saveContext];
}
#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.isolar88.__APP__" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) return _managedObjectModel;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Coredata" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) return _persistentStoreCoordinator;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Coredata.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"创建或加载数据库的时候出错";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"数据库初始化失败";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"未解决的错误  %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) return _managedObjectContext;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)return nil;
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
