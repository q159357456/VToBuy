//
//  UpPictureCollectionViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpPictureCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picImage;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *classiLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *colAspect;
@property(nonatomic,copy)void(^closeBlock)();
@end
