//
//  RoomTypeModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomTypeModel : NSObject
@property(nonatomic,copy)NSString *RoomName;
@property(nonatomic,copy)NSString *roomArea;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)NSString *AF002;


@property(nonatomic,copy)NSString *typename;
@property(nonatomic,copy)NSString *typeno;



+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
