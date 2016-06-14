//
//  UILabel+VerticalAlign.h
//  huangrg_ios
//
//  Created by huangrg on 13-12-11.
//  Copyright (c) 2013年 huangrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VerticalAlign)
-(void)alignTop;
-(void)alignBottom;
-(void)keyWordRed:(NSString *)keyword;
-(float)resizeToFit;
-(float)expectedHeight;
@end
