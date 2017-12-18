//
//  AppDelegate.m
//  BeeProject
//
//  Created by huangrg on 16/6/11.
//  Copyright © 2016年 huangrg. All rights reserved.
//

#import "AppDelegate.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"

#pragma mark -

@implementation AppDelegate

- (void)load
{
    bee.ui.config.ASR = YES;
    bee.ui.config.iOS6Mode = YES;
//    bee.ui.config.iOS7Mode = YES;
    bee.ui.config.cacheAsyncLoad = YES;
    bee.ui.config.cacheAsyncSave = YES;
    
    
    
    // 配置提示框
    [BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
    [BeeUITipsCenter setDefaultMessageIcon:[UIImage imageNamed:@"icon.png"]];
    [BeeUITipsCenter setDefaultSuccessIcon:[UIImage imageNamed:@"icon.png"]];
    [BeeUITipsCenter setDefaultFailureIcon:[UIImage imageNamed:@"icon.png"]];
    
    // 配置导航条
    [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar.png"]];
    [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
    
    if ( [BeeSystemInfo isDevicePad] )
    {
        self.window.rootViewController = [AppBoard_iPad sharedInstance];
    }
    else
    {
        self.window.rootViewController = [AppBoard_iPhone sharedInstance];
    }
    
    [BeeUITipsCenter setDefaultContainerView:self.window.rootViewController.view];
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)unload
{
    
}

@end
