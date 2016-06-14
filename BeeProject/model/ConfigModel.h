

#import "Bee.h"
#import "controller.h"
#import "BaseModel.h"

#pragma mark -

@interface ConfigModel : BaseModel

AS_SINGLETON( ConfigModel )

AS_NOTIFICATION( UPDATED )
AS_NOTIFICATION( UPDATED_FAILED )

AS_INT( PHOTO_MODE_AUTO )
AS_INT( PHOTO_MODE_HIGH )
AS_INT( PHOTO_MODE_LOW )

@property (nonatomic, retain) CONFIG *		config;
@property (nonatomic, assign) NSUInteger	photoMode;
@property (nonatomic, assign) BOOL	success;

- (void)update;

@end
