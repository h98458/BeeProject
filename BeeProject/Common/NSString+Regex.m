//
//  NSString+Regex.m
//  WeidiCellar
//
//  Created by huangrg on 14-12-11.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)
- (BOOL)isZipcode
{
    NSString *		regex = @"^[1-9]\\d{5}$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNickName
{
    NSString *		regex = @"^[\u4e00-\u9fa5]{2,16}$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isIdentityCard
{
    NSString *		regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isBankCard
{
    NSString *		regex = @"^[0-9]{15,19}$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *		regex = @"^[0-9]*$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
@end
