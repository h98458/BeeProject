

#import "Bee.h"
#import "BaseBoard_iPad.h"

@interface WebViewBoard_iPad : BaseBoard_iPad<UIWebViewDelegate>

@property (nonatomic, assign) BOOL				showLoading;
@property (nonatomic, retain) BeeUIWebView *	webView;
@property (nonatomic, copy) NSString *			urlString;
@property (nonatomic, copy) NSString *          htmlString;
@property (nonatomic, copy) NSString *			defaultTitle;

@property (nonatomic, assign) BOOL              isSetTitleForUpdateUI;
@property (nonatomic, assign) BOOL              isUseDefaultBack;

- (void)refresh;
-(NSString *)getUrlParameter:(NSString *)param webaddress:(NSString *)url;
@end
