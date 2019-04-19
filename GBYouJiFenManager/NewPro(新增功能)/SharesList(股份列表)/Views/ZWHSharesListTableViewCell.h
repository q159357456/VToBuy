//
//  ZWHSharesListTableViewCell.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/3.
//  Copyright © 2018年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHSharesModel.h"

@interface ZWHSharesListTableViewCell : UITableViewCell

@property(nonatomic,strong)QMUIButton *edit;

@property(nonatomic,strong)QMUIButton *deleteBtn;

@property(nonatomic,strong)QMUIButton *shares;

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)QMUILabel *name;

@property(nonatomic,strong)QMUILabel *time;

@property(nonatomic,strong)ZWHSharesModel *model;

@property(nonatomic,strong)QMUILabel *baseq;



@end
