//
//  TastManagerCollectionViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TastManagerCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *addImage;
@property (strong, nonatomic) IBOutlet UILabel *lable;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property(nonatomic,copy)void(^deletBlock)();
@end
