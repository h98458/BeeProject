//
//  SoftInfoModel.m
//  shop
//
//  Created by huangrg on 14-5-30.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SoftInfoModel.h"

@implementation SoftInfoModel
DEF_SINGLETON( SoftInfoModel )
@synthesize softInfo = _softInfo;
@synthesize isNewVersion = _isNewVersion;
@synthesize versionInfo = _versionInfo;
@synthesize bMustUpdateVersion = _bMustUpdateVersion;
- (void)load
{
	[super load];
    self.bMustUpdateVersion = NO;
}

- (void)unload
{
	self.softInfo = nil;
    self.versionInfo = nil;
	[super unload];
}

#pragma mark -

- (void)clearCache
{
	self.loaded = NO;
}

- (void)fetchFromServer
{
	self.CANCEL_MSG( Controller.check_update );
	self.MSG( Controller.check_update );
}

-(BOOL)checkUpdate:(NSString *)curVer AppStoreVer:(NSString *)appStoreVer
{
    NSArray *curList = [curVer componentsSeparatedByString:@"."];
    NSArray *appStoreList = [appStoreVer componentsSeparatedByString:@"."];
    //对位对比
    int nCur1 = [[curList objectAtIndex:0] intValue];
    int nCur2 = [[curList objectAtIndex:1] intValue];
    int nCur3 = [[curList objectAtIndex:2] intValue];
    
    int nAppStore1 = [[appStoreList objectAtIndex:0] intValue];
    int nAppStore2 = [[appStoreList objectAtIndex:1] intValue];
    int nAppStore3 = [[appStoreList objectAtIndex:2] intValue];
    
    if (nCur1<nAppStore1)
    {
        self.bMustUpdateVersion = YES;
        return YES;
    }
    else if (nCur1 == nAppStore1)
    {
        if (nCur2<nAppStore2)
        {
            self.bMustUpdateVersion = YES;
            return YES;
        }
        else if (nCur2 == nAppStore2)
        {
            if (nCur3<nAppStore3)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
    
    return NO;
}

#pragma mark -
#pragma mark -check_update
ON_MESSAGE3( Controller, check_update, msg )
{
    if ( msg.succeed )
    {
        self.softInfo = msg.GET_OUTPUT( @"data" );
        self.loaded = YES;
        
        int resultCount = [[_softInfo objectForKey:@"resultCount"] intValue];
        if (resultCount <= 0)
        {
            NSLog(@"AppStore找不到相应的App");
            return;
        }
        NSArray *infoArray = [_softInfo objectForKey:@"results"];
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        NSString *releaseNotes = [releaseInfo objectForKey:@"releaseNotes"];
        //本地版本
        NSString *appVer = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if ([self checkUpdate:appVer AppStoreVer:lastVersion])
        {
            if (self.versionInfo)
            {
                self.versionInfo = nil;
            }
            self.isNewVersion = YES;
            self.versionInfo = [NSMutableDictionary dictionary];
            NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
            [self.versionInfo setObject:lastVersion forKey:@"lastVersion"];
            [self.versionInfo setObject:releaseNotes forKey:@"releaseNotes"];
            [self.versionInfo setObject:trackViewUrl forKey:@"trackViewUrl"];
        }
        else
        {
            NSLog(@"已经是最新版本");
        }
        
        [self saveCache];
    }
}

@end
