//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "PullLoader.h"

#pragma mark -

@implementation PullLoader
SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )
- (void)load
{
	$(@"#state").DATA( __TEXT(@"tips_release_refresh") );
	$(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
}

- (void)unload
{
}

- (void)changeState:(NSInteger)state animated:(BOOL)animated
{
    [super changeState:state animated:animated];
    
    BeeUIImageView *				arrow = (BeeUIImageView *)$(@"#arrow").view;
    BeeUIActivityIndicatorView *	indicator = (BeeUIActivityIndicatorView *)$(@"#ind").view;
    
    if ( self.animated )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
    }
    
    if ( self.pulling )
    {
        arrow.hidden = NO;
        arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
        
        $(@"#state").DATA( __TEXT(@"tips_release_refresh") );
        $(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
    }
    else if ( self.loading )
    {
        [indicator startAnimating];
        
        arrow.hidden = YES;
        
        $(@"#state").DATA( __TEXT(@"tips_loading") );
        $(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
    }
    else
    {
        arrow.hidden = NO;
        arrow.transform = CGAffineTransformIdentity;
        
        [indicator stopAnimating];
        
        $(@"#state").DATA( __TEXT(@"tips_pull_refresh") );
        $(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
    }
    
    if ( self.animated )
    {
        [UIView commitAnimations];
    }
    
    self.RELAYOUT();
}

//#pragma mark -
//ON_SIGNAL3( PullLoader, STATE_CHANGED, signal )
//{
//    BeeUIImageView *				arrow = (BeeUIImageView *)$(@"#arrow").view;
//    BeeUIActivityIndicatorView *	indicator = (BeeUIActivityIndicatorView *)$(@"#ind").view;
//    if ( self.animated )
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.3f];
//    }
//    
//    if ( self.pulling )
//    {
//        arrow.hidden = NO;
//        arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
//        
//        $(@"#state").DATA( __TEXT(@"tips_release_refresh") );
//        $(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
//    }
//    else if ( self.loading )
//    {
//        [indicator startAnimating];
//        
//        arrow.hidden = YES;
//        
//        $(@"#state").DATA( __TEXT(@"tips_loading") );
//        $(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
//    }
//    else
//    {
//        arrow.hidden = NO;
//        arrow.transform = CGAffineTransformIdentity;
//        
//        [indicator stopAnimating];
//        
//        $(@"#state").DATA( __TEXT(@"tips_pull_refresh") );
//        $(@"#date").DATA( [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"yyyy-MM-dd hh:mm"]] );
//    }
//    
//    if ( self.animated )
//    {
//        [UIView commitAnimations];
//    }
//}

@end
