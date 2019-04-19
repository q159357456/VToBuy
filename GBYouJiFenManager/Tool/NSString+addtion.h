//
//  NSString+addtion.h
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/10.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (addtion)
-(NSString *)URLEncodedString;
-(NSString*)removeZeroWithStr;
- (CGRect)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
-(NSString*)zhuanhuan;
@end
