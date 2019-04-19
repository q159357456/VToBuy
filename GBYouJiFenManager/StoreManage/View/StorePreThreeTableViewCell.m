//
//  StorePreThreeTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StorePreThreeTableViewCell.h"
#import "StorePreThreeCollectionViewCell.h"
#import "CouponModel.h"

@implementation StorePreThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=dataArray;
    [self.collectionView reloadData];
}
-(void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView=collectionView;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"StorePreThreeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StorePreThreeCollectionViewCell"];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return _dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CouponModel *model=_dataArray[indexPath.row];
   StorePreThreeCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"StorePreThreeCollectionViewCell" forIndexPath:indexPath];
    cell.lable3.text=[NSString stringWithFormat:@"满%@元立减%@元",model.Amount1,model.Amount2];
    cell.lable4.text=model.EndDate;
    cell.lable1.text=[NSString stringWithFormat:@"¥%@",[model.Amount2 removeZeroWithStr]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.collectionView.width,98);
    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    
    return UIEdgeInsetsMake(1, 0, 1, 0);
    
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 1;
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
