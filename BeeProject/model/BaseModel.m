

#import "BaseModel.h"

#pragma mark -

@implementation BaseModel

@synthesize loaded = _loaded;
@synthesize status = _status;

- (void)load
{
	[super load];
	
	self.loaded = NO;
}

- (void)unload
{
	[super unload];
}

- (void)loadCache
{
}

- (void)saveCache
{
}

- (void)clearCache
{
	self.loaded = NO;
}

@end

#pragma mark -

@implementation SinglePageModel

- (void)fetchFromServer
{
}

@end

#pragma mark -

@implementation MultiPageModel

@synthesize more = _more;

- (void)load
{
	self.more = YES;
}

- (void)fetchFromServer
{
	[self prevPageFromServer];
}

- (void)prevPageFromServer
{
}

- (void)nextPageFromServer
{
}

@end
