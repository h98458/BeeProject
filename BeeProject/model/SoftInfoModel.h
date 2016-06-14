//
//  SoftInfoModel.h
//  shop
//
//  Created by huangrg on 14-5-30.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "BaseModel.h"
#import "Controller.h"

@interface SoftInfoModel : SinglePageModel
AS_SINGLETON( SoftInfoModel )
@property (nonatomic, retain) NSDictionary *softInfo;
@property (nonatomic, assign) BOOL isNewVersion;
@property (nonatomic, assign) BOOL bMustUpdateVersion; //是否必须更新版本
@property (nonatomic, retain) NSMutableDictionary *versionInfo;
@end
