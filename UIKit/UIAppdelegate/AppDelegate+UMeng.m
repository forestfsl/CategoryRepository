//
//  AppDelegate+UMeng.m
//  ksh3
//
//  Created by madao on 15/10/20.
//  Copyright © 2015年 jianminxian. All rights reserved.
//

#import "AppDelegate+UMeng.h"

// 友盟分享
#import <UMSocialCore/UMSocialCore.h> //新的友盟授权文件
#import <UShareUI/UShareUI.h>  //新的自定义分享UI文件
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMessage.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"

#import "ZddPush.h"
#import "ZDDPushViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import "ZDDTabBarController.h"
#import "CallPageViewController.h"
#import "PhoneGlobalClass.h"
#import "ZDDRequestModel.h"
#import "UIView+Toast.h"
#import "CNPPopupController.h"
#import "EaseSDKHelper.h"
#import "UIView+ItemBadge.h"

#define PUSH_KEY_NAME @"aps"

@interface AppDelegate() <CNPPopupControllerDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) CNPPopupController *popupController;
@property(nonatomic,strong) CallPageViewController  *callPageView;

@end

@implementation AppDelegate (UMeng)
@dynamic pushUserInfo;
@dynamic pushAlertView;
@dynamic searchDic;

@dynamic searcherUid;
@dynamic searchUnicode;
@dynamic voiceBt;
@dynamic timeLabel;
@dynamic filePath;
@dynamic sex;
@dynamic imagePath;
@dynamic totalTime;
@dynamic voiceTime;
@dynamic interTime;

#pragma mark - 友盟分享
- (void)setupUMeng:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    [self initUMShared];
    [self initUMessage:launchOptions];

    
    //Crashlytics 和友盟的错误报告不能同时使用，先关闭友盟日志
    [MobClick setCrashReportEnabled:NO];
    [MobClick startWithAppkey:k_UMengKey reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
}


- (void)didReceiveUMeng:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    if (!userInfo) {
        completionHandler(UIBackgroundFetchResultFailed);
    } else {
        
        [UMessage didReceiveRemoteNotification:userInfo];
        
        if ([userInfo objectForKey:PUSH_KEY_NAME]) {
            
            switch (application.applicationState) {
                case UIApplicationStateActive:{
                    [self handlePushMessage:userInfo appRunning:YES applicationState:UIApplicationStateActive];}
                    break;
                case UIApplicationStateInactive:{
                    [self handlePushMessage:userInfo appRunning:YES applicationState:UIApplicationStateInactive];}
                    break;
                case UIApplicationStateBackground:{
                    [self handlePushMessage:userInfo appRunning:YES applicationState:UIApplicationStateBackground];}
                    break;
                default:
                    //
                    break;
            }
            
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    }
    
}

