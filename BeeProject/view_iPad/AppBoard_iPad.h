//  AppBoard_iPad.h
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "Bee.h"

#undef	TAB_HEIGHT
#define TAB_HEIGHT	50.0f

#pragma mark -

AS_UI( AppBoard_iPad, appBoard_iPad )

#pragma mark -

@interface AppBoard_iPad : BeeUIBoard

AS_SINGLETON( AppBoard_iPad )

/**
 * 底部菜单-首页，点击时会触发该事件
 */
AS_SIGNAL( TAB_HOME )

@property (nonatomic ,assign) BOOL bForeground;//程序是否在后台

- (void)showTabbar;
- (void)hideTabbar;

//屏幕唤醒
-(void)becomeActive;

@end
