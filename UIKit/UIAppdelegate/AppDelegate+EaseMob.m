//
//  AppDelegate+EaseMob.m
//  ksh3
//
//  Created by madao on 15/10/20.
//  Copyright © 2015年 jianminxian. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "EaseMobUtil.h"
#import "EaseSDKHelper.h"

@implementation AppDelegate (EaseMob)

- (void)setupEaseMob:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //环信
    NSDictionary *config = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",kSDKConfigEnableConsoleLogger, nil];
//#if DEBUG
    //[[EaseMob sharedInstance] registerSDKWithAppKey:kVendorEaseMobKeyString apnsCertName:kVendorEaseMobCerStringDevelop otherConfig:config];
//#else
   // [[EaseMob sharedInstance] registerSDKWithAppKey:kVendorEaseMobKeyString apnsCertName:kVendorEaseMobCerStringRelease otherConfig:config];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:kVendorEaseMobKeyString
                                         apnsCertName:kVendorEaseMobCerStringRelease
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES],@"easeSandBox":[NSNumber numberWithBool:NO]}];
//#endif
    //iOS8 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound |
//        UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//    else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
    
   // [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    

//    [self setupNotifiers];
}

- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];

}


#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
//    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
//    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
//    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}



-(void)setupEaseMobRemoteNotifications:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

- (void)checkEaseLogin{
    
    NSLog(@"checkEaseLogin");
    
    NSString *uid = [[Users sharedInfo] getUserUid];
    NSString *username = [[Users sharedInfo] getUserName];
    [[EaseMobUtil sharedInfo] EaseMobCheckLogin:uid username:username];
}


@end
