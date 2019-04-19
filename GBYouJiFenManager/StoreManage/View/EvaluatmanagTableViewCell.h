//
//  EvaluatmanagTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "evaluatModel.h"
@interface EvaluatmanagTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bHeight;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UIButton *answer;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property (strong, nonatomic) IBOutlet UILabel *lable4;
@property(nonatomic,copy)void(^answerBlock)();
-(void)setDataWithModel:(evaluatModel*)model;
@end
