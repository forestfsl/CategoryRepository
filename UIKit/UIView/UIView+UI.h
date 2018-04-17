//
//  UIView+UI.h
//  ksh3
//
//  Created by songlin on 07/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UI)


/**
 *@param radius 
 *@param borderW width
 *@param borderC border Color
 *@param backgroundC background Color;
 */

+ (UIView *)createViewWithRadius:(CGFloat)raidus borderW:(CGFloat)borderW borderC:(UIColor *)borderC backgroundC:(UIColor *)backgroundC;

@end
