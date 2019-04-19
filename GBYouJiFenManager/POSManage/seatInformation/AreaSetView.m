//
//  AreaSetView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AreaSetView.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface AreaSetView()
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *floorNo;
@end
@implementation AreaSetView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius=4;
        self.layer.masksToBounds=YES;
         _model=[[FMDBMember shareInstance]getMemberData][0];
    }
    return self;
}
-(void)setFunType:(NSString *)funType
{
    _funType=funType;
    if ([_funType isEqualToString:@"Tast"])
    {
        _lNameable.text=@"口味大类";
        _areaName.placeholder=@"口味大类如做法,规格";
        
    }
    if ([_funType isEqualToString:@"SmallTast"]) {
        _lNameable.text=@"口味要求";
        _areaName.placeholder=@"例如少辣中辣大辣...";
    }
}
-(void)setDoneButton:(UIButton *)doneButton
{
    _doneButton=doneButton;
//    _doneButton.backgroundColor=MainColor;
}
-(void)setFloorModel:(FloorModel *)floorModel
{
    _floorModel=floorModel;
    if (self.floorModel)
    {
        _areaName.text=_floorModel.FloorInfo;
        _floorNo=_floorModel.itemNo;
    }
    
}
-(void)setLNameable:(UILabel *)lNameable
{
    _lNameable=lNameable;

    
}
-(void)setAreaName:(UITextField *)areaName
{
    _areaName=areaName;

       [_areaName becomeFirstResponder];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    return;
}
- (IBAction)done:(UIButton *)sender {
    if (_funType.length) {
        if (_areaName.text.length)
        {
            self.tastBlock(_areaName.text);
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"不能为空"];
        }

    }else
        [self upAreaInfo];
//    if ([_funType isEqualToString:@"Tast"])
//    {
//        if (_areaName.text.length)
//        {
//              self.tastBlock(_areaName.text);
//        }else
//        {
//            [SVProgressHUD setMinimumDismissTimeInterval:1];
//            [SVProgressHUD showErrorWithStatus:@"不能为空"];
//        }
//      
//    }else if ([_funType isEqualToString:@"SmallTast"])
//    {
//        if (_areaName.text.length)
//        {
//            self.tastBlock(_areaName.text);
//        }else
//        {
//            [SVProgressHUD setMinimumDismissTimeInterval:1];
//            [SVProgressHUD showErrorWithStatus:@"不能为空"];
//        }
//        
//    }
//    else
//        
//    [self upAreaInfo];
}

//上传区域
-(void)upAreaInfo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    if (_areaName.text.length>0)
    {
        NSDictionary *jsonDic;
        
        if (self.floorModel)
        {
            jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSAF",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"AF002":_areaName.text,@"AF001":self.floorModel.itemNo}]};
        }else
        {
            jsonDic=@{ @"Command":@"Add",@"TableName":@"POSAF",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"AF002":_areaName.text}]};
        }
        
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            
            
            NSString *str=[JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"OK"])
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.backBlock();
                    [SVProgressHUD dismiss];
                    
                    
                    
                });
                
                
            }else
            {
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showErrorWithStatus:@"上传失败稍后再试"];
            }
            
            
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

    }else
    {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"不能为空"];
    }
   
}



@end
