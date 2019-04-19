//
//  POSDIModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSDIModel : NSObject
@property(nonatomic,copy)NSString *DI001;
@property(nonatomic,copy)NSString *DI002;
@property(nonatomic,copy)NSString *DI003;
@property(nonatomic,copy)NSString *DI004;
@property(nonatomic,copy)NSString *DI005;
@property(nonatomic,copy)NSString *DI006;
@property(nonatomic,copy)NSString *DI007;
@property(nonatomic,copy)NSString *DI008;
@property(nonatomic,copy)NSString *DI009;
@property(nonatomic,copy)NSString *DI010;
@property(nonatomic,copy)NSString *DI011;
@property(nonatomic,copy)NSString *DI012;
@property(nonatomic,copy)NSString *SPT003;
    @property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)NSInteger tag;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
