

#import "PHOTO+AutoSelection.h"
#import "ConfigModel.h"

#pragma mark -

@implementation PHOTO(AutoSelection)

- (NSString *)largeURL
{
	if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_AUTO )
	{
		if ( [BeeReachability isReachableViaWIFI] )
		{
			return self.img ? self.img : (self.url ? self.url : self.thumb);
		}
		else
		{
			return self.thumb ? self.thumb : self.small;
		}
	}
	else if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_HIGH )
	{
		return self.img ? self.img : (self.url ? self.url : self.thumb);
	}
	else
	{
		return self.thumb ? self.thumb : (self.url ? self.url : self.img);
	}
}

- (NSString *)thumbURL
{
	if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_AUTO )
	{
		if ( [BeeReachability isReachableViaWIFI] )
		{
			return self.thumb ? self.thumb : self.small;
		}
		else
		{
			return self.small ? self.small : self.thumb;
		}
	}
	else if ( [ConfigModel sharedInstance].photoMode == ConfigModel.PHOTO_MODE_HIGH )
	{
		return self.thumb ? self.thumb : self.small;
	}
	else
	{
		return self.small ? self.small : self.thumb;
	}
}

@end
