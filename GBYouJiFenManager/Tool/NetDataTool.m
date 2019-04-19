//
//  NetDataTool.m
//  Restaurant
//
//  Created by 张帆 on 16/8/17.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "NetDataTool.h"
@interface NetDataTool()
@end
@implementation NetDataTool
//创建单例
+(NetDataTool*) shareInstance;
{
    static dispatch_once_t onceToken;
    static NetDataTool *net=nil;
    dispatch_once(&onceToken, ^{
        net=[[NetDataTool alloc]init];
    });
    
    return net;
}
//请求数据
-(void)getNetData:(NSString *)rootUrl url:(NSString *)url With:(NSDictionary *)parameters and:(httpRequestSuccess)success Faile:(httpRequestFaile)faile
{
    NSString *path=[NSString stringWithFormat:@"%@/%@",rootUrl,url];
    NSLog(@"path:%@",path);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
 
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager POST :path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *wrong=[NSString stringWithFormat:@"%@",error];
        if ([wrong containsString:@"The request timed out"])
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        faile(error);
    }];
}

-(void)zwhgetNetData:(NSString *)rootUrl url:(NSString *)url With:(NSDictionary *)parameters and:(httpRequestSuccess)success Faile:(httpRequestFaile)faile
{
    NSString *path=[NSString stringWithFormat:@"%@%@",rootUrl,url];
    NSLog(@"path:%@",path);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager POST :path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *wrong=[NSString stringWithFormat:@"%@",error];
        if ([wrong containsString:@"The request timed out"])
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        faile(error);
    }];
}


//撤销请求
-(void)cancelRequest
{
    
    
}
@end
