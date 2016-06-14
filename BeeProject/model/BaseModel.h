

#import "Bee.h"
#import "controller.h"

#pragma mark -

@interface BaseModel : BeeModel

@property (nonatomic, assign) BOOL	loaded;
@property (nonatomic, assign) STATUS *status;

- (void)loadCache;
- (void)saveCache;
- (void)clearCache;

@end

#pragma mark -

@interface SinglePageModel : BaseModel

- (void)fetchFromServer;

@end

#pragma mark -

@interface MultiPageModel : SinglePageModel

@property (nonatomic, assign) BOOL	more;

- (void)prevPageFromServer;
- (void)nextPageFromServer;

@end