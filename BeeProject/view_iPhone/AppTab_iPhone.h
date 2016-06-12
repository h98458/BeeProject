//
//  AppTab_New_iPhone.h
//  BeeProject
//
//  Created by huangrg on 14-8-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "RKTabView.h"

#pragma mark -

AS_UI( AppTab_iPhone, tabbar )

#pragma mark -

@interface AppTab_iPhone : BeeUICell<RKTabViewDelegate>
AS_SINGLETON( AppTab_iPhone )
AS_SIGNAL( TAB_SELECTED )
@property (nonatomic, retain) RKTabView *titledTabsView;
- (void)select1;
- (void)select2;
- (void)select3;
- (void)select4;

- (void)updateBadge:(NSInteger)number TabIndex:(NSInteger)index;
@end
