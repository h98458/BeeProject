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
#import "QMUIConfigurationTemplateGrapefruit.h"
#import "QMUIConfigurationTemplateGrass.h"
#import "QMUIConfigurationTemplatePinkRose.h"

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
    
    // 应用 QMUI Demo 皮肤
    NSString *themeClassName = [[NSUserDefaults standardUserDefaults] stringForKey:QDSelectedThemeClassName] ?: NSStringFromClass([QMUIConfigurationTemplate class]);
    [QDThemeManager sharedInstance].currentTheme = [[NSClassFromString(themeClassName) alloc] init];
    
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    
    // 预加载 QQ 表情，避免第一次使用时卡顿（可选）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QMUIQQEmotionManager emotionsForQQ];
    });
    
    // 将状态栏设置为希望的样式
    [QMUIHelper renderStatusBarStyleLight];
    
    return YES;
}

- (void)unload
{
    
}

@end
