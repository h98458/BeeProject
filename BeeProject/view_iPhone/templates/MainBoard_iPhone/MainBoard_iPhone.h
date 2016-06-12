//  MainBoard_iPhone.h
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "Bee.h"
#import "BaseBoard_iPhone.h"

#pragma mark -
@interface MainBoard_iPhone : BaseBoard_iPhone
AS_SINGLETON( MainBoard_iPhone )
AS_SIGNAL( VERSION_UPDATE )

-(void)checkUpdateVersion;
@end