- (void)handlePushMessage:(NSDictionary *)userInfo appRunning:(BOOL)isRunning applicationState:(UIApplicationState)applicationState
{
    
//#if DEBUG
    /* 友盟测试环境，松果服务器测试 */
//    NSDictionary *pushDic = [[NSDictionary alloc] initWithDictionary:userInfo];   /* 友盟测试环境 */
//#else
    /* 友盟生产环境，同时 alertMessage 必须打开 */
    NSDictionary *pushDic = [userInfo[@"json"] mj_JSONObject];             /* 友盟生产环境 */
//#endif
    
    NSInteger newType = [pushDic[@"newType"] intValue];
    
    //推送类型开始值为 1001
    if (newType > 1000) {
        
        BOOL isNeedShowRedPoint = YES;
        
        if (newType == NOTI_TYPE_BROADCAST_TOPIC || newType == NOTI_TYPE_BROADCAST_LONG_TOPIC || newType == 4008) {
            isNeedShowRedPoint = NO;
        }
        
        //防止进来两次
        if (applicationState == UIApplicationStateBackground) {
            if (isNeedShowRedPoint) {
                [self addOneRedPointNumberSuccessed:[self redpointType:newType]];
                [[MarsManager shareMarsInstance]infoLogWithTag:JRDebugMessage Content:[NSString stringWithFormat:@"add RedPoint from UM %@",pushDic]];
                [self redPointViewAddSubviewToTabBarView];
            }
            return;
        } else if (applicationState == UIApplicationStateActive) {
            
            //通话
            if (newType == 4008) {
                return;
            }
            
            //文章、帖子推送才给出提示框
            if (newType == NOTI_TYPE_BROADCAST_TOPIC || newType == NOTI_TYPE_BROADCAST_LONG_TOPIC) {
                
                NSString *alertMessage = [NSString stringWithFormat:@"%@", pushDic[@"aps"][@"alert"]];
                if (!alertMessage) {
                    self.pushAlertView = [[UIAlertView alloc] initWithTitle:@"松果推送"
                                                                    message:alertMessage
                                                                   delegate:self
                                                          cancelButtonTitle:@"忽略"
                                                          otherButtonTitles:@"查看", nil];
                    [self.pushAlertView show];
                }
                
                [self encapsulateAlertViewPushPrams:userInfo];
            } else if( newType == 4003 ) {
                
                    UIViewController *incomingVoiplView = nil;
                    UIStoryboard *chatViewContentStoryboard = [UIStoryboard storyboardWithName:@"ChatStoryboard" bundle:nil];
                    CallPageViewController *callPageView = nil;
                
                    callPageView = [chatViewContentStoryboard instantiateViewControllerWithIdentifier:@"CallPageViewController"];
                    callPageView.uInfo     = [NSString stringWithFormat:@"%@-%@-%@",pushDic[@"fromUid"],pushDic[@"pic"][@"big"],@"2"];
                    callPageView.callActionNO    = @"222";
                    incomingVoiplView      = callPageView;
                    callPageView.isAgaro   = @"1";
                    callPageView.chatroom  = pushDic[@"chatroomId"];
                    [PhoneGlobalClass sharedInstance].isLogin = YES;
                
                    id rootviewcontroller = [UIApplication sharedApplication].keyWindow.rootViewController;
                    
                    if ([rootviewcontroller isKindOfClass:[UINavigationController class]]) {
                        [((UINavigationController*)rootviewcontroller).topViewController presentViewController:incomingVoiplView animated:YES completion:nil];
                    } else if ([rootviewcontroller isKindOfClass:[UIViewController class]]) {
                        [rootviewcontroller presentViewController:incomingVoiplView animated:YES completion:nil];
                    }
            }
            else {
                [self doPushRemoveNotification:pushDic applicationState:applicationState];
                
            }
            
        } else if (applicationState == UIApplicationStateInactive) {
            [self doPushRemoveNotification:pushDic applicationState:applicationState];
        }
        
        if (isNeedShowRedPoint) {
            [self addOneRedPointNumberSuccessed:[self redpointType:newType]];
            [[MarsManager shareMarsInstance]infoLogWithTag:JRDebugMessage Content:[NSString stringWithFormat:@"add RedPoint from UM %@",pushDic]];
            [self redPointViewAddSubviewToTabBarView];
        }
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_ZDD_ReceivePushNotiMessage" object:nil userInfo:pushDic];
    }
    
    // 播放音效or震动
    AudioServicesPlaySystemSound(1002);
    
}


