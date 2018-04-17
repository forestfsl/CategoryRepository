//
//  AppDelegate+Onboard.m
//  ksh3
//
//  Created by madao on 15/10/20.
//  Copyright © 2015年 jianminxian. All rights reserved.
//

#import "AppDelegate+Onboard.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
#import "ZDDTabBarController.h"
#import "CustomWindow.h"

@implementation AppDelegate (Onboard)


- (void)setupOnboard:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    ZDDTabBarController *tabBarController = [ZDDTabBarController sharedInstance];
    
    self.window = [[CustomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = tabBarController;
    
}

- (OnboardingViewController *)generateFirstDemoVC:(ZDDTabBarController *)tabBarController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"agreedProtocal"];
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"" body:@"" image:[UIImage imageNamed:@"panel01"] buttonText:@"" action:^{
        
    }];
    firstPage.topPadding = 0;
    firstPage.bottomPadding = 0;
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"" body:@"" image:[UIImage imageNamed:@"panel02"] buttonText:@"" action:^{
        
    }];
    secondPage.topPadding = 0;
    
    //OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"" body:@"" image:[UIImage imageNamed:@"panel03"] buttonText:@"" action:^{
        
    //}];
    //thirdPage.topPadding = 0;
    
    OnboardingContentViewController *fouthPage = [OnboardingContentViewController contentWithTitle:@"" body:@"" image:[UIImage imageNamed:@"panel03"] buttonText:@"app_launch_enter" action:^{
        [self handleOnboardingCompletion:tabBarController];
    }];
    fouthPage.topPadding = 0;
    fouthPage.buttonFontName = @"SpaceAge";
    fouthPage.buttonTextColor = [UIColor whiteColor];
    fouthPage.buttonFontSize = 17;
    
    //OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:nil contents:@[firstPage, secondPage, thirdPage, fouthPage]];
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:nil contents:@[firstPage, secondPage, fouthPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    
    //跳过按钮的隐藏和显示
    //- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
    
    [onboardingVC.skipButton setBackgroundImage:[UIImage imageNamed:@"app_launch_skip"] forState:UIControlStateNormal];
    onboardingVC.underPageControlPadding = 5;//
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion:tabBarController];
    };
    
    return onboardingVC;
}

- (void)handleOnboardingCompletion:(ZDDTabBarController*)tabBarController{
    [self setupNormalRootViewControllerAnimated:tabBarController];
}


- (void)setupNormalRootViewControllerAnimated:(ZDDTabBarController*)tabBarController{
    self.window.rootViewController = tabBarController;
}

@end
