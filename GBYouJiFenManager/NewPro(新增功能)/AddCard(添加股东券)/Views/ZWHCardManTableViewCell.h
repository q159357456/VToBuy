//
//  ZWHCardManTableViewCell.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/10.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWHCardManTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UIView *corView;

@property(nonatomic,assign)BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
