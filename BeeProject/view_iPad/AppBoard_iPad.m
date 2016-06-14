//  AppBoard_iPad.m
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "AppBoard_iPad.h"
#import "MainBoard_iPad.h"
#import "AppTab_iPad.h"

#pragma mark -

DEF_UI( AppBoard_iPad, appBoard_iPad )

#pragma mark -

@implementation AppBoard_iPad
{
    BeeUIRouter *		_router;
    BeeUIButton *		_mask;
    
    CGFloat _tabbarOriginY;
    
    UIWindow *			_splash;
    CGRect				_origFrame;
}

DEF_SINGLETON( AppBoard_iPad )
@synthesize bForeground = _bForeground;
DEF_SIGNAL( TAB_HOME )

- (void)load
{
    [super load];
}

- (void)unload
{
    [super unload];
}

#pragma mark Signal

ON_CREATE_VIEWS( signal )
{
    _router = [BeeUIRouter sharedInstance];
    _router.parentBoard = self;
    [_router map:@"main" toClass:[MainBoard_iPad class]];
    [self.view addSubview:_router.view];
    
    _mask = [BeeUIButton new];
    _mask.hidden = YES;
    _mask.signal = @"mask";
    [self.view addSubview:_mask];
    
    
    [self observeNotification:BeeUIRouter.STACK_DID_CHANGED];
    
    _tabbarOriginY = self.view.height - TAB_HEIGHT + 1;
    
    [_router open:@"main" animated:NO];
}

ON_DELETE_VIEWS( signal )
{
    _router = nil;
    _mask = nil;
    _splash = nil;
    
    [self unobserveAllNotifications];
}

ON_LAYOUT_VIEWS( signal )
{
    
    bee.ui.tabbar_iPad.frame = CGRectMake( 0, _tabbarOriginY, self.view.width, TAB_HEIGHT );
    bee.ui.router.view.frame = CGRectMake( 0, 0, self.view.width, self.view.height );
//    _router.view.frame = self.bounds;
    
    _router.view.frame = CGRectOffset( _router.view.frame, _router.view.panOffset.x, 0 );
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
    _router.view.pannable = NO;
}

ON_WILL_DISAPPEAR( signal )
{
    _router.view.pannable = NO;
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

#pragma mark - Tab
ON_SIGNAL2( AppTab_iPhone, signal )
{
    [super handleUISignal:signal];
    if ( [signal is:AppTab_iPad.TAB_SELECTED] )
    {
        int tabIndex = ((NSNumber *)signal.object).intValue;
        if (tabIndex == 0)
        {
            [bee.ui.tabbar_iPad updateBadge:0 TabIndex:0];
            [bee.ui.router open:AppBoard_iPad.TAB_HOME animated:NO];
        }
        else if (tabIndex == 1)
        {
            
        }
    }
}

#pragma mark -

- (void)showTabbar
{
    _tabbarOriginY = self.view.height - TAB_HEIGHT + 1;
    
    CGRect tabbarFrame = bee.ui.tabbar_iPad.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    bee.ui.tabbar_iPad.frame = tabbarFrame;
    
    [UIView commitAnimations];
}

- (void)hideTabbar
{
    _tabbarOriginY = self.view.height;
    
    CGRect tabbarFrame = bee.ui.tabbar_iPad.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    bee.ui.tabbar_iPad.frame = tabbarFrame;
    
    [UIView commitAnimations];
}


#pragma mark -

//屏幕唤醒
-(void)becomeActive
{
//    if ([SoftInfoModel sharedInstance].bMustUpdateVersion)
//    {
//        [[MainBoard_iPhone sharedInstance] checkUpdateVersion];
//    }
}

@end
