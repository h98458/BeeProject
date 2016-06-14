//
//  AppTab_New_iPhone.m
//  BeeProject
//
//  Created by huangrg on 14-8-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "AppTab_iPhone.h"

#pragma mark -

DEF_UI( AppTab_iPhone, tabbar_iPhone )

#pragma mark -

@interface AppTab_iPhone()
{
    BeeUIImageView *badge_bg_0,*badge_bg_1,*badge_bg_2,*badge_bg_3;
    BeeUILabel *badge_0,*badge_1,*badge_2,*badge_3;
}
@end
@implementation AppTab_iPhone
DEF_SINGLETON( AppTab_iPhone )
DEF_SIGNAL( TAB_SELECTED )
@synthesize titledTabsView = _titledTabsView;
- (void)load
{
	[super load];
    
    
    RKTabItem *tabItem1 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"tab1_selected.png"] imageDisabled:[UIImage imageNamed:@"tab1.png"]];
    tabItem1.titleString = @"首页";
    
    RKTabItem *tabItem2 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"tab2_selected.png"] imageDisabled:[UIImage imageNamed:@"tab2.png"]];
    tabItem2.titleString = @"公告";
    
    RKTabItem *tabItem3 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"tab3_selected.png"] imageDisabled:[UIImage imageNamed:@"tab3.png"]];
    tabItem3.titleString = @"消息";
    
    RKTabItem *tabItem4 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"tab4_selected.png"] imageDisabled:[UIImage imageNamed:@"tab4.png"]];
    tabItem4.titleString = @"我";
    
    NSArray *items = [NSArray arrayWithObjects:
                      tabItem1,
                      tabItem2,
                      tabItem3,
                      tabItem4,
                      nil];
    
    self.titledTabsView = [[RKTabView alloc] initWithFrame:CGRectZero andTabItems:items andSelectionBlock:^(NSUInteger tabIndex)
                           {
                               [self sendUISignal:self.TAB_SELECTED withObject:__INT(tabIndex)];
                           }];
    self.titledTabsView.delegate = self;
    self.titledTabsView.horizontalInsets = HorizontalEdgeInsetsMake(0, 0);
    self.titledTabsView.titlesFont = [UIFont systemFontOfSize:11];
    self.titledTabsView.titlesFontColor = RGB(255 , 255, 255);
    self.titledTabsView.titlesFontColorEnabled = [UIColor colorWithString:@"#18aa7a"];
//    self.titledTabsView.enabledTabBackgrondColor = [UIColor colorWithString:@"#007de3"];
    
//    self.titledTabsView.tabItems = @[tabItem1, tabItem2, tabItem3, tabItem4];
    [self addSubview:self.titledTabsView];
    self.titledTabsView.backgroundColor = [UIColor colorWithString:@"#444444"];
    [self.titledTabsView switchTabIndex:0];
    
    badge_bg_0 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    badge_bg_0.backgroundColor = [UIColor colorWithString:@"#fd5e34"];
    badge_bg_0.contentMode = UIViewContentModeScaleToFill;
    badge_bg_0.layer.cornerRadius = 4;
    [self addSubview:badge_bg_0];
    badge_bg_0.hidden = YES;
    
    badge_0 = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    badge_0.backgroundColor = [UIColor clearColor];
    badge_0.textColor = [UIColor whiteColor];
    badge_0.font = [UIFont systemFontOfSize:10];
    badge_0.textAlignment = NSTextAlignmentCenter;
    [badge_bg_0 addSubview:badge_0];
    badge_0.hidden = YES;
    
    badge_bg_1 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    badge_bg_1.backgroundColor = [UIColor colorWithString:@"#fd5e34"];
    badge_bg_1.contentMode = UIViewContentModeScaleToFill;
    badge_bg_1.layer.cornerRadius = 4;
    [self addSubview:badge_bg_1];
    badge_bg_1.hidden = YES;
    
    badge_1 = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    badge_1.backgroundColor = [UIColor clearColor];
    badge_1.textColor = [UIColor whiteColor];
    badge_1.font = [UIFont systemFontOfSize:10];
    badge_1.textAlignment = NSTextAlignmentCenter;
    [badge_bg_1 addSubview:badge_1];
    badge_1.hidden = YES;
    
    
    badge_bg_2 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    badge_bg_2.backgroundColor = [UIColor colorWithString:@"#fd5e34"];
    badge_bg_2.contentMode = UIViewContentModeScaleToFill;
    badge_bg_2.layer.cornerRadius = 4;
    [self addSubview:badge_bg_2];
    badge_bg_2.hidden = YES;
    
    badge_2 = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    badge_2.backgroundColor = [UIColor clearColor];
    badge_2.textColor = [UIColor whiteColor];
    badge_2.font = [UIFont systemFontOfSize:10];
    badge_2.textAlignment = NSTextAlignmentCenter;
    [badge_bg_2 addSubview:badge_2];
    badge_2.hidden = YES;
    
    badge_bg_3 = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
    badge_bg_3.backgroundColor = [UIColor colorWithString:@"#fd5e34"];
    badge_bg_3.contentMode = UIViewContentModeScaleToFill;
    badge_bg_3.layer.cornerRadius = 4;
    [self addSubview:badge_bg_3];
    badge_bg_3.hidden = YES;
    
    badge_3 = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    badge_3.backgroundColor = [UIColor clearColor];
    badge_3.textColor = [UIColor whiteColor];
    badge_3.font = [UIFont systemFontOfSize:10];
    badge_3.textAlignment = NSTextAlignmentCenter;
    [badge_bg_3 addSubview:badge_3];
    badge_bg_3.hidden = YES;
}


