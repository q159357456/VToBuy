//
//  NSString+addtion.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/10.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "NSString+addtion.h"

@implementation NSString (addtion)
-(NSString *)URLEncodedString
{
   
    
    NSString* encodedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}
-(NSString*)removeZeroWithStr
{
    float f=self.floatValue;

    return [NSString stringWithFormat:@"%.2f",f];
}
- (CGRect)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
}
-(NSString*)zhuanhuan
{
    
    NSString *string1=[self stringByReplacingOccurrencesOfString:@"," withString:@""];
    float f=string1.floatValue;
    
    return [NSString stringWithFormat:@"%.2f",f];;
    
    
    
}
@end
