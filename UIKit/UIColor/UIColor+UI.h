//
//  UIColor+UI.h
//  ksh3
//
//  Created by songlin on 06/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UI)

/**
 *16 进制
 */
+ (UIColor *)sl_colorWithHexString:(NSString *)color;

/**
 *分割线
 */
+ (UIColor *)sl_separatorColor;

/**
 *tableView backgroundColor
 */
+ (UIColor *)sl_backgroundColor;

/*!
 *  @brief 通过输入UInt8的RGB以及alpha值实例化 UIColor
 *
 *  @param red   Red（0~255）
 *  @param greed Green（0~255）
 *  @param blue  Blue（0~255）
 *  @param alpha alpha（0.0~1.0）
 *
 *  @return UIColor
 */
+ (instancetype)colorWithRedUInt8Value:(uint8_t)red greedUInt8Value:(uint8_t)greed blueUInt8Value:(uint8_t)blue alpha:(CGFloat)alpha;



/*!
 *  @brief 根据随机 RGB 值实例化 UIColor
 *
 *  @return UIColor
 */
+ (instancetype)colorWithRandomRGB;


@end
