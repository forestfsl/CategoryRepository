//
//  UICollectionView+UI.h
//  ksh3
//
//  Created by songlin on 06/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (UI)

+ (instancetype)configureCollectionViewWithDirection:(UICollectionViewScrollDirection)direction;

+ (instancetype)configureCollectionViewWithFrame:(CGRect)frame flowLayout:(UICollectionViewLayout *)flowLayout backGroundColor:(UIColor *)bacGroundColor;

@end
