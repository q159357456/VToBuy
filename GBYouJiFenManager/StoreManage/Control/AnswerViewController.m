//
//  AnswerViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AnswerViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface AnswerViewController ()<UITextViewDelegate>
{
    UILabel * textViewPlaceholderLabel;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (assign, nonatomic) BOOL isok;

@property (strong, nonatomic) QMUIButton *cribtn;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.doneButton.layer.cornerRadius=8;
    self.doneButton.layer.masksToBounds=YES;
    self.doneButton.backgroundColor=navigationBarColor;
    textViewPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 84, 250, 25)];
    textViewPlaceholderLabel.text = @"请输入你的内容(默认回复'谢谢')";
    textViewPlaceholderLabel.textColor = [UIColor grayColor];
    self.textView.delegate=self;
   
    [self.view addSubview:textViewPlaceholderLabel];

    [self zwhNew];
    
    
}

#pragma mark - 新增审核
-(void)zwhNew{
    _cribtn = [[QMUIButton alloc]init];
    _cribtn.layer.borderColor = LINECOLOR.CGColor;
    _cribtn.layer.borderWidth = 1;
    _cribtn.layer.cornerRadius = 10;
    _cribtn.layer.masksToBounds = YES;
    [self.view addSubview:_cribtn];
    [_cribtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(15));
        make.width.height.mas_equalTo(20);
        make.top.equalTo(self.view).offset(HEIGHT_PRO(25));
    }];
    _cribtn.backgroundColor = [UIColor whiteColor];
    [_cribtn addTarget:self action:@selector(isokWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    QMUIButton *textbtn = [[QMUIButton alloc]init];
    [textbtn setTitle:@"审核通过" forState:0];
    [textbtn setTitleColor:navigationBarColor forState:0];
    [self.view addSubview:textbtn];
    [textbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cribtn.mas_right).offset(WIDTH_PRO(6));
        make.centerY.equalTo(_cribtn);
    }];
    
    [textbtn addTarget:self action:@selector(isokWithBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 是否审核
-(void)isokWithBtn:(UIButton *)btn{
    _isok = !_isok;
    _cribtn.backgroundColor = _isok?navigationBarColor:[UIColor whiteColor];
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

- (IBAction)answer:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (!_isok) {
        [QMUITips showInfo:@"选择审核通过才能发布回复"];
        return;
    }
        [SVProgressHUD showWithStatus:@"加载中"];
        MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
        NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"crm_evaluation",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"ID":self.model.ID,@"MemberNo":_model.MemberNo,@"ReplyMsg":_textView.text.length>0?_textView.text:@"谢谢",@"status":@"Y"}]};
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            
            
            NSString *str=[JsonTools getNSString:responseObject];
            NSLog(@"%@",str);
            if ([str isEqualToString:@"OK"])
            {
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"evaluatrefresh" object:nil];
                });
                
            }else
            {
                [SVProgressHUD dismiss];
                
                [self alertShowWithStr:@"上传失败,稍后再试"];
                
                
            }
            
            
        } Faile:^(NSError *error) {
            [self alertShowWithStr:@"上传失败,稍后再试"];
            return;
        }];
   
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
