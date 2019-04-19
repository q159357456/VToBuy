//
//  AficheView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AficheView : UIView
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)void(^closeBlock)();
@end
