//
//  NSString+NS.h
//  ksh3
//
//  Created by songlin on 08/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NS)

/**
 *计算字体size
 */
+ (CGSize)lableHeightWithString:(NSString *)str font:(NSInteger)font maxSize:(CGSize)size;

/**
 *计算字体size 包含行距5
 */
+ (CGSize)lableHeightWithStringLine:(NSString *)str line:(CGFloat)line font:(NSInteger)font maxSize:(CGSize)size;

/**
 *获取中文字符串
 */
+ (NSString *)getChineseStringWithString:(NSString *)string;


/**
 *设置行间距和字间距
 *@param line 行间距
 *@param content:内容
 *@param font 字体大小
 */
+ (NSString *)setLineSpace:(CGFloat)line content:(NSString *)content font:(CGFloat)font;

@end
