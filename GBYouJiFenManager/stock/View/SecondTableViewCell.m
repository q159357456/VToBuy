//
//  SecondTableViewCell.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/3/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SecondTableViewCell.h"
#import "SecondCollectionViewCell.h"

@implementation SecondTableViewCell

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
-(void)setCollctinView:(UICollectionView *)collctinView
{
    _collctinView=collctinView;
    //注册
 
    [_collctinView registerNib:[UINib nibWithNibName:@"SecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SecondCollectionViewCell"];
    _collctinView.backgroundColor=[ColorTool colorWithHexString:@"#f4f4f4"];
    _collctinView.delegate=self;
    _collctinView.dataSource=self;
    
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=dataArray;
    [self.collctinView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark--colection
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCollectionViewCell" forIndexPath:indexPath];
    ProductModel *model=_dataArray[indexPath.row];
    cell.describ.text=model.ProductName;
    cell.soldCount.text=[NSString stringWithFormat:@"销售量:%@",model.Bonus];
    cell.priceLable.text=[NSString stringWithFormat:@"%@/%@",model.RetailPrice,model.Unit];
    if (screen_width==320)
    {
        cell.describ.font=[UIFont systemFontOfSize:10];
           cell.soldCount.font=[UIFont systemFontOfSize:10];
           cell.priceLable.font=[UIFont systemFontOfSize:10];
        
    }else if(screen_width==375)
    {
         cell.describ.font=[UIFont systemFontOfSize:12];
           cell.soldCount.font=[UIFont systemFontOfSize:11];
           cell.priceLable.font=[UIFont systemFontOfSize:12];
    }
    else
    {
        cell.describ.font=[UIFont systemFontOfSize:14];
           cell.soldCount.font=[UIFont systemFontOfSize:13];
           cell.priceLable.font=[UIFont systemFontOfSize:14];
    }

    NSString *path=[NSString stringWithFormat:@"%@/%@",PICTUREPATH,model.PicAddress1];
    NSString *codePath=[path URLEncodedString];
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:codePath] placeholderImage:[UIImage imageNamed:@"holder"]];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/2-5,self.frame.size.width/2-5+50);
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右

    
        return UIEdgeInsetsMake(0,0,0,0);
        
    
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

        return 5;
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    

        return 10;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
      ProductModel *model=_dataArray[indexPath.row];
    self.pushBlock(model);
}
@end
