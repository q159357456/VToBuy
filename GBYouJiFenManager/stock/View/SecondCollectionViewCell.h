//
//  SecondCollectionViewCell.h
//  YiJieGou
//
//  Created by 工博计算机 on 17/3/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *soldCount;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;

@property (strong, nonatomic) IBOutlet UILabel *describ;
@end