- (void)unload
{
	[super unload];
}

- (void)layoutDidFinish
{
    self.titledTabsView.frame = CGRectMake(0, 0, self.width, self.height);
    badge_bg_0.frame = CGRectMake(self.width/4*0.5+10, 6, 8, 8);
    badge_0.frame = CGRectMake(0, 0, badge_bg_0.width, badge_bg_0.height);
    
    badge_bg_1.frame = CGRectMake(self.width/2-self.width/4*0.5+10, 6, 8, 8);
    badge_1.frame = CGRectMake(0, 0, badge_bg_1.width, badge_bg_1.height);
    
    badge_bg_2.frame = CGRectMake(self.width*0.75-self.width/4*0.5+10, 6, 8, 8);
    badge_2.frame = CGRectMake(0, 0, badge_bg_2.width, badge_bg_2.height);
    
    badge_bg_3.frame = CGRectMake(self.width-self.width/4*0.5+10, 6, 8, 8);
    badge_3.frame = CGRectMake(0, 0, badge_bg_3.width, badge_bg_3.height);
}

- (void)dataDidChanged
{

}

- (void)select1
{
    [self.titledTabsView switchTabIndex:0];
}
- (void)select2
{
    [self.titledTabsView switchTabIndex:1];
}
- (void)select3
{
    [self.titledTabsView switchTabIndex:2];
}
- (void)select4
{
    [self.titledTabsView switchTabIndex:3];
}

- (void)updateBadge:(NSInteger)number TabIndex:(NSInteger)index
{
    if (index == 0)
    {
        if (number<=0)
        {
            badge_bg_0.hidden = YES;
            badge_0.hidden = YES;
            badge_0.text = @"";
            return;
        }
        badge_bg_0.hidden = NO;
        badge_0.hidden = NO;
//        badge_0.text = [NSString stringWithFormat:@"%d",(int)number];
    }
    else if (index == 1)
    {
        if (number<=0)
        {
            badge_bg_1.hidden = YES;
            badge_1.hidden = YES;
            badge_1.text = @"";
            return;
        }
        badge_bg_1.hidden = NO;
        badge_1.hidden = NO;
//        badge_1.text = [NSString stringWithFormat:@"%d",(int)number];
    }
    else if (index == 2)
    {
        if (number<=0)
        {
            badge_bg_2.hidden = YES;
            badge_2.hidden = YES;
            badge_2.text = @"";
            return;
        }
        badge_bg_2.hidden = NO;
        badge_2.hidden = NO;
//        badge_2.text = [NSString stringWithFormat:@"%d",(int)number];
    }
    else if (index == 3)
    {
        if (number<=0)
        {
            badge_bg_3.hidden = YES;
            badge_3.hidden = YES;
            badge_3.text = @"";
            return;
        }
        badge_bg_3.hidden = NO;
        badge_3.hidden = NO;
//        badge_3.text = [NSString stringWithFormat:@"%d",(int)number];
    }
    
}

#pragma mark - RKTabViewDelegate

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem
{
//    [self sendUISignal:self.TAB_SELECTED withObject:__INT(index)];
}

- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem
{
    
}
@end
