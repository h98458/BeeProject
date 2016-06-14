//
//  controller.m
//  Voiceprint
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "Controller.h"
#import "ServerConfig.h"
#import "NSData+CRC32.h"
#import "PublicFunc.h"
#import "GTMBase64.h"
#import "ConfigModel.h"

@implementation STATUS
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;
@end

@implementation PHOTO
@synthesize img = _img;
@synthesize thumb = _thumb;
@synthesize url = _url;
@synthesize small = _small;
@end

@implementation CONFIG
@synthesize site_url = _site_url;

@synthesize alipay_account = _alipay_account;
@synthesize alipay_partner = _alipay_partner;
@synthesize rsa_private_key = _rsa_private_key;
@synthesize ali_public_key = _ali_public_key;
@synthesize alipay_notify_url = _alipay_notify_url;

@synthesize wxpay_app_id = _wxpay_app_id;
@synthesize wxpay_app_secret = _wxpay_app_secret;
@synthesize wxpay_partnerid = _wxpay_partnerid;
@synthesize wxpay_partnerkey = _wxpay_partnerkey;
@end

@implementation USER
@synthesize id = _id;
@synthesize phone = _phone;
@synthesize nickname = _nickname;
@synthesize headico = _headico;
@synthesize birthday = _birthday;
@synthesize qq = _qq;
@synthesize sex = _sex;
@synthesize level = _level;
@synthesize integral = _integral;
@synthesize integraltoday = _integraltoday;
@synthesize email = _email;
@synthesize regday = _regday;
@synthesize ifcheck = _ifcheck;
@end

@implementation SESSION
@synthesize session = _session;
@end

//cookie对像
@implementation COOKIE
@synthesize name = _name;
@synthesize value = _value;
@synthesize version = _version;
@synthesize expiresDate = _expiresDate;
@synthesize created = _created;
@synthesize sessionOnly = _sessionOnly;
@synthesize domain = _domain;
@synthesize path = _path;
@synthesize isSecure = _isSecure;
@end

@implementation PAGINATED

@synthesize count = _count;
@synthesize more = _more;
@synthesize total = _total;

@end

@implementation PAGINATION

@synthesize count = _count;
@synthesize page = _page;

@end


@implementation Controller

//
//（1）取1-9随机数：rand(1,9)，得到整数Int1。
//（2）该各字符串相加：system+command+KEY+info+time+Int1，得到字符串Str1。
//（3）取Str1的MD5值：md5(Str1)，得到字符串Str2。
//（4）按Int1截取Str2，取7位字符：substr(Str2,Int1,7)，得到字符串Str3。
//（5）把Int1加在Str3后面，合成总长8位的通讯校验码。
//

-(NSString *)getValcode:(NSString *)command info:(NSString *)info time:(NSString *)time
{
    NSString *valcode = nil;
    int int1 = [[PublicFunc getInstance] getRandomNumber:1 to:9];
    NSString *str1 = [NSString stringWithFormat:@"%@%@%@%@%@%d",[ServerConfig sharedInstance].system,command,[ServerConfig sharedInstance].key,info,time,int1];
    NSString *str2 = str1.MD5;
    NSString *str3 = [str2 substringWithRange:NSMakeRange(int1,7)];
    valcode = [NSString stringWithFormat:@"%@%d",str3,int1];
    return valcode;
}

#pragma mark - POST config

DEF_MESSAGE_( config, msg )
{
	if ( msg.sending )
	{
        //接口参数
        NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
        requestBody.APPEND( @"type", @"2" );//（0:全部 1：Android，2:IOS，3：WP）
        
        //统一参数
        NSString *system = [ServerConfig sharedInstance].system;
        NSString *command = @"Config.GetConfigInfo";
        NSString *info = requestBody.objectToString;
        NSString *time = [NSString stringWithFormat:@"%llu",[NSDate timeStamp]];
        NSString *valcode = [self getValcode:command info:info time:time];
        NSString *appver = [NSString stringWithFormat:@"I%@",[ServerConfig sharedInstance].interfaceVer];
        
        
        //post
        NSString * requestURI = [ServerConfig sharedInstance].serviceUrl;
        msg.HTTP_POST( requestURI ).PARAMS(@"system", system,@"command", command,@"info", info,@"time", time,@"valcode", valcode,@"appver", appver,nil);
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		CONFIG * config = [CONFIG objectFromDictionary:[response dictAtPath:@"data"]];
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];

		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}
        
		msg.OUTPUT( @"config", config );
		msg.OUTPUT( @"status", status );
        
	}
	else if ( msg.failed )
	{
        NSLog(@"Config.GetConfigInfo.failed");
    }
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/info

