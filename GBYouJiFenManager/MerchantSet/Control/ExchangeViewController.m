//
//  ExchangeViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/22.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ExchangeViewController.h"
#import "AddDetailTableViewCell.h"
#import "ScanningQRCodeVC.h"
#import "MemberModel.h"
#import "FMDBMember.h"

@interface ExchangeViewController ()
@property(nonatomic,copy)NSString *code;
@property(nonatomic,strong)AddDetailTableViewCell *cell;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)creatUI
{

    _doneButton.backgroundColor=MainColor;
    _cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
    _cell.frame=CGRectMake(0, 100, screen_width, 50);
    _cell.nameLable.text=@"输入验证码";
    _cell.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    _cell.layer.borderWidth=1.0;
    [self.view addSubview:_cell];
    [self addButtonWithCell:_cell];

    
}

-(void)addButtonWithCell:(AddDetailTableViewCell*)cell
{
    UIButton *pluse=[UIButton buttonWithType:UIButtonTypeCustom];
    [pluse setBackgroundImage:[UIImage imageNamed:@"saoma"] forState:UIControlStateNormal];
//    pluse.backgroundColor=[ColorTool colorWithHexString:@"#a0a0a0"];
    [pluse addTarget:self action:@selector(pluseClick) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:pluse];
    cell.right.constant=60;
    [pluse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(cell.mas_centerY);
        
    }];
    
    
}
-(void)pluseClick
{
    //扫码
    ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
    [VC setHidesBottomBarWhenPushed:YES];
    __weak typeof(self)weakSelf=self;
    VC.backBlock=^(NSString *code){
        weakSelf.cell.inputText.text=code;
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (IBAction)done:(UIButton *)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
   ;
    NSDictionary *dic=@{@"company":model.COMPANY,@"shopid":model.SHOPID,@"billnumber":self.cell.inputText.text};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/VerityMallProduct" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        [self alertShowWithStr:str];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
