//
//  seatDetailTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "seatDetailTableViewCell.h"

@implementation seatDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   // [self setSelectLabel:_selectLabel];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
-(void)initLabelWithArray:(NSArray*)array
{
    
    for (NSInteger i=0; i<array.count; i++) {
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30+i*(screen_width-30)/(array.count+1), 0, (screen_width-30)/(array.count+1), self.height)];
        lable.text=array[i];
        lable.font=[UIFont systemFontOfSize:13];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.numberOfLines=0;
        [self addSubview:lable];
    }
}
- (IBAction)codeBtn:(id)sender {
    self.codeBlock();
}

//-(void)setSelectLab:(UILabel *)selectLab
//{
//    _selectLabel = selectLab;
//    _selectLabel.layer.cornerRadius = 10;
//    _selectLabel.layer.masksToBounds = YES;
//    _selectLabel.backgroundColor = [UIColor whiteColor];
//    _selectLabel.layer.borderWidth = 1;
//    _selectLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//}

-(void)setSelectLabel:(UILabel *)selectLabel
{
        _selectLabel = selectLabel;
        _selectLabel.layer.cornerRadius = 10;
        _selectLabel.layer.masksToBounds = YES;
        _selectLabel.backgroundColor = [UIColor whiteColor];
        _selectLabel.layer.borderWidth = 1;
        _selectLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
