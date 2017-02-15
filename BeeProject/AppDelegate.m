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

#import "QMUIConfigurationTemplate.h"
#import "QDUIHelper.h"
#import "QDCommonUI.h"

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
    
    // 启动QMUI的配置模板
    [QMUIConfigurationTemplate setupConfigurationTemplate];
    
    // 将全局的控件样式渲染出来
    [QMUIConfigurationManager renderGlobalAppearances];
    
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    
    // 将状态栏设置为希望的样式
    [QMUIHelper renderStatusBarStyleLight];
    
    return YES;
}

- (void)unload
{
    
}

@end
