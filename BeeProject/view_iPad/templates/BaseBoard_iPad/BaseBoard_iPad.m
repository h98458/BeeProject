

#import "BaseBoard_iPad.h"

#pragma mark -

@interface BaseBoard_iPad()
{
	
}
@end

#pragma mark -

@implementation BaseBoard_iPad
@synthesize  scroll = _scroll;

#pragma mark -

#pragma mark Signal

ON_CREATE_VIEWS( signal )
{
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
    self.view.backgroundColor = [UIColor colorWithString:@"#f3f3f3"];
    self.allowedSwipeToBack = NO;
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_LOAD_DATAS( signal )
{
}

ON_WILL_APPEAR( signal )
{
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

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