- (void)joinChatingRoomByDic:(NSDictionary *)extDic {
    
    
    NSString *buy_uid = extDic[@"buy_uid"];
    NSString *chatRoomChannel = extDic[@"channel"];
    NSString *userIDString    = extDic[@"uid"];
    NSString *uiserPicString  = [[ShareModel sharedInstance] getUserAvatar:userIDString sizeType:ZDDUserAvatarTypeBig];
    NSString *userNameString  = extDic[@"username"];
    NSString *actualDuration  = extDic[@"actualDuration"];
    NSString *serviceDuration  = extDic[@"serviceDuration"] == nil ? @"0" :extDic[@"serviceDuration"];
    NSString *agoraKeyString  = extDic[@"agoraDynamicKey"];
    NSUInteger callconnectType = extDic[@"callconnectType"] ? [extDic[@"callconnectType"] integerValue] : ZDDCallConnectTypeVOICE;
    //打电话
    if ([PhoneGlobalClass sharedInstance].isCallBusy == YES && [chatRoomChannel isEqualToString:[PhoneGlobalClass sharedInstance].callid]) {
        return;
    }
    
    //FIXME: 这里有一个问题，
    if ([PhoneGlobalClass sharedInstance].isCallBusy) {
        [EaseSDKHelper sendCmdMessage:kcloseAgoraCallInView to:userIDString messageType:EMChatTypeChat messageExt:@{@"close":chatRoomChannel} cmdParams:nil];
        
        return ;
    }
    
    [PhoneGlobalClass sharedInstance].callid = chatRoomChannel;
    [PhoneGlobalClass sharedInstance].isCallBusy = YES;
    
    UIStoryboard *chatViewContentStoryboard = [UIStoryboard storyboardWithName:@"ChatStoryboard" bundle:nil];
    
    //fix [AppDelegate setCallPageView:]: unrecognized selector sent to instance 0x13d538820
    //造成unrecognized selector sent to instance iphone，大部分情况下是因为对象被提前release了，在你心里不希望他release的情况下，指针还在，对象已经不在了。
    if ( self.callPageView == nil) {
        return ;
    }
    
    self.callPageView = [chatViewContentStoryboard instantiateViewControllerWithIdentifier:@"CallPageViewController"];
    self.callPageView.uInfo           = [NSString stringWithFormat:@"%@-%@-%@", userIDString, uiserPicString, userNameString];
    self.callPageView.callActionNO    = @"222";
    self.callPageView.isAgaro         = @"1";
    self.callPageView.chatroom        = chatRoomChannel;
    self.callPageView.callServiceType = ZDDCallServiceTypeAgora;
    self.callPageView.callDirectType  = ZDDCallDirectIn;
    self.callPageView.agoraKeyString  = agoraKeyString;
    self.callPageView.callConnectType = callconnectType;
    self.callPageView.buy_uid         = buy_uid;
    self.callPageView.isHiddenCloseBtn = YES;
    
    self.callPageView.dissmissReturnHandler = ^(ZDDCallState callState,BOOL isShowSlineBtn,NSString *orderId) {
        if ([PhoneGlobalClass sharedInstance].callid) {
            [PhoneGlobalClass sharedInstance].lastCallid = [PhoneGlobalClass sharedInstance].callid;
        }
        
        [PhoneGlobalClass sharedInstance].callid = nil;
        [PhoneGlobalClass sharedInstance].isCallBusy = NO;
    };
    
    self.callPageView.successHandler = ^(NSInteger status ) {
        
    };
    
    if (actualDuration) {
        self.callPageView.order = [[zddOrder alloc] initWithDictionary:@{@"actualDuration":actualDuration, @"buy_uid":userIDString,@"serviceDuration":serviceDuration}];
    } else {
        self.callPageView.order = [[zddOrder alloc] initWithDictionary:@{@"actualDuration":@"0", @"buy_uid":userIDString,@"serviceDuration":serviceDuration}];
    }
    
    self.callPageView.chatringUID = userIDString;
    
    UIViewController *incomingVoiplView = self.callPageView;
    
    id rootviewcontroller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([rootviewcontroller isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController*)rootviewcontroller).topViewController presentViewController:incomingVoiplView animated:YES completion:^{
        }];
    } else if ([rootviewcontroller isKindOfClass:[UIViewController class]]) {
        [rootviewcontroller presentViewController:incomingVoiplView animated:YES completion:^{
        }];
    }
}



- (void)reSetCallPageView:(CallPageViewController *)pageView{
    pageView = nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
#if DEBUG
        /* 友盟测试环境，松果服务器测试 */
#else
        // 如果不调用此方法，友盟的统计数据会拿不到。
        [UMessage sendClickReportForRemoteNotification:self.pushUserInfo];  /* 友盟生产环境 */
#endif
        
        if (alertView.tag == 555) {
            
        }else if (alertView.tag == 556 || alertView.tag == 557){
            
        }else{
            [self doPushRemoveNotification:self.pushUserInfo applicationState:UIApplicationStateActive];
        }
    }
}

