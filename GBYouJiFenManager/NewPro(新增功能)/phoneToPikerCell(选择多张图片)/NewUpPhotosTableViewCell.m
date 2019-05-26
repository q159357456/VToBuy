//
//  NewUpPhotosTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 秦根 on 2019/5/23.
//  Copyright © 2019 张卫煌. All rights reserved.
//

#import "NewUpPhotosTableViewCell.h"
#import "NewUpPhotoCellCollectionViewCell.h"
static NSInteger maxCount = 6;
@interface NewUpPhotosTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end
@implementation NewUpPhotosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewUpPhotoCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewUpPhotoCellCollectionViewCell"];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.scrollEnabled = NO;
    // Initialization code
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (_dataArray.count>maxCount) {
        [_dataArray  removeObjectsInRange:NSMakeRange(maxCount, _dataArray.count-maxCount)];
    }
    
    if (_dataArray.count < maxCount) {
        
        [_dataArray addObject:@"uppic_2"];
    }
    [self.collectionView reloadData];
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
    
   NewUpPhotoCellCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"NewUpPhotoCellCollectionViewCell" forIndexPath:indexPath];
    
    if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        
        cell.subImg.image=[UIImage imageNamed:_dataArray[indexPath.row]];
        cell.deletBtn.hidden=YES;
        
        
    }else
    {
        cell.subImg.image=_dataArray[indexPath.row];
        cell.deletBtn.hidden=NO;
        [cell.deletBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        cell.deletBtn.tag = indexPath.item + 1;

    }

   return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
        if (self.addBlock) {
            self.addBlock(indexPath.row);
        }
        
    }else
    {
        if (self.extendBlock) {
            self.extendBlock(indexPath.row);
        }
        
    }
//
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake((ScreenWidth-40)/3,(ScreenWidth-40)/3);
    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
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
#pragma mark - action
-(void)delete:(UIButton*)sender{
    NSLog(@"删除");
    if (self.closeBlock) {
        self.closeBlock(sender.tag-1);
    }
}
#pragma mark - public
+(CGFloat)SelfViewHeightWithSubCount:(NSInteger)count
{
    NSInteger temp = count;
    if (count>maxCount) {
        temp = maxCount;
    }
    if (count<maxCount) {
        temp = count + 1;
    }
    NSInteger row = ceilf(temp/3.00);
    return 20 + row*(ScreenWidth-40)/3 + (row-1);
}
@end
