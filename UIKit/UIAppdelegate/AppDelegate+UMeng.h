//
//  AppDelegate+UMeng.h
//  ksh3
//
//  Created by madao on 15/10/20.
//  Copyright © 2015年 jianminxian. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioPlayer.h"

@interface AppDelegate (UMeng)<UIAlertViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) UIAlertView *pushAlertView;
@property (nonatomic, strong) NSDictionary *pushUserInfo;

@property (nonatomic,strong) NSDictionary *searchDic;

@property (nonatomic,strong) NSString *searcherUid;
@property (nonatomic,strong) NSString *searchUnicode;

@property (nonatomic,strong) UIButton *voiceBt;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,assign) NSInteger imagePath;

@property (nonatomic,assign) float totalTime;
@property (nonatomic,assign) float voiceTime;
@property (nonatomic,strong) NSTimer *interTime;


- (void)setupUMeng:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)didReceiveUMeng:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
