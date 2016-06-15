

#import "ServerConfig.h"

#pragma mark -

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

@synthesize appName = _appName;
@synthesize serviceUrl = _serviceUrl;
@synthesize appId = _appId;
@synthesize bundleId = _bundleId;
@synthesize system = _system;
@synthesize key = _key;
@synthesize interfaceVer = _interfaceVer;

- (id)init
{
	self = [super init];
	if ( self )
	{
        //公共服务端地址
        self.serviceUrl = @"";

        self.appId = @"";
        self.bundleId = @"";
        
        self.system = @"";
        self.key = @"";
        self.interfaceVer = @"0";
        
        self.appName = @"";
	}
	return self;
}


@end
