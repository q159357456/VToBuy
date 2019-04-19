//
//  ScanSuccessJumpVC.m
//  Restaurant
//
//  Created by 张帆 on 16/11/4.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "ScanSuccessJumpVC.h"


@interface ScanSuccessJumpVC ()

@end

@implementation ScanSuccessJumpVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
    
    if (self.jump_bar_code) {
        [self setupLabel];
    } else {
        [self setupWebView];
    }
}


- (void)setupNavigationItem {
    UIButton *left_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [left_Button setTitle:@"返回" forState:UIControlStateNormal];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
    
    
    UIButton *commitButton=[[UIButton alloc]initWithFrame:CGRectMake(0, screen_height-60, screen_width,60)];
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    commitButton.backgroundColor=navigationBarColor;
    [commitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
}
-(void)commitClick
{
//    NSDictionary *dic=@{@"posstsJson":@"",@"seatNum":self.jump_bar_code};
//    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"commitSeat" object:nil userInfo:dic];
//    
//    NSArray *temArray = self.navigationController.viewControllers;
//    
//    for(UIViewController *temVC in temArray)
//    {
//        if ([temVC isKindOfClass:[PayViewController class]])
//        {
//            [self.navigationController popToViewController:temVC animated:YES];
//        }
//    }
}
- (void)left_BarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = @"您扫描的条形码结果如下： ";
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    label.text = self.jump_bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    webView.frame = self.view.bounds;
    
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = self.jump_URL;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

@end
