//
//  ZWHSharesModel.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/4.
//  Copyright © 2018年 秦根. All rights reserved.
//

#import "ZWHBaseModel.h"

@interface ZWHSharesModel : ZWHBaseModel

@property(nonatomic,copy)NSString *MemberName;
@property(nonatomic,copy)NSString *FirstEffective;
@property(nonatomic,copy)NSString *LastEffective;
@property(nonatomic,copy)NSString *Ratio;
@property(nonatomic,copy)NSString *ShopID;
@property(nonatomic,copy)NSString *MemberID;
@property(nonatomic,assign)NSInteger row;

@property(nonatomic,assign)NSInteger BaseNum;




@end
