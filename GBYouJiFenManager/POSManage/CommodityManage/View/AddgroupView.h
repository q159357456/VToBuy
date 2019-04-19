//
//  AddgroupView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
@interface AddgroupView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    float  offset;
}
@property(nonatomic,strong)UITableView *table ;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)void(^backBlock)(GroupModel *);
@end
