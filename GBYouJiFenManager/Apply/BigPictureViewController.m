//
//  BigPictureViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/5.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BigPictureViewController.h"

@interface BigPictureViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation BigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size=self.image.size;
//    NSLog(@"%f",size.height);
//       NSLog(@"%f",size.width);
    self.height.constant=size.height*screen_width/size.width;
    self.imageview.image=self.image;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
