//  AppBoard_iPhone.m
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "MainBoard_iPhone.h"
#import "AppTab_iPhone.h"

#pragma mark -

#undef	MENU_BOUNDS
#define	MENU_BOUNDS	(200.0f)


#pragma mark -

DEF_UI( AppBoard_iPhone, appBoard_iPhone )

#pragma mark -

@implementation AppBoard_iPhone
{
    
	BeeUIRouter *		_router;
	BeeUIButton *		_mask;
    
    CGFloat _tabbarOriginY;
    
    UIWindow *			_splash;
    CGRect				_origFrame;
    
}
DEF_SINGLETON( AppBoard_iPhone )
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
	[_router map:@"main" toClass:[MainBoard_iPhone class]];
	[self.view addSubview:_router.view];
    
    
//    bee.ui.router[self.TAB_HOME]	= [MainBoard_iPhone class];
//    
//    [self.view addSubview:bee.ui.router.view];
//    [self.view addSubview:bee.ui.tabbar];
//    
//    [bee.ui.router open:self.TAB_HOME animated:YES];
    
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
    bee.ui.tabbar_iPhone.frame = CGRectMake( 0, _tabbarOriginY, self.view.width, TAB_HEIGHT );
    bee.ui.router.view.frame = CGRectMake( 0, 0, self.view.width, self.view.height );
    _router.view.frame = self.bounds;
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

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        _origFrame = _router.view.frame;
        
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        [self syncPanPosition];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];
        
        CGFloat left = _router.view.left;
        CGFloat edge = MENU_BOUNDS;
        
        if ( left <= edge )
        {
            _router.view.left = 0;
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
        }
        else
        {
            _router.view.left = 250.0f;
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didMenuShown)];
        }
        
        [UIView commitAnimations];
    }
}

ON_SIGNAL2( mask, signal )
{
    [self hideMenu];
}

ON_SIGNAL3( BeeUIRouter, WILL_CHANGE, signal )
{
}

ON_SIGNAL3( BeeUIRouter, DID_CHANGED, signal )
{
    
}

ON_SIGNAL3( MenuBoard_iPhone, team, signal )
{
    [self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, about, signal )
{
    [self hideMenu];
}

- (void)didMenuHidden
{
    _mask.hidden = YES;
}

- (void)didMenuShown
{
    _mask.frame = CGRectMake( 250, 0.0, _router.bounds.size.width - 250.0f, _router.bounds.size.height );
    _mask.hidden = NO;
}

- (void)syncPanPosition
{
    _router.view.frame = CGRectOffset( _origFrame, _router.view.panOffset.x, 0 );
}

- (void)showMenu
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didMenuShown)];
    
    _router.view.left = 250.0f;
    
    [UIView commitAnimations];
}

- (void)hideMenu
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
    
    _router.view.left = 0.0f;
    
    [UIView commitAnimations];
}

#pragma mark - Tab
ON_SIGNAL2( AppTab_iPhone, signal )
{
    [super handleUISignal:signal];
    if ( [signal is:AppTab_iPhone.TAB_SELECTED] )
    {
        int tabIndex = ((NSNumber *)signal.object).intValue;
        if (tabIndex == 0)
        {
            [bee.ui.tabbar_iPhone updateBadge:0 TabIndex:0];
            [bee.ui.router open:AppBoard_iPhone.TAB_HOME animated:NO];
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
    
    CGRect tabbarFrame = bee.ui.tabbar_iPhone.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    bee.ui.tabbar_iPhone.frame = tabbarFrame;
    
    [UIView commitAnimations];
}

- (void)hideTabbar
{
    _tabbarOriginY = self.view.height;
    
    CGRect tabbarFrame = bee.ui.tabbar_iPhone.frame;
    tabbarFrame.origin.y = _tabbarOriginY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    bee.ui.tabbar_iPhone.frame = tabbarFrame;
    
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
