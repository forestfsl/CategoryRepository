//
//  NSString+NS.m
//  ksh3
//
//  Created by songlin on 08/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "NSString+NS.h"

@implementation NSString (NS)


+ (CGSize)lableHeightWithString:(NSString *)str font:(NSInteger)font maxSize:(CGSize)size
{
    UIFont *tfont = [UIFont systemFontOfSize:font];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    CGSize sizeText = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return sizeText;
}

#pragma mark ---计算字体size(包含行距）
+ (CGSize)lableHeightWithStringLine:(NSString *)str line:(CGFloat)line font:(NSInteger)font maxSize:(CGSize)size
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = line;
    UIFont *tfont = [UIFont systemFontOfSize:font];
    NSDictionary *attributes = @{
                                 NSFontAttributeName:tfont,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    CGSize sizeText = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return sizeText;
}

+(NSString *)getChineseStringWithString:(NSString *)string{
    //(unicode中文编码范围是0x4e00~0x9fa5)
    for (int i = 0; i < string.length; i++) {
        int utfCode = 0;
        void *buffer = &utfCode;
        NSRange range = NSMakeRange(i, 1);
        
        BOOL b = [string getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
        
        if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)) {
            return [string substringFromIndex:i];
        }
    }
    return nil;
    
    
}


+(NSString *)setLineSpace:(CGFloat)line content:(NSString *)content font:(CGFloat )font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 100; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f,NSForegroundColorAttributeName:[UIColor redColor]};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:content attributes:dic];
    return attributeStr.string;
}


@end
