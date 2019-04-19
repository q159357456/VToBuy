//
//  EvaluatmanagTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "EvaluatmanagTableViewCell.h"
#import "StarEvaluator.h"
@interface EvaluatmanagTableViewCell()
@property (nonatomic, strong) StarEvaluator *starEvaluator;
@end

@implementation EvaluatmanagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAnswer:(UIButton *)answer
{
    _answer=answer;
    answer.layer.cornerRadius=8;
    answer.layer.masksToBounds=YES;
    answer.layer.borderColor=navigationBarColor.CGColor;
    answer.layer.borderWidth=1;
    [answer setTitleColor:navigationBarColor forState:UIControlStateNormal];
}
-(void)setDataWithModel:(evaluatModel *)model
{

    self.bHeight.constant=model.height;
    self.pHeight.constant=model.AnswerHeight;
    self.lable1.text=model.MS002;
    _lable2.numberOfLines = 0;
    _lable2.lineBreakMode = NSLineBreakByWordWrapping;
    self.lable2.text=model.Msg;
    _lable4.numberOfLines=0;
    _lable4.lineBreakMode=NSLineBreakByWordWrapping;
    _lable4.textColor=MainColor;
    _lable4.text=[NSString stringWithFormat:@"商家回复:%@",model.ReplyMsg];
    if (model.ReplyMsg.length)
    {
        self.answer.hidden=YES;
        
    }else
    {
        self.answer.hidden=NO;
  
    }

    self.lable3.text=[NSString stringWithFormat:@"评分: %@",model.Star];
    _lable3.font=[UIFont boldSystemFontOfSize:15];
    if ([model.Star floatValue]>0) {
            self.lable3.textColor=MainColor;
    }
    [self creatStarUIWithData:model.Star.floatValue];
}
-(void)creatStarUIWithData:(CGFloat)k
{
    //StarEvaluator星形评价
    self.starEvaluator = [[StarEvaluator alloc] initWithFrame:CGRectMake(18, 8, 120, 30)];

    [self  addSubview:_starEvaluator];
    self.starEvaluator.userInteractionEnabled = NO;
    self.starEvaluator.currentValue = k;

}

- (IBAction)answeClick:(UIButton *)sender {
    
    self.answerBlock();
}
//- (void)starEvaluator:(StarEvaluator *)evaluator currentValue:(float)value {
//    self.lable3.text = [NSString stringWithFormat:@"评分: %.1f",self.starEvaluator.currentValue];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
