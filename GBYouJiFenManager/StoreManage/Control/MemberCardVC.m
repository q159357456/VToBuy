//
//  MemberCardVC.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/12/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MemberCardVC.h"

@interface MemberCardVC ()

@end

@implementation MemberCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark   会员
-(void)getMemberInfoWithStr:(NSString *)key
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *conditionStr=[NSString stringWithFormat:@"MS002$=$%@$OR$MS008$=$%@",key,key];
    NSDictionary *dic=@{@"FromTableName":@"CRMMS",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:SystemCommService With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
    } Faile:^(NSError *error) {
        
    }];
}

#pragma mark   会员卡
-(void)getMemberCard
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *conditionStr=@"goodsif$=$1$AND$SHOPID$=$MShop";
    NSDictionary *dic=@{@"FromTableName":@" CRMMBR",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:SystemCommService With:dic and:^(id responseObject) {
          [SVProgressHUD dismiss];
    } Faile:^(NSError *error) {
        
    }];
    
}
#pragma mark   会员详情信息
-(void)getMemberDetailInfoWith:(NSString*)memberID
{
//
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"memberno":memberID};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"CRMInfoService.asmx/QueryCardList" With:dic and:^(id responseObject) {
          [SVProgressHUD dismiss];
        
    } Faile:^(NSError *error) {
        
        
    }];
}


@end
