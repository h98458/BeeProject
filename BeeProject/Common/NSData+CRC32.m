//
//  NSData+CRC32.m
//  Voiceprint
//
//  Created by huangrg on 14-9-4.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "NSData+CRC32.h"
#import "zlib.h"

@implementation NSData (CRC32)
+ (NSString *)CRC32 :( NSData *)input
{
    uLong crcValue = crc32(0L, NULL, 0L);
    crcValue = crc32(crcValue, (const Bytef*)input.bytes, input.length);
    
    return [NSString stringWithFormat:@"%lu", crcValue];
}

- (NSString *)CRC32 {
    return [NSData CRC32:self];
}
@end
