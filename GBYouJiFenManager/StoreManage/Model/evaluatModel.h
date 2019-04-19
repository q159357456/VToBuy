//
//  evaluatModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface evaluatModel : NSObject
@property(nonatomic,copy)NSString *ID ;
@property(nonatomic,copy)NSString *MemberNo ;
@property(nonatomic,copy)NSString *Msg ;
@property(nonatomic,copy)NSString *Star ;
@property(nonatomic,copy)NSString *ReplyMsg;
@property(nonatomic,assign)double height;
@property(nonatomic,assign)double AnswerHeight;
//关联会员表
@property(nonatomic,copy)NSString *MS002;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
