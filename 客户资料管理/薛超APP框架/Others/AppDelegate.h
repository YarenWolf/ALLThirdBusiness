//
//  AppDelegate.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/6.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}
@property (nonatomic,assign)NSInteger times;//进入业务查询的次数
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSArray *customs;
@property (nonatomic,strong) NSMutableArray *lineCustoms;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+ (AppDelegate *)Share;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)readData;
-(void)readCustomData;
@end

