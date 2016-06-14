

#import "Bee.h"
#import "Controller.h"
#import "BaseModel.h"


#pragma mark -



@interface UserModel : BaseModel

AS_SINGLETON( UserModel )

@property (nonatomic, assign) BOOL		autoLogin;
@property (nonatomic, assign) BOOL		firstUse;
@property (nonatomic, retain) USER *	user;
@property (nonatomic, retain) SESSION *	session;
@property (nonatomic, retain) NSMutableArray *cookieList;

AS_NOTIFICATION( LOGIN )
AS_NOTIFICATION( LOGOUT )
AS_NOTIFICATION( KICKOUT )
AS_NOTIFICATION( UPDATED )

+ (BOOL)online;

- (void)setOnline:(BOOL)flag;
- (void)setOffline:(BOOL)flag;

//登录
- (void)signinWithUser:(NSString *)user
			  password:(NSString *)password;

//注册
- (void)signupWithUser:(NSString *)user
              nickName:(NSString *)nickName
			  password:(NSString *)password;


- (void)signout;
- (void)kickout;

@end