- (void)doPushRemoveNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
    [params setValue:@(applicationState)  forKey:@"applicationState"];
    
    ZddPush *zddPush = [[ZddPush alloc] init];
    ZDDPushViewController *pushActionController = [[ZDDPushViewController alloc] init];
    
    NSInteger pushTypeNum;
    if ([params objectForKey:@"newType"]) {
        pushTypeNum = [params[@"newType"] intValue];
    }
    
    //通话唤醒
    if (pushTypeNum == 4008) {
        
        NSString *agoraKey = [[NSUserDefaults standardUserDefaults]objectForKey:@"JRAgoraSingupKey"];
        
        if (agoraKey.length > 0) {
            [[ShareAgoraAPI shareInstance] loginWithUid:[Users sharedInfo].loginModel.uid token:agoraKey withUsername:[[Users sharedInfo] getUserName] success:^(unsigned int uid, int code) {
                //
            } fail:^(AgoraEcode code) {
                //
            }];
        }
        
        return;
    }
    
    if (pushTypeNum == NOTI_TYPE_RESPOND_USER) {
        
    }else if(pushTypeNum == 4007){
     
        //通话
        NSString *jsonStr = params[@"message"];
        NSDictionary *messageDict = [jsonStr mj_JSONObject];
        
        NSString *chatRoomChannel = messageDict[@"channel"];
        NSString *agoraKeyString  = messageDict[@"agoraDynamicKey"];
        NSString *orderId         = messageDict[@"orderId"];
        
        [JRCommonTools requestCallStatisticsWithOrderId:orderId type:@"3" channel:chatRoomChannel agoraDynamicKey:agoraKeyString emchatTime:0 appTime:0];
        
        
        [self joinChatingRoomByDic:messageDict];
        
    }else{
        [zddPush initPush:pushActionController andSelector:@selector(gotoDetailView:) params:params];
    }
    
    [zddPush doPush];
}


-(void)voiceBtAction:(UIButton *)sender {
    self.interTime = [NSTimer timerWithTimeInterval:0.3
                                             target:self
                                           selector:@selector(updateVoiceBtStatus)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.interTime forMode:NSRunLoopCommonModes];
    
    [self playVoiceUrl];
    
}
-(void)updateVoiceBtStatus
{
    self.imagePath ++ ;
    self.totalTime += 0.3;
    NSString *num;
    if ([self.sex intValue] == 1) {
        num = [NSString stringWithFormat:@"play_women_%ld",self.imagePath % 4];
    }else {
        num = [NSString stringWithFormat:@"play_man_%ld",self.imagePath % 4];
    }
    [self.voiceBt setBackgroundImage:[UIImage imageNamed:num] forState:UIControlStateNormal];
    
    if (self.totalTime > self.voiceTime) {
        
        [self.interTime invalidate];
        
        if ([self.sex intValue] == 1) {
            [self.voiceBt setBackgroundImage:[UIImage imageNamed:@"play_women_3"] forState:UIControlStateNormal];
        }else {
            [self.voiceBt setBackgroundImage:[UIImage imageNamed:@"play_man_3"] forState:UIControlStateNormal];
        }
        self.totalTime = 0.00;
    }
}

-(void)playVoiceUrl {
    
    NSString *voiceURLStr = self.filePath;
//    NSString *voiceURLStr = @"http://cache-amr.51songguo.com/introVoice/133/193933/20160521130446.amr";
    if ([voiceURLStr hasSuffix:@".amr"]) {
        
        //    //当前播放的音频，点击之前播放的音频，而且它仍在播放中。
        if ([AudioPlayer audioPlayerSingleton].currentPlayer.isPlaying) {
            
            [[AudioPlayer audioPlayerSingleton].currentPlayer stop];
            if ([self.sex intValue] == 1) {
                [self.voiceBt setBackgroundImage:[UIImage imageNamed:@"play_women_3"] forState:UIControlStateNormal];
            }else {
                [self.voiceBt setBackgroundImage:[UIImage imageNamed:@"play_man_3"] forState:UIControlStateNormal];
            }
            [self.interTime invalidate];
        }
        
       //获取音频数据
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceURLStr]];
        
        if (urlData) {
            BOOL convertSuccess = [[AudioPlayer audioPlayerSingleton] playFromAmrURL:voiceURLStr data:urlData];
            
            if (convertSuccess) {
                [AudioPlayer audioPlayerSingleton].currentPlayer.delegate = self;
                [[AudioPlayer audioPlayerSingleton].currentPlayer play];
            }
        } else {
            [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:@"声音签名已失效" duration:1.68 position:CSToastPositionCenter];
        }
    }
}



- (void)encapsulateAlertViewPushPrams:(NSDictionary *)userInfo {
    
    NSMutableDictionary *prams = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    //封装字典，加入一个 键值  作为判断：是否是弹窗消息
    [prams setObject:@(YES) forKey:@"isShowInAlertView"];
    self.pushUserInfo = [NSDictionary dictionaryWithDictionary:prams];
}

