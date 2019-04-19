//
//  evaluatModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "evaluatModel.h"

@implementation evaluatModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
       evaluatModel *model=[[evaluatModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        UILabel *lable=[[UILabel alloc]init];
        lable.numberOfLines = 0;
        lable.text=dic1[@"Msg"];
        lable.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [lable sizeThatFits:CGSizeMake(screen_width-32, MAXFLOAT)];
        model.height=size.height+8;
        if (model.ReplyMsg.length)
        {
            lable.text=[NSString stringWithFormat:@"商家回复:%@",dic1[@"ReplyMsg"]];
            CGSize size1 = [lable sizeThatFits:CGSizeMake(screen_width-32, MAXFLOAT)];
            model.AnswerHeight=size1.height+8;
        }else
        {
            model.AnswerHeight=0;
        }
      
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
