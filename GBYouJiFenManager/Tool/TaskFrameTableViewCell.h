//
//  TaskFrameTableViewCell.h
//  gongbo.paid
//
//  Created by 工博计算机 on 16/9/23.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsFrame.h"
@interface TaskFrameTableViewCell : UITableViewCell

{
    BOOL is;
     UILabel *Tlable;
}
@property (nonatomic, strong) TagsFrame *tagsFrame;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *tastStr;
@property(nonatomic,copy)void(^buttonBlock)();

+ (id)cellWithTableView:(UITableView *)tableView;


@end
