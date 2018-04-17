//
//  NSMutableAttributedString+NS.m
//  ksh3
//
//  Created by songlin on 08/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "NSMutableAttributedString+NS.h"

@implementation NSMutableAttributedString (NS)

+(NSMutableAttributedString *)setLineSpace:(CGFloat)lineSpace font:(UIFont *)font content:(id)content color:(UIColor *)color{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = lineSpace;
    NSDictionary *dict1 = @{
                            NSFontAttributeName:font,
                            NSForegroundColorAttributeName:color,
                            NSParagraphStyleAttributeName:style};
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", content] attributes:dict1]];
    return attString;
}

@end
