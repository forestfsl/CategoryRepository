//
//  UICollectionView+UI.m
//  ksh3
//
//  Created by songlin on 06/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import "UICollectionView+UI.h"

@implementation UICollectionView (UI)

+(instancetype)configureCollectionViewWithDirection:(UICollectionViewScrollDirection)direction{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [UICollectionView configureCollectionViewWithFrame:CGRectZero flowLayout:layout backGroundColor:[UIColor whiteColor]];
    
    return collectionView;

}

+ (instancetype)configureCollectionViewWithFrame:(CGRect)frame flowLayout:(UICollectionViewLayout *)flowLayout backGroundColor:(UIColor *)bacGroundColor{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    collectionView.backgroundColor = bacGroundColor;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;

    return collectionView;
}

@end
