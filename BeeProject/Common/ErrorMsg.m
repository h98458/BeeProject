

#import "Bee.h"
#import "model.h"
#import "ErrorMsg.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"

@implementation ErrorMsg

//DEF_SINGLETON( ErrorMsg )

+ (void)presentErrorMsg:(BeeMessage *)msg inBoard:(BeeUIBoard *)board;
{
    STATUS * status = msg.GET_OUTPUT( @"status" );
    if (!status)
    {
        NSDictionary * response = msg.responseJSONDictionary;
        status = [STATUS objectFromDictionary:[response dictAtPath:@"status"]];
    }
    
	if ( status )
	{
        if ([status.error_code isEqualToNumber:@-205] || [status.error_code isEqualToNumber:@-206])
        {
            [[UserModel sharedInstance] signout];
            if ( [BeeSystemInfo isDevicePad] )
            {
//                [bee.ui.appBoard_iPad showLogin];
            }
            else
            {
//                [bee.ui.appBoard_iPhone showLogin];
            }
        }
        
		NSString * errorDesc = status.error_desc;
		if ( errorDesc )
		{
			[board presentFailureTips:errorDesc];
			return;
		}
	}
	
	NSString * errorDesc2 = msg.errorDesc;
    if ( errorDesc2 )
    {
        [board presentFailureTips:errorDesc2];
		return;
    }

	if ( status.error_code )
	{
		NSString * multiLang = [NSString stringWithFormat:@"error_%@", status.error_code];
		NSString * errorDesc3 = __TEXT( multiLang );
		if ( errorDesc3 )
		{
			[board presentFailureTips:errorDesc3];
			return;
		}
	}
	
//	[self presentFailureTips:__TEXT(@"error_network")];
}

@end
