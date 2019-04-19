//
//  UpPictureTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpPictureTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)void(^addBlock)(NSInteger index);
@property(nonatomic,copy)void(^closeBlock)(NSInteger index);
@property(nonatomic,copy)void(^extendBlock)(NSInteger index);
@property(nonatomic,strong)NSArray *titleArray;
-(void)setDataArrayWithStr:(NSInteger)index :(NSMutableArray*)dataArray;
@end
