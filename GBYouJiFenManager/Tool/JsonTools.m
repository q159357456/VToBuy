//
//  JsonTools.m
//  Reservation ordering
//
//  Created by 张帆 on 16/8/9.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "JsonTools.h"
#import <sys/utsname.h>

@implementation JsonTools


+(NSDictionary *)getData:(NSData *)data
{
    NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSArray *array=[string componentsSeparatedByString:@">"];

    NSString *str=array[2];

    NSArray *arr=[str componentsSeparatedByString:@"<"];
    NSString *st=arr.firstObject;

    NSData *mydata=[st dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:mydata options:NSJSONReadingMutableContainers error:nil];
    
    return dic;
}
+(NSString *)getNSString:(NSData *)data
{
    NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *array=[string componentsSeparatedByString:@">"];
    
    NSString *str=array[2];
    
    NSArray *arr=[str componentsSeparatedByString:@"<"];
    NSString *st=arr.firstObject;
    return st;
}

+(NSArray *)getArrayWithData:(NSData *)data{
    NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *array=[string componentsSeparatedByString:@">"];
    
    NSString *str=array[2];
    
    NSArray *arr=[str componentsSeparatedByString:@"<"];
    NSString *st=arr.firstObject;
    
    NSData *mydata=[st dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *objarr = [NSJSONSerialization JSONObjectWithData:mydata options:NSJSONReadingMutableContainers error:nil];
    return objarr;
}

+(BOOL)isNavX{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    //------------------------------iPhone---------------------------
    
    if ([platform isEqualToString:@"iPhone10,3"] ||
        [platform isEqualToString:@"iPhone10,6"])
        return YES;
    if ([platform isEqualToString:@"iPhone11,8"])
        return YES;
    if ([platform isEqualToString:@"iPhone11,2"])
        return YES;
    if ([platform isEqualToString:@"iPhone11,4"] ||
        [platform isEqualToString:@"iPhone11,6"])
        return YES;
    
    return NO;
    
}




@end
