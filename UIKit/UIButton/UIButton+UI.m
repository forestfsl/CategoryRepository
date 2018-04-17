//
//  UIButton+UI.m
//  ksh3
//
//  Created by songlin on 07/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UIButton+UI.h"

@implementation UIButton (UI)

+(instancetype)createBtnWithNormalImg:(NSString *)normalImg{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
    return button;
}
@end
