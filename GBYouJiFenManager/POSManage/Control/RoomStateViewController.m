//
//  RoomStateViewController.m
//  GBYouJiFenManager
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.

#import "RoomStateViewController.h"
#import "ChooseTypeViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface RoomStateViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;

@property(nonatomic,copy)NSString *validateString;
@property(nonatomic,copy)NSString *BookString;

@end

@implementation RoomStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    
        [self editOption];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
}

-(void)editOption
{
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        
        _RoomName.text = self.RoomDModel.roomName;
        _RoomType.text = self.roomTypeStr;
        _FloorArea.text = self.floorAreaStr;
        self.string2 = self.RoomDModel.roomType;
        
    }
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        if ([self.RoomDModel.isValid isEqualToString:@"True"]) {
            self.ValidSegment.selectedSegmentIndex = 0;
        }
        else {
            self.ValidSegment.selectedSegmentIndex = 1;
        }
        
        if ([self.RoomDModel.isBook isEqualToString:@"True"]) {
            self.BookSegment.selectedSegmentIndex = 0;
        }else{
            self.BookSegment.selectedSegmentIndex = 1;
        }

    }else
    {
        self.ValidSegment.selectedSegmentIndex = 0;
        self.BookSegment.selectedSegmentIndex = 1;
    }
    
    __weak typeof(self)weakSelf=self;
    self.validateBlock = ^(NSString *str){
        weakSelf.validateString = str;
    };
    self.bookBlock = ^(NSString *str){
        weakSelf.BookString = str;
    };

    
    _RoomName.delegate = self;
    _RoomType.delegate = self;
    _FloorArea.delegate = self;
    _RoomType.tag = 201;
    _FloorArea.tag = 202;
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)FinishBtnClick:(id)sender {
    if (_RoomName.text.length==0||_RoomType.text.length == 0 ||_FloorArea.text.length == 0) {
        [self alertShowWithStr:@"请输入必填信息"];
    }

    else{
        if ([self.chooseType isEqualToString:@"Edit"]) {
            [self editItem];
        }else
        {
            [self addItem];
        }
    }

}

-(void)judegSegment
{
    if (self.ValidSegment.selectedSegmentIndex==0) {
        self.validateString = @"true";
    }else
    {
        self.validateString = @"false";
    }
    
    if (self.BookSegment.selectedSegmentIndex == 0) {
        self.BookString = @"true";
    }else
    {
        self.BookString = @"false";
    }
}

-(void)addItem
{
    [self judegSegment];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSSI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"SI002":_RoomName.text,@"SI003":_string1,@"SI004":_string2,@"SI015":self.validateString,@"SI018":self.BookString}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
-(void)editItem
{
    [self judegSegment];
    
    NSString *rtStr;
    NSString *floorStr;
    
    if (_string1==nil) {
        rtStr = self.RoomDModel.roomType;
    }else{
        rtStr = _string1;
    }
    
    if (_string2 == nil) {
        floorStr = self.RoomDModel.floorArea;
    }else
    {
        floorStr = _string2;
    }
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSSI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"SI002":_RoomName.text,@"SI003":rtStr,@"SI004":floorStr,@"SI015":self.validateString,@"SI018":self.BookString,@"SI001":self.RoomDModel.itemNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.backBlock();
                
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 201:
        {
            //房台类型
            if (_string2>0) {
                ChooseTypeViewController *chooseVC = [[ChooseTypeViewController alloc] init];
                chooseVC.chooseType = @"chooseType";
                chooseVC.title = @"选择房台类型";
                chooseVC.floorStr = _string2;
                //__weak typeof(self)weakSelf = self;
                chooseVC.tagNumber = 201;
                chooseVC.backBlock = ^(RoomTypeModel *Rmodel){
                    _RoomType.text = Rmodel.RoomName;
                    _string1 = Rmodel.itemNo;
                };
                [self.navigationController pushViewController:chooseVC animated:YES];
            }else{
                [self alertShowWithStr:@"请先选择楼层"];
            }
            return NO;
            
        }
            break;
        
            
            case 202:
        {
            //楼层区域
            ChooseTypeViewController *chooseVC = [[ChooseTypeViewController alloc] init];
            chooseVC.chooseType = @"chooseType";
            chooseVC.title = @"选择楼层";
            //__weak typeof(self)weakSelf = self;
            chooseVC.tagNumber = 202;
            chooseVC.backBlock1 = ^(FloorModel *fmodel){
                _FloorArea.text = fmodel.FloorInfo;
                _string2 = fmodel.itemNo;
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;

        }
            break;
            
        default:
            
            
            break;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)fingerTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (IBAction)validateSegment:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            NSLog(@"是");
            self.validateBlock(@"true");
            
        }
            break;
        case 1:
        {
            NSLog(@"否");
            self.validateBlock(@"false");
            
        }
            break;
            
            
            
    }

}

- (IBAction)bookSegment:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            NSLog(@"是");
            self.bookBlock(@"true");
            
        }
            break;
        case 1:
        {
            NSLog(@"否");
            self.bookBlock(@"false");
            
        }
            break;
            
            
            
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
