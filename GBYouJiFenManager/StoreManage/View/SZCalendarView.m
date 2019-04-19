//
//  SZCalendarView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SZCalendarView.h"
#import "SZCalendarPicker.h"
@implementation SZCalendarView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
            SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self];
            calendarPicker.today = [NSDate date];
            calendarPicker.date = calendarPicker.today;
            
            calendarPicker.frame = CGRectMake(0,45, self.frame.size.width,self.height-45);
            calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
//                NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
//                NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
//                _inLabel1.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
             
            };
    }
    return self;
}
- (IBAction)start:(UIButton *)sender {
}
- (IBAction)end:(UIButton *)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
