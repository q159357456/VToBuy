//
//  StoreCollectionReusableView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChangeTextView.h"
@interface StoreCollectionReusableView : UICollectionReusableView<GYChangeTextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *laba;

@property(nonatomic,strong)NSMutableArray *titileArray;
@property(nonatomic,copy)void(^tapClick)(NSInteger index);
@end
