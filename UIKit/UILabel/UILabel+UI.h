//
//  UILabel+UI.h
//  ksh3
//
//  Created by songlin on 07/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UI)

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor;
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(NSInteger)fontSize;

@end
