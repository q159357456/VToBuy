//
//  SetBusinessDateView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetBusinessDateView : UIView
@property (strong, nonatomic) IBOutlet UITextField *textfield;

@property(nonatomic,copy)void(^doneBlock)(NSString *str);

@end
