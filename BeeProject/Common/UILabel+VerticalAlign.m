//
//  UILabel+VerticalAlign.m
//  huangrg_ios
//
//  Created by huangrg on 13-12-11.
//  Copyright (c) 2013年 huangrg. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)
-(void)alignTop {
    CGSize fontSize =[self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height *self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text =[self.text stringByAppendingString:@"\n "];
}

-(void)alignBottom {
    CGSize fontSize =[self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height *self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text =[NSString stringWithFormat:@" \n%@",self.text];
}

-(void)keyWordRed:(NSString *)keyword
{
    NSString *result = self.text;
    
    // 设置标签文字
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:result];
    
    // 获取标红的位置和长度
    NSRange range = [result rangeOfString:keyword];
    
    // 设置标签文字的属性
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
    
    // 显示在Label上
    self.attributedText = attrituteString;
    
}

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.height;
}

@end
