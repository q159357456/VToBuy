//
//  SecondTableViewCell.h
//  YiJieGou
//
//  Created by 工博计算机 on 17/3/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface SecondTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collctinView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)void(^pushBlock)(ProductModel *model);
@end
