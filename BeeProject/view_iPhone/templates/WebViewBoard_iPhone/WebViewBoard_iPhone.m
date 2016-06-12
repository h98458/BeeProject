

#import "WebViewBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation WebViewBoard_iPhone
{
	BOOL _showLoading;
}

@synthesize showLoading = _showLoading;
@synthesize defaultTitle = _defaultTitle;

- (void)load
{
	[super load];
	self.isSetTitleForUpdateUI = YES;
	self.showLoading = YES;
    self.isUseDefaultBack = YES;
}

- (void)unload
{
	self.htmlString = nil;
	self.urlString = nil;
	self.defaultTitle = nil;
	
	[super unload];
}

#pragma mark Signal

ON_CREATE_VIEWS( signal )
{
    if ( self.defaultTitle && self.defaultTitle.length )
    {
        self.navigationBarTitle = self.defaultTitle;
    }
    else
    {
        self.navigationBarTitle = nil;
    }
    
    _webView = [[BeeUIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    [self refresh];
    
    [self updateUI];
    [self observeNotification:BeeUIRouter.STACK_DID_CHANGED];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveAllNotifications];
    [self.webView stopLoading];
}

ON_LAYOUT_VIEWS( signal )
{
    _webView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard hideTabbar];
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
    [self.stack popBoardAnimated:YES];
//    if (self.webView.canGoBack)
//    {
//        [self.webView goBack];
//    }
//    else
//    {
//        if (self.isUseDefaultBack)
//        {
//            [self.stack popBoardAnimated:YES];
//        }
//        
//    }
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

- (void)refresh
{
    if ( self.urlString )
    {
        self.webView.url = self.urlString;
    }
    else if ( self.htmlString )
    {
//        NSURL *baseUrl = [NSURL URLWithString:[ConfigModel sharedInstance].config.site_url];
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    }
}

- (void)updateUI
{
	NSString * title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	if ( title && title.length )
	{
        if (self.isSetTitleForUpdateUI) {
            self.navigationBarTitle = title;
        }
		
	}
}

-(NSString *)getUrlParameter:(NSString *)param webaddress:(NSString *)url
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches)
    {
        
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return @"";
}

#pragma mark - UIWebViewDelegate
ON_SIGNAL2( BeeUIWebView, signal )
{
	[self updateUI];
    if ( [signal is:BeeUIWebView.DID_START] )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] )
    {
        [self dismissTips];
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_CANCELLED] )
    {
        [self dismissTips];
    }
    else if( [signal is:BeeUIWebView.DID_LOAD_FAILED] )
    {
        [self dismissTips];
    }
}

@end
