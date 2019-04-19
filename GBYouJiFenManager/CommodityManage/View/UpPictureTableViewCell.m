//
//  UpPictureTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "UpPictureTableViewCell.h"
#import "UpPictureCollectionViewCell.h"
@implementation UpPictureTableViewCell

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
-(void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView=collectionView;
  
     [_collectionView registerNib:[UINib nibWithNibName:@"UpPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UpPictureCollectionViewCell"];

    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
}

-(void)setDataArrayWithStr:(NSInteger)index :(NSMutableArray*)dataArray
{
    if (index==1) {
          _titleArray=@[@"店铺招牌"];
    }else if(index==2)
    {
        _titleArray=@[@"菜品图片"];
    }else if (index == 3)
    {
        _titleArray = @[@"营业执照",@"身份证正面"];
    }
    else
    {
        _titleArray=nil;
    }
     _dataArray=dataArray;
      [self.collectionView reloadData];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

    UpPictureCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"UpPictureCollectionViewCell" forIndexPath:indexPath];
    
    if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]])
    {
      
        cell.picImage.image=[UIImage imageNamed:_dataArray[indexPath.row]];
        cell.closeButton.hidden=YES;
        if (!_titleArray)
        {
            cell.classiLable.hidden=YES;
        }else
        {
            cell.classiLable.hidden=NO;
            
            cell.classiLable.text=_titleArray[indexPath.row];
        }
       
    }else
    {
        
        cell.picImage.image=[UIImage imageWithData:_dataArray[indexPath.row]];
        cell.closeButton.hidden=NO;
        __weak typeof(self)weakSelf=self;
        cell.closeBlock=^{
            weakSelf.closeBlock(indexPath.item);
        };
        cell.classiLable.hidden=YES;
        
    }
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
        
        self.addBlock(indexPath.row);
    }else
    {
        self.extendBlock(indexPath.row);
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
        return CGSizeMake(98,98);
  
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
 
        return UIEdgeInsetsMake(1, 10, 1, 10);

}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  
        return 20;
 
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
  
        return 1;
  
}

@end
