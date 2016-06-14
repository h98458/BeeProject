//  AppBoard_iPhone.h
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "Bee.h"

#undef	TAB_HEIGHT
#define TAB_HEIGHT	50.0f

#pragma mark -

AS_UI( AppBoard_iPhone, appBoard_iPhone )

#pragma mark -
@interface AppBoard_iPhone : BeeUIBoard

AS_SINGLETON( AppBoard_iPhone )


/**
 * 底部菜单-首页，点击时会触发该事件
 */
AS_SIGNAL( TAB_HOME )

@property (nonatomic ,assign) BOOL bForeground;//程序是否在后台

- (void)showTabbar;
- (void)hideTabbar;

- (void)showMenu;
- (void)hideMenu;

//屏幕唤醒
-(void)becomeActive;


@end
