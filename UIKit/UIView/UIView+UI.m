//
//  UIView+UI.m
//  ksh3
//
//  Created by songlin on 07/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UIView+UI.h"

@implementation UIView (UI)


+(UIView *)createViewWithRadius:(CGFloat)raidus borderW:(CGFloat)borderW borderC:(UIColor *)borderC backgroundC:(UIColor *)backgroundC{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = backgroundC;
    view.layer.cornerRadius = raidus;
    view.layer.masksToBounds = YES;
    if (borderC) {
        view.layer.borderColor = borderC.CGColor;
    }
    return view;
}
@end
