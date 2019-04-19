//
//  ZWHShareCollectionViewCell.h
//  ZHONGHUILAOWU
//
//  Created by Syrena on 2018/11/26.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZWHShareCollectionViewCellDelegate <NSObject>

- (void)returnImg:(UIImage *)img;

@end

@interface ZWHShareCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *backimg;
@property(nonatomic,strong)UIImageView *QRimg;

@property(nonatomic,weak)id<ZWHShareCollectionViewCellDelegate>   delegate;



@end

NS_ASSUME_NONNULL_END
