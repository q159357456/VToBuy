//
//  ProDetailTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProDetailTableViewCell : UITableViewCell
@property(nonatomic,copy)void(^addBlock)(UIButton*);
@property(nonatomic,copy)void(^minceBlock)();
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property (strong, nonatomic) IBOutlet UILabel *lable4;
@end
