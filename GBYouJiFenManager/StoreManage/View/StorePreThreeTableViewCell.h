//
//  StorePreThreeTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorePreThreeTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end
