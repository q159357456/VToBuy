//
//  StInputOrderTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StInputOrderTableViewCell.h"
#import "ProductModel.h"
#import "STShopCarTableViewCell.h"
@implementation StInputOrderTableViewCell

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

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 100;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"STShopCarTableViewCell";
    ProductModel *model=_dataArray[indexPath.row];
    STShopCarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"STShopCarTableViewCell" owner:nil options:nil][0];
    }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setHideen];
    cell.width.constant=0;
    [cell setDataWithModel:model];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
