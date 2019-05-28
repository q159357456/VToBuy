//
//  ChooseTipsView.m
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/5/27.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import "ChooseTipsView.h"
@interface ChooseTipsView()
@property(nonatomic,copy)void(^chooseDone)(NSString * values);
@end
@implementation ChooseTipsView
+(void)startChooseTipsCallBack:(void(^)(NSString * values))callback
{
    ChooseTipsView * temp  = [[ChooseTipsView alloc]init];
    temp.backgroundColor = [UIColor whiteColor];
    [UIApplication.sharedApplication.keyWindow addSubview:temp];
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(UIApplication.sharedApplication.keyWindow);
        make.size.mas_equalTo(CGSizeMake(SCALE(345), SCALE(345)));
    }];
    
}

-(instancetype)init
{
    if (self = [super init]) {
        [self getdata];
    }
    return self;
}
-(void)getdata{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_BaseVar",@"SelectField":@"*",@"Condition":@"moduleno$=$CMS$AND$varfield$=$shoplabel",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"dic1dic1==>%@",dic1);
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
