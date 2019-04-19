//
//  TaskFrameTableViewCell.m
//  gongbo.paid
//
//  Created by 工博计算机 on 16/9/23.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "TaskFrameTableViewCell.h"
#import "POSDIModel.h"
@interface TaskFrameTableViewCell()

@end
@implementation TaskFrameTableViewCell

+ (id)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"tags";
    TaskFrameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TaskFrameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)setTastStr:(NSString *)tastStr
{
    
    _tastStr=tastStr;
    if (!Tlable) {
        Tlable=[[UILabel alloc]initWithFrame:CGRectMake(10,10,200, 30)];
        Tlable.text=[NSString stringWithFormat:@"%@:",tastStr];
        Tlable.textColor=[UIColor redColor];
        Tlable.textAlignment=NSTextAlignmentLeft;
        [self addSubview:Tlable];
    }
 
    
}
- (void)setTagsFrame:(TagsFrame *)tagsFrame
{
   
    _dataArray=[NSMutableArray array];
    _tagsFrame = tagsFrame;
    
    for (NSInteger i=0; i<tagsFrame.tagsArray.count; i++) {
        POSDIModel *model=tagsFrame.tagsArray[i];
        model.tag=i+1;
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:model.DI002 forState:UIControlStateNormal];
       
        tagsBtn.titleLabel.font = TagsTitleFont;
        tagsBtn.backgroundColor = [UIColor whiteColor];
        tagsBtn.layer.borderWidth = 1;
        tagsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tagsBtn.layer.cornerRadius = 4;
        tagsBtn.layer.masksToBounds = YES;
        [tagsBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        

        tagsBtn.frame = CGRectFromString(tagsFrame.tagsFrames[i]);
        tagsBtn.tag=i+1;
        //选中状态
      
            [tagsBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
       
             [tagsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
        

        [self addSubview:tagsBtn];
    }
    
    
}
-(void)click:(UIButton*)butt
{
    //互斥规则
    POSDIModel *model=_tagsFrame.tagsArray[butt.tag-1];
    if (model.DI008.intValue==0)
    {
      
        if ([_dataArray containsObject:model])
        {
            // 如果包含
           
            butt.selected=NO;
            [_dataArray removeObject:model];
            
        }else
        {
            //如果不包含
         
            butt.selected=YES;
            [_dataArray addObject:model];
            
        }
       
    }else
    {
         NSLog(@"互斥的情况");
        if ([_dataArray containsObject:model])
        {
            //包含
            butt.selected=NO;
            [_dataArray removeObject:model];
            
        }else
        {
            for (POSDIModel *pmodel in _dataArray)
            {
                if (model.DI008.intValue==pmodel.DI008.intValue)
                {
                    UIButton *button=[self getButtonWithTag:pmodel.tag];
                    button.selected=NO;
                    [_dataArray removeObject:pmodel];
                    
                }
                
            }
            butt.selected=YES;
            [_dataArray addObject:model];
            
        }
       
        
        
    }

   
}
-(UIButton*)getButtonWithTag:(NSInteger)tag
{
    UIButton *button=[self viewWithTag:tag];
    return button;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
