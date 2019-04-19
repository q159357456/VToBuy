//
//  AddressTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setChooseView:_selectBtn];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2*frame.origin.x;
    frame.size.height -= 2*frame.origin.x;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [super setFrame:frame];
}

-(void)setChooseView:(UIButton *)selectBtn
{
    _selectBtn=selectBtn;
    _selectBtn.layer.cornerRadius = 10;
    _selectBtn.layer.masksToBounds=YES;
//    _selectBtn.backgroundColor=[UIColor whiteColor];
    _selectBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _selectBtn.layer.borderWidth=1;
}
- (IBAction)editBtnClick:(id)sender {
    
    self.editBlock();
}

- (IBAction)deleteBtnClick:(id)sender {
    
    self.deleteBlock();
    
}
- (IBAction)setDefaultBtnClick:(id)sender {
    
    self.setDefaultBlock();
    
}
//shuoshenmedoushiwanranna
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
