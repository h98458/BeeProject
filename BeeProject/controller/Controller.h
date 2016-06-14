//
//  controller.h
//  Voiceprint
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "Bee.h"

@class STATUS;
@class PHOTO;
@class CONFIG;
@class SESSION;
@class PAGINATED;
@class COOKIE;
@class USER;

@interface STATUS : NSObject
@property (nonatomic, retain) NSNumber *		error_code;
@property (nonatomic, retain) NSString *		error_desc;
@property (nonatomic, retain) NSNumber *		succeed;
@end

@interface PHOTO : NSObject
@property (nonatomic, retain) NSString *		img;
@property (nonatomic, retain) NSString *		thumb;
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSString *		small;
@end

@interface SESSION : NSObject
@property (nonatomic, retain) NSString *		session;
@end

@interface PAGINATED : NSObject
@property (nonatomic, retain) NSNumber *		count;
@property (nonatomic, retain) NSNumber *		more;
@property (nonatomic, retain) NSNumber *		total;
@end

@interface PAGINATION : NSObject
@property (nonatomic, retain) NSNumber *		count;
@property (nonatomic, retain) NSNumber *		page;
@end

//cookie对像
@interface COOKIE : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSNumber *version;
@property (nonatomic, retain) NSString *expiresDate;
@property (nonatomic, retain) NSString *created;
@property (nonatomic, retain) NSNumber *sessionOnly;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSNumber *isSecure;
@end

@interface CONFIG : NSObject
@property (nonatomic, retain) NSString *		site_url;
//alipay
@property (nonatomic, retain) NSString *alipay_account;
@property (nonatomic, retain) NSString *alipay_partner;
@property (nonatomic, retain) NSString *rsa_private_key;
@property (nonatomic, retain) NSString *ali_public_key;
@property (nonatomic, retain) NSString *alipay_notify_url;
//wx
@property (nonatomic, retain) NSString *wxpay_app_id;
@property (nonatomic, retain) NSString *wxpay_app_secret;
@property (nonatomic, retain) NSString *wxpay_partnerid;
@property (nonatomic, retain) NSString *wxpay_partnerkey;
@end


@interface USER : NSObject
@property (nonatomic, retain) NSNumber *        id;
@property (nonatomic, retain) NSString *		phone;
@property (nonatomic, retain) NSString *        nickname;
@property (nonatomic, retain) NSString *		headico;
@property (nonatomic, retain) NSString *		birthday;
@property (nonatomic, retain) NSString *		qq;
@property (nonatomic, retain) NSNumber *        sex;
@property (nonatomic, retain) NSNumber *        level;
@property (nonatomic, retain) NSNumber *        integral;
@property (nonatomic, retain) NSNumber *        integraltoday;
@property (nonatomic, retain) NSString *		email;
@property (nonatomic, retain) NSString *		regday;
@property (nonatomic, retain) NSNumber *        ifcheck;
@end




#pragma mark - Controller

@interface Controller : BeeController
{
    BeeHTTPRequest *req;
}

// POST config
AS_MESSAGE( config );

// POST user/info
AS_MESSAGE( user_info );

// POST user/signin 用户登录
AS_MESSAGE( user_signin );

// POST user/signup  注册
AS_MESSAGE( user_signup );

// POST user/signout  退出登录
AS_MESSAGE( user_signout );


//检测更新
AS_MESSAGE( check_update );
@end
