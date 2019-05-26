//
//  UIResponder+Event.m
//  ZHONGHUILAOWU
//
//  Created by 秦根 on 2018/7/16.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "UIResponder+Event.h"

@implementation UIResponder (Event)
-(void)FunEventName:(NSString *)eventName Para:(id)para
{
    if (self.nextResponder) {
        [self.nextResponder FunEventName:eventName Para:para];
    }
}
@end
