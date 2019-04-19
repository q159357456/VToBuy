//
//  PayDetailOneTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PayDetailOneTableViewCell.h"
#import "AlreadyChosenTableViewCell.h"
#import "SBPModel.h"
@interface PayDetailOneTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation PayDetailOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTableview:(UITableView *)tableview
{
    _tableview=tableview;
    _tableview.delegate=self;
    _tableview.dataSource=self;
}
-(void)setProductArray:(NSMutableArray *)productArray
{
    _productArray=productArray;
    [self.tableview reloadData];
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        static NSString *cellid=@"AlreadyChosenTableViewCell";
        SBPModel *model=_productArray[indexPath.row];
       
        AlreadyChosenTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"AlreadyChosenTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       if ( model.SBP009.floatValue>0)
       {
          cell.cancelButton.hidden=YES;
        }else
       {
           cell.cancelButton.enabled=NO;
         
       }
    
        [cell setDataWithModel:model];
    
        return cell;
   
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        SBPModel *model=_productArray[indexPath.row];
        return 8+30+8+model.Bheight;
        
 
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 15;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
