//
//  ProuctTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ProuctTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *choseView;
@property (strong, nonatomic) IBOutlet UILabel *classiFy;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ledLeft;
-(void)setDataWithModel:(ProductModel *)model Type:(NSString*)type;
@end
