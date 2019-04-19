//
//  ClassifyModel.h
//  树形测试
//
//  Created by 工博计算机 on 17/4/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject
@property(nonatomic,copy)NSString *classifyNo;//分类编号（本节点）
@property(nonatomic,copy)NSString *classifyName;//分类名称
@property(nonatomic,copy)NSString *parentno; //关联参数（父类节点）
@property (nonatomic , assign) int depth;//该节点的深度
@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,copy)NSString *ClassifyType;
@property(nonatomic,copy)NSString *Status;
@property(nonatomic,assign)BOOL selected;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
