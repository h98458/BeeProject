//
//  CommonUtil.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+(NSString *) md5:(NSString *)str;
+(NSString*) sha1:(NSString *)str;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

@end
