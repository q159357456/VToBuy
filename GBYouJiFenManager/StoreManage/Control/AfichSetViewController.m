//
//  AfichSetViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AfichSetViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface AfichSetViewController ()<UITextViewDelegate>
{
    UILabel * textViewPlaceholderLabel;
}
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UITextField *titleText;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation AfichSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _doneButton.backgroundColor=MainColor;
    self.automaticallyAdjustsScrollViewInsets=NO;
    textViewPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,30, 150, 25)];
    textViewPlaceholderLabel.text = @"请输入你的内容";
    textViewPlaceholderLabel.textColor = [UIColor grayColor];
    self.textview.delegate=self;
    if ([self.type isEqualToString:@"edit"])
    {
        self.textview.text=self.model.Msg;
        self.titleText.text=self.model.Title;
    }else
    {
         [self.view addSubview:textViewPlaceholderLabel];
    }
   

    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        textViewPlaceholderLabel.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        textViewPlaceholderLabel.hidden = NO;
    }
    return YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)done:(UIButton *)sender
{
    if (self.titleText.text.length&&self.textview.text.length)
    {
        if ([self.type isEqualToString:@"edit"])
        {
            [self editAfich];
        }else
        {
            [self addAfich];
        }

        
    }else
    {
        [self alertShowWithStr:@"请填写完整信息"];
        
    }
    
}
-(void)addAfich
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"CMS_Notice",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"Title":self.titleText.text,@"Msg":self.textview.text}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        [SVProgressHUD showWithStatus:@"加载中"];
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });

            
           
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithStr:@"上传失败,稍后再试"];
            
            
        }
        
        
    } Faile:^(NSError *error) {
        [self alertShowWithStr:@"上传失败,稍后再试"];
        return;
        NSLog(@"失败%@",error);
    }];
    

}
-(void)editAfich
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"CMS_Notice",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"Title":self.titleText.text,@"Msg":self.textview.text,@"ID":self.model.ID}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
       
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });
      
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithStr:@"上传失败,稍后再试"];
            
            
        }
        
        
    } Faile:^(NSError *error) {
        [self alertShowWithStr:@"上传失败,稍后再试"];
        return;
        NSLog(@"失败%@",error);
    }];
    

    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
