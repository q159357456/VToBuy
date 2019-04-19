//
//  VersionManagerVC.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/11/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "VersionManagerVC.h"

@interface VersionManagerVC ()

@end

@implementation VersionManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.index==1)
    {
        
        [self alertShowWithStr:@"版本修复成功,请更新后再使用,为您带来不便之处,我们表示歉意!"];
    }else
    {
        
        [self alertShowWithStr:@"版本有重大变动正在修复中！为您带来不便之处,我们表示歉意!"];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", APP_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
           
        }];
        [alert addAction:action1];

    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
