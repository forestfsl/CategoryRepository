//
//  AppDelegate+EaseMob.h
//  ksh3
//
//  Created by madao on 15/10/20.
//  Copyright © 2015年 jianminxian. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (EaseMob)

- (void)setupEaseMob:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)setupEaseMobRemoteNotifications:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)checkEaseLogin;
@end
