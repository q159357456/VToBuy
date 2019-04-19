//
//  ScoreViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *scoreView;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor=navigationBarColor;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
