//
//  NewUpPhotosTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 秦根 on 2019/5/23.
//  Copyright © 2019 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewUpPhotosTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,copy)void(^addBlock)(NSInteger index);
@property(nonatomic,copy)void(^closeBlock)(NSInteger index);
@property(nonatomic,copy)void(^extendBlock)(NSInteger index);
+(CGFloat)SelfViewHeightWithSubCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
