//  MainBoard_iPad.h
//  BeeProject
//
//  Created by huangrg on 14-9-2.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "Bee.h"
#import "BaseBoard_iPad.h"

#pragma mark -
@interface MainBoard_iPad : BaseBoard_iPad
AS_SINGLETON( MainBoard_iPad )
AS_SIGNAL( VERSION_UPDATE )

-(void)checkUpdateVersion;
@end
