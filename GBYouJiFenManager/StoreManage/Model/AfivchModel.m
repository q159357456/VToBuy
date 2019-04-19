//
//  AfivchModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AfivchModel.h"

@implementation AfivchModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        AfivchModel *model=[[AfivchModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        [datArray addObject:model];
        UILabel *lable=[[UILabel alloc]init];
        
        lable.numberOfLines = 0;
        lable.text=dic1[@"Msg"];
        lable.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [lable sizeThatFits:CGSizeMake(screen_width-12, MAXFLOAT)];
        model.height=size.height;
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
