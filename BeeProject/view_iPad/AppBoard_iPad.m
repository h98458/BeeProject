//  AppBoard_iPad.m
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "AppBoard_iPad.h"

#pragma mark -

@implementation AppBoard_iPad

DEF_SINGLETON( AppBoard_iPad )

- (void)load
{
}

- (void)unload
{
}

#pragma mark Signal

ON_CREATE_VIEWS( signal )
{
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

#pragma mark -
ON_LEFT_BUTTON_TOUCHED( signal )
{
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

@end
