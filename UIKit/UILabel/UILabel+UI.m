//
//  UILabel+UI.m
//  ksh3
//
//  Created by songlin on 07/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UILabel+UI.h"

@implementation UILabel (UI)

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor
{
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.userInteractionEnabled = YES;
    label.textColor = textColor;
    return label;
}

+(instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(NSInteger)fontSize{
    UILabel *label = [UILabel labelWithText:text textColor:textColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

@end