- (NSInteger)redpointType:(NSInteger)newType {
    if (1000 < newType && newType < 2000) {
        return 1;
    } else if (2000 <= newType && newType < 3000 ) {
        if (newType == 2106) {//留言板
            return 5;
        } else {
           return 2;
        }
    } else if (3000 <= newType && newType < 4000 ) {
        return 3;
    } else if (4000 <= newType && newType < 5000 ) {
        return 4;
    } else if (10000 <= newType && newType < 20000 ) {
        return 10;
    } else {
        return 100;
    }
}

- (void) redPointViewAddSubviewToTabBarView {/**< 添加红点*/
    
    CGRect tabFrame;
    
    ZDDTabBarController *tabBarController = (ZDDTabBarController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    if ([tabBarController isKindOfClass:[UITabBarController class]]) {
        
        //FIXME: Warring
//        UITabBarController *tabBarController = (UITabBarController *)tabBarController;
        tabFrame = tabBarController.tabBar.frame;
        
        UIView *redPointView = [tabBarController.tabBar viewWithTag:1000];
        
        if (redPointView) {
            
//            redPointView.hidden = NO;
            [tabBarController.tabBar showBadgeOnItemIndex:4];
            
        } else {
//            UIView *dotImage = [[UIView alloc] init];
//            dotImage.backgroundColor = [UIColor redColor];
//            CGFloat x = ceilf(0.93 * tabFrame.size.width);
//            CGFloat y = ceilf(0.2 * tabFrame.size.height);
//            dotImage.frame = CGRectMake(x, y, 10, 10);
//            dotImage.layer.cornerRadius = 5;
//            dotImage.layer.masksToBounds = true;
//            dotImage.tag = 1000;
//            [tabBarController.tabBar addSubview:dotImage];
            [tabBarController.tabBar showBadgeOnItemIndex:4];
        }
    }
}

- (BOOL) addOneRedPointNumberSuccessed:(NSInteger)type {
    
    int numbers = [self notificationNumbers:type];
    
    if (numbers == -1) {
        return [self updateRedPointNumbers:1 type:type];;
    } else {
        numbers++;
        return [self updateRedPointNumbers:numbers type:type];
    }
}

- (BOOL) updateRedPointNumbers:(int)numbers type:(NSInteger)type {
    
    NSString *notiNameStr = [self notificationName:type];
    if (notiNameStr) {
        [USER_DEFAULT setObject:@(numbers) forKey:notiNameStr];
        return YES;
    } else {
        return NO;
    }
}

- (int) notificationNumbers:(NSInteger)type {
    
    NSString *notiNameStr = [self notificationName:type];
    
    if (notiNameStr) {
        return [[USER_DEFAULT objectForKey:notiNameStr] intValue];
    } else {
        return -1;//还没有存放到 User Default 里面的情况
    }
}

- (NSString *) notificationName:(NSUInteger)redPointType {
    
    NSString *ownUid = [[Users sharedInfo] getUserUid];
    NSString *notiNumStr = nil;
    
    switch (redPointType) {
        case 1:{
            return notiNumStr = [NSString stringWithFormat:@"notiReplyNum%@", ownUid];}
            break;
        case 2:{
            return notiNumStr = [NSString stringWithFormat:@"notiPraiseNum%@", ownUid];}
            break;
        case 3:
            return nil;
            break;
        case 4:{
            return nil;}
            break;
        case 5:{
            return notiNumStr = [NSString stringWithFormat:@"notiMessageBoardNum%@", ownUid];}
            break;
        case 10:{
            return notiNumStr = [NSString stringWithFormat:@"notiFollowNum%@", ownUid];}
            break;
        case 100:{
            return nil;}
            break;
        default:{
            return nil;}
            break;
    }
}

#pragma mark - 友盟分享
- (void)initUMShared
{
//    [UMSocialData setAppKey:k_UMengKey];
    //设置微信AppId，设置分享url，默认使用友盟的网址
//    [UMSocialWechatHandler setWXAppId:@"wx605a7fbeaa10aa82" appSecret:@"03793c91ff6966aa1048490511442cdf" url:@"http://www.umeng.com/social"];
//    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"1104632269" appKey:@"n6xF5O6fp6tbVs6e" url:@"http://www.umeng.com/social"];
//    
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:k_UMengKey];
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx605a7fbeaa10aa82" appSecret:@"03793c91ff6966aa1048490511442cdf" redirectURL:@"http://mobile.umeng.com/social"];
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104632269" appSecret:@"n6xF5O6fp6tbVs6e" redirectURL:@"http://mobile.umeng.com/social"];
    //新浪
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:nil  appSecret:nil redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
//    wxde468ecd45b35ce5
//    wxde468ecd45b35ce5
//    04d6533ac1d096caad9dcc20969e1817
//    04d6533ac1d096caad9dcc20969e1817
//    04d6533ac1d096caad9dcc20969e1817
//    [UMSocialWechatHandler setWXAppId:@"wx605a7fbeaa10aa82" appSecret:@"03793c91ff6966aa1048490511442cdf" url:@"http://www.umeng.com/social"];
    
}

