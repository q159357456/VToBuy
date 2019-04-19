//
//  ADClassifyModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADClassifyModel : NSObject
@property(nonatomic,copy)NSString *ClassifyName;
@property(nonatomic,copy)NSString *ClassifyNo;
@property(nonatomic,copy)NSString *ParentNo;
@property(nonatomic,copy)NSString *pictureurl;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
