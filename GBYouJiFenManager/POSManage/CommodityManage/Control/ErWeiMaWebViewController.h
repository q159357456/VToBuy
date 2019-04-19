//
//  ErWeiMaWebViewController.h
//  GBManagement
//
//  Created by 工博计算机 on 16/12/21.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErWeiMaWebViewController : UIViewController
@property(nonatomic,copy)NSString *zhifuStr;
@property(nonatomic,copy)NSString *dingDanNo;
@property (strong, nonatomic) IBOutlet UIWebView *myWeb;
@property (strong, nonatomic) IBOutlet UILabel *zhiFuLable;
@property(nonatomic,copy)NSString *seatNo;
@property(nonatomic,copy)NSString *price;
@end
