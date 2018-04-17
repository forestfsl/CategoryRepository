//
//  UIImageView+UI.m
//  ksh3
//
//  Created by songlin on 07/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UIImageView+UI.h"

@implementation UIImageView (UI)


+(instancetype)createImageVWithImgName:(NSString *)imgName{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:imgName];
    imageView.userInteractionEnabled = YES;
    return imageView;

}
@end