DEF_MESSAGE_( user_info, msg )
{
	if ( msg.sending )
	{
        //接口参数
        SESSION * session = msg.GET_INPUT( @"session" );
        USER *user = msg.GET_INPUT( @"user" );
        
        NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
        requestBody.APPEND( @"session", session.session );
        requestBody.APPEND( @"phone", user.phone );
        
        //统一参数
        NSString *system = [ServerConfig sharedInstance].system;
        NSString *command = @"Account.GetInfo";
        NSString *info = requestBody.objectToString;
        NSString *time = [NSString stringWithFormat:@"%llu",[NSDate timeStamp]];
        NSString *valcode = [self getValcode:command info:info time:time];
        NSString *appver = [NSString stringWithFormat:@"I%@",[ServerConfig sharedInstance].interfaceVer];
        
        //post
        NSString * requestURI = [ConfigModel sharedInstance].config.site_url;
        msg.HTTP_POST( requestURI ).PARAMS(@"system", system,@"command", command,@"info", info,@"time", time,@"valcode", valcode,@"appver", appver,nil);
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
		USER * user = [USER objectFromDictionary:[response dictAtPath:@"data"]];
        
		if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
		{
			msg.failed = YES;
			return;
		}
        
		msg.OUTPUT( @"status", status );
		msg.OUTPUT( @"user", user );
        
	}
	else if ( msg.failed )
	{
        NSLog(@"Account.GetInfo.failed");
	}
	else if ( msg.cancelled )
	{
	}
}

#pragma mark - POST user/signin 用户登录
DEF_MESSAGE_( user_signin, msg )
{
	if ( msg.sending )
	{
        //接口参数
        NSString * phone = msg.GET_INPUT( @"phone" );
        NSString * password = msg.GET_INPUT( @"password" );
        NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
        requestBody.APPEND( @"phone", phone );
        requestBody.APPEND( @"pwd", password );
        
        //统一参数
        NSString *system = [ServerConfig sharedInstance].system;
        NSString *command = @"Account.Login";
        NSString *info = requestBody.objectToString;
        NSString *time = [NSString stringWithFormat:@"%llu",[NSDate timeStamp]];
        NSString *valcode = [self getValcode:command info:info time:time];
        NSString *appver = [NSString stringWithFormat:@"I%@",[ServerConfig sharedInstance].interfaceVer];
        
        //post
        NSString * requestURI = [NSString stringWithFormat:@"%@",[ConfigModel sharedInstance].config.site_url];
        msg.HTTP_POST( requestURI ).PARAMS(@"system", system,@"command", command,@"info", info,@"time", time,@"valcode", valcode,@"appver", appver,nil);
        
	}
	else if ( msg.succeed )
	{
        NSDictionary * response = msg.responseJSONDictionary;
        STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
        SESSION *session = [[SESSION alloc] init];
        session.session = [response stringAtPath:@"data.session"];
        USER *user = [USER objectFromDictionary:[response dictAtPath:@"data"]];
        
        if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
        {
            msg.failed = YES;
            return;
        }
        
        NSMutableArray *cookieList = [[NSMutableArray alloc] init];
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@login", [ServerConfig sharedInstance].url]];
//        NSArray *cookies = [storage cookiesForURL:URL];
        NSArray *cookies = storage.cookies;
        for (cookie in cookies)
        {
            COOKIE *_cookie = [[COOKIE alloc] init];
            _cookie.name = cookie.name;
            _cookie.value = cookie.value;
            _cookie.version = __INT(cookie.version);
            _cookie.expiresDate = _cookie.expiresDate;
            _cookie.domain = cookie.domain;
            _cookie.path = cookie.path;
            [cookieList addObject:_cookie];
        }
        
        msg.OUTPUT( @"status", status );
        msg.OUTPUT( @"user", user );
        msg.OUTPUT( @"cookieList", cookieList );
        msg.OUTPUT( @"session", session );
        
	}
	else if ( msg.failed )
	{
        NSLog(@"Account.Login.failed");
	}
	else if ( msg.cancelled )
	{
        
	}
}




