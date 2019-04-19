//
//  DosAgeView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "DosAgeView.h"
@interface DosAgeView ()

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end
@implementation DosAgeView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius=8;
        self.layer.masksToBounds=YES;

        
        
        
    }
    return self;
}
-(void)setDoneButton:(UIButton *)doneButton
{
    _doneButton=doneButton;
    _doneButton.backgroundColor=MainColor;
}
-(void)setCount:(NSInteger)count
{
    _count=count;
    self.lable.text=[NSString stringWithFormat:@"%ld",_count];
    
}
- (IBAction)pluse:(UIButton *)sender {
    if (_count>1) {
        _count--;
        self.lable.text=[NSString stringWithFormat:@"%ld",_count];
        
    }else
    {
        return;
        
    }

}
- (IBAction)mince:(UIButton *)sender {
    _count++;
    self.lable.text=[NSString stringWithFormat:@"%ld",_count];
  
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (IBAction)done:(UIButton *)sender {
    self.combBlock(_count);
}
@end
