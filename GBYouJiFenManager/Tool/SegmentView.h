//
//  SegmentView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCNavTabBarDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;
@end
@interface SegmentView : UIView
@property (nonatomic, weak)    id<SCNavTabBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger   currentItemIndex;

@property (nonatomic, strong)   NSArray     *itemTitles;
@property (nonatomic, strong)   UIColor     *lineColor;

@property (nonatomic , strong)  NSMutableArray  *items;

- (id)initWithFrame:(CGRect)frame;


- (void)updateData;


@end
