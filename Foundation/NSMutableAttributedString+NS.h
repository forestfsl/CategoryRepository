//
//  NSMutableAttributedString+NS.h
//  ksh3
//
//  Created by songlin on 08/09/2017.
//  Copyright © 2017 jianminxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (NS)

+(NSMutableAttributedString *)setLineSpace:(CGFloat)lineSpace font:(UIFont *)font content:(id)content color:(UIColor *)color;
@end
