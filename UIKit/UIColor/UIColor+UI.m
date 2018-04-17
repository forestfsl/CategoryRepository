//
//  UIColor+UI.m
//  ksh3
//
//  Created by songlin on 06/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UIColor+UI.h"

@implementation UIColor (UI)


+ (UIColor *)sl_backgroundColor{
    return [UIColor sl_colorWithHexString:@"eeeeee"];
}

+ (UIColor *)sl_separatorColor{
    return [UIColor sl_colorWithHexString:@"e5e5e5"];
}

+(UIColor *)sl_colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (instancetype)colorWithRandomRGB {
    return [UIColor colorWithRedUInt8Value:arc4random_uniform(256) greedUInt8Value:arc4random_uniform(256) blueUInt8Value:arc4random_uniform(256) alpha:1.0f];
}

+ (instancetype)colorWithRedUInt8Value:(uint8_t)red greedUInt8Value:(uint8_t)greed blueUInt8Value:(uint8_t)blue alpha:(CGFloat)alpha{
    uint8_t r = red & 0xff;
    uint8_t g = greed & 0xff;
    uint8_t b = blue & 0xff;
    
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:alpha];
}

@end
