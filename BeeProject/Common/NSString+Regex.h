//
//  NSString+Regex.h
//  WeidiCellar
//
//  Created by huangrg on 14-12-11.
//  Copyright (c) 2014年 huangrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
- (BOOL)isZipcode;
- (BOOL)isNickName;
//身份证号
- (BOOL)isIdentityCard;
//银行卡号
- (BOOL)isBankCard;
- (BOOL)isNumber;
@end
