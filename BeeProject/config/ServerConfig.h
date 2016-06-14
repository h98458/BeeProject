

#import "Bee.h"

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )

@property (nonatomic, copy) NSString * appName;

@property (nonatomic, copy) NSString * serviceUrl;

@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * bundleId;

@property (nonatomic, copy) NSString * system;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * interfaceVer;//接口版本

@end
