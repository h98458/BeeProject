

#import "Bee.h"
#import "BaseBoard_iPhone.h"

@interface WebViewBoard_iPhone : BaseBoard_iPhone<UIWebViewDelegate>

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
