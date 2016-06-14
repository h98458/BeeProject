//
//  NSData+CRC32.h
//  Voiceprint
//
//  Created by huangrg on 14-9-4.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CRC32)
+ (NSString *)CRC32 :( NSData *)input;
- (NSString *)CRC32;
@end
