

#import "UserModel.h"

#pragma mark -

@implementation UserModel

DEF_SINGLETON( UserModel )

@synthesize autoLogin = _autoLogin;
@synthesize firstUse = _firstUse;
@synthesize session = _session;
@synthesize user = _user;
@synthesize cookieList = _cookieList;


DEF_NOTIFICATION( LOGIN )
DEF_NOTIFICATION( LOGOUT )
DEF_NOTIFICATION( KICKOUT )
DEF_NOTIFICATION( UPDATED )

- (void)load
{
	[super load];
	
	self.firstUse = YES;
    self.autoLogin = YES;
    
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
    
	self.session = nil;
    
	[super unload];
}

-(void)setAutoLogin:(BOOL)autoLogin
{
    _autoLogin = autoLogin;
    if (!_autoLogin)
    {
        [self userDefaultsRemove:@"session"];
        [self userDefaultsRemove:@"user"];
        [self userDefaultsRemove:@"cookieList"];
        [self userDefaultsRemove:@"userType"];
    }
}

#pragma mark -

- (void)loadCache
{
	self.session = [SESSION objectFromDictionary:[[self userDefaultsRead:@"session"] objectFromJSONString]];
    self.user = [USER objectFromDictionary:[[self userDefaultsRead:@"user"] objectFromJSONString]];
    
    NSString * string = [self userDefaultsRead:@"cookieList"];
    if ( string )
    {
        self.cookieList = [COOKIE unserializeObject:[string objectFromJSONString]];
    }
    
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (COOKIE *_cookie in self.cookieList)
    {
        NSMutableDictionary *cookieProperties = [[NSMutableDictionary alloc] init];
        [cookieProperties setValue:_cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setValue:_cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setValue:_cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
        [cookieProperties setValue:_cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setValue:_cookie.version forKey:NSHTTPCookieVersion];
        [cookieProperties setValue:_cookie.expiresDate forKey:NSHTTPCookieExpires];
        
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
        [storage setCookie:cookie];
        
    }
 
	if ( self.session )
	{
		[self setOnline:YES];
	}
	else
	{
		[self setOffline:NO];
	}
    
}

- (void)saveCache
{
    [self userDefaultsWrite:[self.session objectToString] forKey:@"session"];
    [self userDefaultsWrite:[self.user objectToString] forKey:@"user"];
    
    NSString * string = [[self.cookieList serializeObject] JSONString];
    if ( string )
    {
        [self userDefaultsWrite:string forKey:@"cookieList"];
    }
}

#pragma mark -

+ (BOOL)online
{
	if ( [UserModel sharedInstance].session )
		return YES;
    
	return NO;
}



- (void)setOnline:(BOOL)notify
{
	[self saveCache];
    
	[BeeMessage setHeader:self.session forKey:@"session"];
    [BeeMessage setHeader:self.user forKey:@"user"];
    
	if ( notify )
	{
		[self postNotification:self.LOGIN];
	}
}

- (void)setOffline:(BOOL)notify
{
    [self userDefaultsRemove:@"session"];
	[self userDefaultsRemove:@"user"];
    [self userDefaultsRemove:@"cookieList"];
	
	[BeeMessage removeHeaderForKey:@"session"];
	[BeeMessage removeHeaderForKey:@"user"];
    
	self.session = nil;
    self.user = nil;
    [self.cookieList removeAllObjects];
    
	
	if ( notify )
	{
		[self postNotification:self.LOGOUT];
	}
}




#pragma mark -
//登录
- (void)signinWithUser:(NSString *)user
			  password:(NSString *)password
{
	self.CANCEL_MSG( Controller.user_signin );
	self
	.MSG( Controller.user_signin )
	.INPUT( @"phone", user )
	.INPUT( @"password", password.MD5.lowercaseString );
}



//注册
- (void)signupWithUser:(NSString *)user nickName:(NSString *)nickName password:(NSString *)password
{
    self.CANCEL_MSG( Controller.user_signup );
	self
	.MSG( Controller.user_signup )
	.INPUT( @"phone", user )
    .INPUT( @"nickName", nickName )
	.INPUT( @"password", password.MD5.lowercaseString );
}

- (void)signout
{
	self.CANCEL_MSG( Controller.user_signin );
	self.CANCEL_MSG( Controller.user_signup );
    self.MSG( Controller.user_signout );
    
	[self setOffline:YES];
	
	self.firstUse = NO;
}


- (void)kickout
{
	self.CANCEL_MSG( Controller.user_signin );
	self.CANCEL_MSG( Controller.user_signup );
	
	[self setOffline:NO];
	
	self.firstUse = NO;
	
	[self postNotification:self.KICKOUT];
}

//获取用户信息
- (void)getUserInfo
{
    self.CANCEL_MSG( Controller.user_info );
    self
    .MSG( Controller.user_info );
}



#pragma mark -

#pragma mark -user_signin
ON_MESSAGE3( Controller, user_signin, msg )
{
    if ( msg.succeed )
    {
        STATUS * status = msg.GET_OUTPUT( @"status" );
        if ( NO == status.succeed.boolValue )
        {
            msg.errorCode = status.error_code.integerValue;
            msg.errorDesc = status.error_desc;
            msg.failed = YES;
            return;
        }
        self.cookieList = msg.GET_OUTPUT(@"cookieList");
        self.session = msg.GET_OUTPUT( @"session" );
        self.user = msg.GET_OUTPUT( @"user" );
        
        [self setOnline:YES];
    }
}

#pragma mark -user_signup
ON_MESSAGE3( Controller, user_signup, msg )
{
    if ( msg.succeed )
    {
        STATUS * status = msg.GET_OUTPUT( @"status" );
        if ( NO == status.succeed.boolValue )
        {
            msg.errorCode = status.error_code.integerValue;
            msg.errorDesc = status.error_desc;
            msg.failed = YES;
            return;
        }
        self.cookieList = msg.GET_OUTPUT(@"cookieList");
        self.session = msg.GET_OUTPUT( @"session" );
        self.user = msg.GET_OUTPUT( @"user" );
        
        [self setOnline:YES];
    }
}

#pragma mark -user_info
ON_MESSAGE3( Controller, user_info, msg )
{
    if ( msg.succeed )
    {
        STATUS * status = msg.GET_OUTPUT( @"status" );
        if ( NO == status.succeed.boolValue )
        {
            msg.errorCode = status.error_code.integerValue;
            msg.errorDesc = status.error_desc;
            msg.failed = YES;
            return;
        }
        self.user = msg.GET_OUTPUT( @"user" );
        self.loaded = YES;
    }
}

@end
