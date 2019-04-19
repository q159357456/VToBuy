//
//  ShopCodeViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ShopCodeViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "UIImage+MSTool.h"
@interface ShopCodeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)UIImageView *copyimageview;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIButton *donebutton;

@end

@implementation ShopCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[ColorTool colorWithHexString:@"#f5f5f5"];
    _copyimageview=[[UIImageView alloc]initWithFrame:CGRectMake(16,90, 343, 410)];
    [self.view addSubview:_copyimageview];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    _titleLabel.text=model.ShopName;
    [self getURL];
    // Do any additional setup after loading the view from its nib.
}
-(void)setBackView:(UIView *)backView
{
    _backView=backView;
    _backView.backgroundColor=[UIColor whiteColor];
    _backView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _backView.layer.borderWidth=1;
}
-(void)setDonebutton:(UIButton *)donebutton
{
    _donebutton=donebutton;
    donebutton.backgroundColor=MainColor;
   
}
-(void)getURL
{
    [SVProgressHUD showWithStatus:@"加载中"];
 
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetQRcodeUrl" With:nil and:^(id responseObject) {
      
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
-(void)getCodeImageWithStr:(NSString*)url
{
//    NSLog(@"-----%@",url);
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSMutableString *muStr=[NSMutableString stringWithString:@"/upload/"];
    [muStr appendString:model.LogoUrl];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@?m_id=%@&",url,model.SHOPID];
     NSDictionary *dic=@{@"url":urlStr,@"sourceImg":muStr};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"PosService.asmx/GeneratePayURLImgQRCode" With:dic and:^(id responseObject) {
        if (!responseObject)
        {
            [self alertShowWithStr:@"获取二维码失败,稍后再试"];
        }else
        {
            _imageView.image=[UIImage imageWithData:responseObject];
        }
        
        
    } Faile:^(NSError *error) {
        
    }];


}


- (IBAction)saveToPhoto:(UIButton *)sender
{
       UIImage *image=[UIImage imageWithCaptureView:_backView];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存图片到照片库
    [self alertShowWithStr:@"已经保存到相册"];
 
}




@end
