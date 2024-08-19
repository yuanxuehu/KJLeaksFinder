//
//  AppDelegate.m
//  KJLeaksFinder
//
//  Created by TigerHu on 2024/8/19.
//

#import "AppDelegate.h"
#import <AMLeaksFinder/AMLeaksFinder.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self autoCheckLeaksFinderTool];
    
    return YES;
}

- (void)autoCheckLeaksFinderTool
{
#ifdef DEBUG

    AMLeaksFinder.controllerWhitelistClassNameSet = [NSSet setWithObjects:@"WhitelistVC", nil];
    AMLeaksFinder.viewWhitelistClassNameSet = [NSSet setWithObjects:@"MyView", nil];
    // AMLeaksFinder.ignoreVCClassNameSet = [NSSet setWithObjects:@"PushHasLeakVC", nil];
    AMLeaksFinder.ignoreViewClassNameSet = [NSSet setWithObjects:@"IgnoreLeakView", nil];
    
    [AMLeaksFinder addLeakCallback:^(NSArray<AMMemoryLeakModel *> * _Nonnull controllerMemoryLeakModels, NSArray<AMViewMemoryLeakModel *> * _Nonnull viewMemoryLeakModels) {
         //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"泄漏回调 - VC 泄漏数量：%@ View 泄漏数量：%@", @(controllerMemoryLeakModels.count), @(viewMemoryLeakModels.count)]];
         [controllerMemoryLeakModels enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             UIViewController *vc = obj.memoryLeakDeallocModel.controller;
             if (vc != nil) {
                 NSMutableString *str = @"".mutableCopy;
                 [obj.vcPathModels enumerateObjectsUsingBlock:^(AMVCPathModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     [str appendFormat:@"%@(%@) -> \n", obj.vcName, NSStringFromSelector(obj.sel)];
                 }];
                 printf("\n%s", [NSString stringWithFormat:@"⚠️👇🏻\n控制器泄漏:%@ \n操作路径:\n%@⚠️👆🏻\n", vc, str].UTF8String);
             }
         }];
         
         [viewMemoryLeakModels enumerateObjectsUsingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             UIView *view = obj.viewMemoryLeakDeallocModel.view;
             if (view != nil) {
                 NSMutableString *str = @"".mutableCopy;
                 [obj.vcPathModels enumerateObjectsUsingBlock:^(AMVCPathModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     [str appendFormat:@"%@(%@) -> \n", obj.vcName, NSStringFromSelector(obj.sel)];
                 }];
                 printf("\n%s", [NSString stringWithFormat:@"⚠️👇🏻\n视图泄漏:%@ \n视图所在控制器 %@ \n操作路径:\n%@⚠️👆🏻\n", view, obj.vcName, str].UTF8String);
             }
         }];
     }];
     
     [AMLeaksFinder addVCPathChangedCallback:^(NSArray<AMVCPathModel *> * _Nonnull all, AMVCPathModel * _Nonnull current) {
         printf("\n%s", [NSString stringWithFormat:@"控制器路径变化%@ %@ %@", current.vcName, NSStringFromSelector(current.sel), current.date].UTF8String);
     }];
    
#endif
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
