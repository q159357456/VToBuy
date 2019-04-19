//
//  PictureModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject
@property(nonatomic,copy)NSString *PhotoUrl;
@property(nonatomic,copy)NSString *ID;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
