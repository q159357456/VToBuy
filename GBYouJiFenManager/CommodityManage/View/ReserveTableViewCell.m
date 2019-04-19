//
//  ReserveTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ReserveTableViewCell.h"

@implementation ReserveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
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
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(30+i*(screen_width-30)/array.count, 0, (screen_width-30)/array.count, self.height)];
        lable.text=array[i];
        lable.font=[UIFont systemFontOfSize:13];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.numberOfLines=0;
        [self addSubview:lable];
    }
}

-(void)setSelectLab:(UILabel *)selectLab
{
    _selectLab = selectLab;
    _selectLab.layer.cornerRadius = 10;
    _selectLab.layer.masksToBounds = YES;
    _selectLab.backgroundColor = [UIColor whiteColor];
    _selectLab.layer.borderWidth = 1;
    _selectLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
