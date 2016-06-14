//  MainBoard_iPhone.m
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "MainBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark - MainBoard_iPhone

@interface MainBoard_iPhone()
{

}
@end

@implementation MainBoard_iPhone
DEF_SINGLETON( MainBoard_iPhone )
DEF_SIGNAL( VERSION_UPDATE )
- (void)load
{
    [super load];
}

- (void)unload
{
    [super unload];
}



-(void)checkUpdateVersion
{
    //检查新版本
}



#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNavigationBarAnimated:NO];
    
    self.title = @"BeeProject";
    
    self.scroll = [[BeeUIScrollView alloc] init];
    self.scroll.backgroundColor = [UIColor clearColor];
    self.scroll.dataSource = self;
    self.scroll.vertical = YES;
    [self.view addSubview:self.scroll];
    [self.scroll setBaseInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveAllNotifications];
}

ON_LAYOUT_VIEWS( signal )
{
    if (self.scroll.height<=0)
    {
        self.scroll.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }
}

ON_LOAD_DATAS( signal )
{
    
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard_iPhone showTabbar];
    [self.scroll reloadData];
}

ON_DID_APPEAR( signal )
{
    
}

ON_WILL_DISAPPEAR( signal )
{
    
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
    
}



#pragma mark - self
ON_SIGNAL2( MainBoard_iPhone , signal )
{
    if ( [signal is:self.VERSION_UPDATE] )
    {
//        NSString *trackViewUrl = [[SoftInfoModel sharedInstance].versionInfo objectForKey:@"trackViewUrl"];
//        UIApplication *application = [UIApplication sharedApplication];
//        [application openURL:[NSURL URLWithString:trackViewUrl]];
    }
    
}


#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    return CGSizeZero;
    
}

@end
