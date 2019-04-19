//
//  ScanSuccessJumpVC.h
//  Restaurant
//
//  Created by 张帆 on 16/11/4.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanSuccessJumpVC : UIViewController

/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;
/** 接收扫描的条形码信息 */
@property (nonatomic, copy) NSString *jump_bar_code;
@end
