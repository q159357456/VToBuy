//
//  FontSizeTools.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/7.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FontSizeTools.h"

@implementation FontSizeTools
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text sizeWithAttributes:attrs];
}
@end
