//
//  VesionManager.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/11/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "VesionManager.h"

#define APP_URL @"http://itunes.apple.com/cn/lookup?id=1307300292"
#define VERSION (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_ID @"1271259329"

@interface VesionManager()
@property(nonatomic,copy)NSString *serVerVison;
@property(nonatomic,copy)NSString *storeVison;
@property(nonatomic,copy)NSString *crruntVison;
//是否强制更新
@property(nonatomic,assign)BOOL isforce;
@end
@implementation VesionManager
-(instancetype)init
{
    
    self=[super init];
    if (self) {
        
     
    }
    return self;
}

//获取appstorez最新版本号
-(void)getAppSoteVison
{
    NSString *URLString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=cn", APP_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:15.0f];
    DefineWeakSelf ;
    __block NSHTTPURLResponse *urlResponse = nil;
    __block NSError *error = nil;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        if (recervedData && recervedData.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableLeaves error:&error];
            NSArray *infoArray = [dict objectForKey:@"results"];
            if (infoArray && infoArray.count > 0) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                //描述
               self.storeVison=releaseInfo[@"version"];
                [weakSelf getSeverceVesion];
                
            }
        }
        
    }];
    
}
//获取服务器最新版本号
-(void)getSeverceVesion
{
   
    NSDictionary *dic=@{@"FromTableName":@"cms_company",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSDictionary *dic2=dic1[@"DataSet"][@"Table"][0];
        self.serVerVison=dic2[@"APP_Iphone_Ver"];
        NSString *string=dic2[@"APP_Iphone_Update"];
        self.isforce=string.boolValue;
        [self compareVison];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)compareVison
{
    if (!_isforce)
    {
        //不强制更新
        [[NSNotificationCenter defaultCenter]postNotificationName:Noupdate object:nil userInfo:nil];
    }else
    {
        if ([_serVerVison isEqualToString:_storeVison])
        {
            
            NSString *version=VERSION;
            if (version.doubleValue==_serVerVison.doubleValue )
            {
                //
                 [[NSNotificationCenter defaultCenter]postNotificationName:Noupdate object:nil userInfo:nil];
                
            }else
            {
                 //跳转到APPstore下载最新版本应用
                  [[NSNotificationCenter defaultCenter]postNotificationName:Forceupdate object:nil userInfo:nil];
            }
          
            
        }else
        {
            //app正在审核或者审核未通过，不能让用户继续使用
            [[NSNotificationCenter defaultCenter]postNotificationName:Waiteupdate object:nil userInfo:nil];
            
        }
    }
    
}

@end
