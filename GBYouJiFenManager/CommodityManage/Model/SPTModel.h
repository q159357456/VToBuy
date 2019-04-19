//
//  SPTModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTModel : NSObject
@property(nonatomic,copy)NSString *SPT001;
@property(nonatomic,copy)NSString *SPT002;
@property(nonatomic,copy)NSString * SPT003;
@property(nonatomic,copy)NSString *SPT004;
@property(nonatomic,copy)NSString * SPT005;
@property(nonatomic,copy)NSString * SPT006;
@property(nonatomic,copy)NSString * SPT007;
@property(nonatomic,copy)NSString *SPT008;
@property(nonatomic,copy)NSString *SPT009;
@property(nonatomic,copy)NSString *SPT010;
@property(nonatomic,copy)NSString *SPT011;
@property(nonatomic,copy)NSString *SPT012;
@property(nonatomic,copy)NSString *CREATE_DATE;
@property(nonatomic,copy)NSString *CREATOR;
@property(nonatomic,copy)NSString *FLAG;
@property(nonatomic,copy)NSString *IsUpdate;
@property(nonatomic,copy)NSString *MODIFIER;
@property(nonatomic,copy)NSString *MODI_DATE;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
