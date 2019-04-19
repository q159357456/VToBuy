//
//  STSModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSModel : NSObject
@property(nonatomic,copy)NSString *STS001;
@property(nonatomic,copy)NSString *STS002;
@property(nonatomic,copy)NSString *STS003;
@property(nonatomic,copy)NSString *STS004;
@property(nonatomic,copy)NSString *STS005;
@property(nonatomic,copy)NSString *STS006;
@property(nonatomic,copy)NSString *STS007;
@property(nonatomic,copy)NSString *STS008;
@property(nonatomic,copy)NSString *STS009;
@property(nonatomic,copy)NSString *STS010;
@property(nonatomic,copy)NSString *STS011;
@property(nonatomic,copy)NSString *STS012;
@property(nonatomic,copy)NSString *SI002;
@property(nonatomic,assign)BOOL selected;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
