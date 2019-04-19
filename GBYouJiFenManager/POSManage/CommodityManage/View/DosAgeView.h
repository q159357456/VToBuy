//
//  DosAgeView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DosAgeView : UIView
@property (strong, nonatomic) IBOutlet UILabel *lable;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)void(^combBlock)(NSInteger);
@end