#pragma mark - 友盟消息推送
- (void)initUMessage:(NSDictionary *)launchOptions
{
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:k_UMengKey launchOptions:launchOptions];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
//        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                     categories:[NSSet setWithObject:categorys]];
//        
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
        NSSet *categories = [NSSet setWithObjects:categorys, nil];
        
        //如果要在iOS10显示交互式的通知，必须注意实现以下代码
        if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
            UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
            UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
            
            //UNNotificationCategoryOptionNone
            //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
            //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
            UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
            [center setNotificationCategories:categories_ios10];
        }else
        {
            [UMessage registerForRemoteNotifications:categories];
        }

        
    }
#else
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
#endif
    
#if DEBUG
    [UMessage setLogEnabled:NO];
#else
    [UMessage setLogEnabled:NO];
#endif
    
    [UMessage setAutoAlert:NO]; //关闭弹窗的消息推送
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 120)];
    
    UIImageView *avaterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    avaterImageView.image = [UIImage imageNamed:@"test_headImage"];
    avaterImageView.layer.cornerRadius = 20;
    [customView addSubview:avaterImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(59, 0, 200, 15)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor orangeColor];
    label.text = @"开心的微笑";//
    [customView addSubview:label];
    
    UILabel *instroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 20, 250, 30)];
    instroduceLabel.numberOfLines = 0;
    instroduceLabel.font = [UIFont systemFontOfSize:12.0f];
    instroduceLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    instroduceLabel.text = @"正在求助...去帮助后您将会出现在搜索结果中，由求助者选择求助对象";
    [customView addSubview:instroduceLabel];
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 290, 40)];
    contentView.image = [UIImage imageNamed:@"gf_alertView_help_content_BG"];
    [customView addSubview:contentView];
    
    UILabel *helpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 250, 14)];
    helpTitleLabel.text = @"求助内容,微信发现女朋友出轨怎么办";
    helpTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    helpTitleLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [contentView addSubview:helpTitleLabel];
    
    UIView *horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(-10, 95, 310, 1)];
    horizontalLineView.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:0.5];
    [customView addSubview:horizontalLineView];
    
    UIView *verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(140, 95, 1, 40)];
    verticalLineView.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:0.5];
    [customView addSubview:verticalLineView];
    
    UIButton *noHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, 95, 150, 41)];
    [noHelpButton setTitle:@"不理睬" forState:UIControlStateNormal];
    [noHelpButton setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal
     ];
    [noHelpButton addTarget:self action:@selector(noHelpAction) forControlEvents:UIControlEventTouchDown];
    noHelpButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [customView addSubview:noHelpButton];
    
    UIButton *goHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(141, 95, 170, 41)];
    [goHelpButton setTitle:@"去帮助" forState:UIControlStateNormal];
    [goHelpButton setTitleColor:[UIColor colorWithRed:2.0/255.0 green:204.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal
     ];
    [goHelpButton addTarget:self action:@selector(goHelpAction) forControlEvents:UIControlEventTouchDown];
    goHelpButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [customView addSubview:goHelpButton];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[customView]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void)noHelpAction {
    [self.popupController dismissPopupControllerAnimated:YES];
}

- (void)goHelpAction {
    [self.popupController dismissPopupControllerAnimated:YES];
}


@end
