//
//  SeatCodeViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/25.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SeatCodeViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "UIImage+MSTool.h"
@interface SeatCodeViewController ()
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *seatName;


@end

@implementation SeatCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=navigationBarColor;
     MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    _seatName.text=_seatNa;
    _shopName.text=model.ShopName;
    _doneButton.backgroundColor=navigationBarColor;
    [self getURL];
    // Do any additional setup after loading the view from its nib.
}
-(void)getURL
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetDeskQRcodeUrl" With:nil and:^(id responseObject) {
        
        NSString *url=[JsonTools getNSString:responseObject];
        if (url.length) {
             [SVProgressHUD dismiss];
            [self getCodeImageWithStr:url];
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:@"获取失败联系管理员"];
        }
        
    } Faile:^(NSError *error) {
        
    }];
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;
    
    action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)getCodeImageWithStr:(NSString*)codeurl
{
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSMutableString *muStr=[NSMutableString stringWithString:@"/upload/"];
    [muStr appendString:model.LogoUrl];
    NSString *IsPreOrder=[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPreOrder"];
       NSString *urlStr=[NSString stringWithFormat:@"%@?shopid=%@&sourceImg=%@&ft_id=%@&company=%@&IsPreOrder=%@",codeurl,model.SHOPID,muStr,self.seatNo,model.COMPANY,IsPreOrder];
   ;
    NSDictionary *dic=@{@"url":urlStr,@"sourceImg":muStr};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/posservice.asmx/GeneratePayURLImgQRCode" With:dic and:^(id responseObject) {
        if (!responseObject)
        {
            [self alertShowWithStr:@"获取二维码失败,稍后再试"];
        }else
        {
               _imageview.image=[UIImage imageWithData:responseObject];
        }
     
        
    } Faile:^(NSError *error) {
        
    }];


    
}
- (IBAction)done:(UIButton *)sender {
    UIImage *image=[UIImage imageWithCaptureView:_backView];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存图片到照片库
    [self alertShowWithStr:@"已经保存到相册"];
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
