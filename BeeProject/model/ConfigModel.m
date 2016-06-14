

#import "ConfigModel.h"

#pragma mark -

@implementation ConfigModel

DEF_SINGLETON( ConfigModel )

DEF_NOTIFICATION( UPDATED )
DEF_NOTIFICATION( UPDATED_FAILED )

DEF_INT( PHOTO_MODE_AUTO,	0 )
DEF_INT( PHOTO_MODE_HIGH,	1 )
DEF_INT( PHOTO_MODE_LOW,	2 )

@synthesize config = _config;
@synthesize photoMode = _photoMode;
@synthesize success = _success;

- (void)load
{
	[super load];
    self.config = [[CONFIG alloc] init];
    self.success = NO;
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
	
	self.config = nil;

	[super unload];
}

#pragma mark -

- (void)loadCache
{
	self.config = [CONFIG readFromUserDefaults:@"ConfigModel.config"];
	self.photoMode = [[self userDefaultsRead:@"ConfigModel.photoMode"] integerValue];
}

- (void)saveCache
{
	[self.config saveToUserDefaults:@"ConfigModel.config"];
	[self userDefaultsWrite:__INT(self.photoMode) forKey:@"ConfigModel.photoMode"];
}

- (void)clearCache
{
	self.config = nil;
	self.photoMode = self.PHOTO_MODE_AUTO;

	self.loaded = NO;
}

#pragma mark -

- (void)update
{
	self.CANCEL_MSG( Controller.config );
	self.MSG( Controller.config );
}

#pragma mark -config
ON_MESSAGE3( Controller, config, msg )
{
    if ( msg.succeed )
    {
        STATUS * status = msg.GET_OUTPUT( @"status" );
        if ( NO == status.succeed.boolValue )
        {
            msg.errorCode = status.error_code.intValue;
            msg.errorDesc = status.error_desc;
            msg.failed = YES;
            return;
        }
        
        self.config = msg.GET_OUTPUT( @"config" );
        self.loaded = YES;
        [self saveCache];
        self.success = YES;
        [self postNotification:self.UPDATED];
    }
    else if ( msg.failed )
    {
        [self postNotification:self.UPDATED_FAILED];
    }
}

@end