#pragma mark - POST user/signup 注册

DEF_MESSAGE_( user_signup, msg )
{
    if ( msg.sending )
    {
        //接口参数
        NSString * phone = msg.GET_INPUT( @"phone" );
        NSString * name = msg.GET_INPUT( @"nickName" );
        NSString * password = msg.GET_INPUT( @"password" );
        NSMutableDictionary * requestBody = [NSMutableDictionary dictionary];
        requestBody.APPEND( @"phone", phone );
        requestBody.APPEND( @"name", name );
        requestBody.APPEND( @"pwd", password );
        
        //统一参数
        NSString *system = [ServerConfig sharedInstance].system;
        NSString *command = @"Account.Register";
        NSString *info = requestBody.objectToString;
        NSString *time = [NSString stringWithFormat:@"%llu",[NSDate timeStamp]];
        NSString *valcode = [self getValcode:command info:info time:time];
        NSString *appver = [NSString stringWithFormat:@"I%@",[ServerConfig sharedInstance].interfaceVer];
        
        //post
        NSString * requestURI = [ConfigModel sharedInstance].config.site_url;
        msg.HTTP_POST( requestURI ).PARAMS(@"system", system,@"command", command,@"info", info,@"time", time,@"valcode", valcode,@"appver", appver,nil);
    }
    else if ( msg.succeed )
    {
        NSDictionary * response = msg.responseJSONDictionary;
        STATUS * status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
        USER *user = [[USER alloc] init];
        user.phone = msg.GET_INPUT( @"phone" );
        
        SESSION *session = [[SESSION alloc] init];
        session.session = [response stringAtPath:@"data.session"];
        
        if ( nil == status || NO == [status isKindOfClass:[STATUS class]] )
        {
            msg.failed = YES;
            return;
        }
        
        NSMutableArray *cookieList = [[NSMutableArray alloc] init];
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [ServerConfig sharedInstance].serviceUrl]];
        NSArray *cookies = storage.cookies;
        for (cookie in cookies)
        {
            
            COOKIE *_cookie = [[COOKIE alloc] init];
            _cookie.name = cookie.name;
            _cookie.value = cookie.value;
            _cookie.version = __INT(cookie.version);
            _cookie.expiresDate = _cookie.expiresDate;
            _cookie.domain = cookie.domain;
            _cookie.path = cookie.path;
            [cookieList addObject:_cookie];
        }
        
        msg.OUTPUT( @"status", status );
        msg.OUTPUT( @"cookieList", cookieList );
        msg.OUTPUT( @"session", session );
        msg.OUTPUT( @"user", user );
    }
    else if ( msg.failed )
    {
        NSLog(@"Account.Register.failed");
    }
    else if ( msg.cancelled )
    {
        
    }
}

#pragma mark - POST user/signout 退出登录
DEF_MESSAGE_( user_signout, msg )
{
    if ( msg.sending )
	{
        
	}
	else if ( msg.succeed )
	{
        
        
	}
	else if ( msg.failed )
	{
	}
	else if ( msg.cancelled )
	{
	}
}



#pragma mark - 检测更新
DEF_MESSAGE_( check_update, msg )
{
	if ( msg.sending )
	{
//        NSString *appStoreLanguage = [[NSLocale currentLocale] localeIdentifier];
//        NSString *appStoreCountry = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
//        NSString *requestURI = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?country=%@&lang=%@&id=%@",appStoreCountry,appStoreLanguage,[ServerConfig sharedInstance].appId];
        NSString *requestURI = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",[ServerConfig sharedInstance].appId];
		
		msg.HTTP_POST( requestURI );
	}
	else if ( msg.succeed )
	{
		NSDictionary * response = msg.responseJSONDictionary;
		msg.OUTPUT( @"data", response );
        
	}
	else if ( msg.failed )
	{
        NSLog(@"check_update.failed");
	}
	else if ( msg.cancelled )
	{
        NSLog(@"cancelled");
	}
}
@end
