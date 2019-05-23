//
//  NewUpPhotosTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 秦根 on 2019/5/23.
//  Copyright © 2019 张卫煌. All rights reserved.
//

#import "NewUpPhotosTableViewCell.h"
#import "UpPictureCollectionViewCell.h"
@interface NewUpPhotosTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end
@implementation NewUpPhotosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"UpPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UpPictureCollectionViewCell"];
    QMUIAlbumViewController
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    // Initialization code
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
    cell.classiLable.hidden = YES;
    
//    if (!_titleArray)
//    {
//        cell.classiLable.hidden=YES;
//    }else
//    {
//        cell.classiLable.text=_titleArray[indexPath.row];
//    }
//    if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]])
//    {
//
//        cell.picImage.image=[UIImage imageNamed:_dataArray[indexPath.row]];
//        cell.closeButton.hidden=YES;
//
//
//    }else
//    {
//        cell.classiLable.text=_titleArray[indexPath.row];
//        cell.picImage.image=[UIImage imageWithData:_dataArray[indexPath.row]];
//        cell.closeButton.hidden=NO;
//        __weak typeof(self)weakSelf=self;
//        cell.closeBlock=^{
//            weakSelf.closeBlock(indexPath.item);
//        };
//
//    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
//        
//        self.addBlock(indexPath.row);
//    }else
//    {
//        self.extendBlock(indexPath.row);
//    }
//    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(98,130);
    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    
    return UIEdgeInsetsMake(8, 10, 8, 10);
    
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10;
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
