

#import "Bee.h"

@interface ErrorMsg : NSObject

//AS_SINGLETON( ErrorMsg )

+ (void)presentErrorMsg:(BeeMessage *)msg inBoard:(BeeUIBoard *)board;

@end
