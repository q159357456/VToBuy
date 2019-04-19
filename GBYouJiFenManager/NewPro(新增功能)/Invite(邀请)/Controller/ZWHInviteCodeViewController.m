//
//  ZWHInviteCodeViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/14.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHInviteCodeViewController.h"

@interface ZWHInviteCodeViewController ()

@property(nonatomic,strong)UIImageView *codeImg;

@property(nonatomic,strong)NSString *qrCodeImg;

@property(nonatomic,strong)UIImage *imageCode;

@end

@implementation ZWHInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请二维码";
    self.view.backgroundColor = LINECOLOR;
    //[self setUI];
    [self getCodeurl];
}

-(void)getCodeurl{
    MJWeakSelf;
    [self showEmptyViewWithLoading];
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"SystemCommService.asmx/GetInviteQRcodeUrl" With:@{} and:^(id responseObject) {
        NSString *resdict=[JsonTools getNSString:responseObject];
        NSLog(@"%@",resdict);
        weakSelf.qrCodeImg = resdict;
        [weakSelf getQCodeImg];
    } Faile:^(NSError *error) {
        
    }];
}

-(void)getQCodeImg{
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *url=[NSString stringWithFormat:@"/upload/%@",model.LogoUrl];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/GeneratePayURLImgQRCode" With:@{@"url":[NSString stringWithFormat:@"%@?parentid=%@&parenttype=S",_qrCodeImg,model.SHOPID],@"sourceImg":url} and:^(id responseObject) {
        [weakSelf hideEmptyView];
        weakSelf.imageCode = [UIImage imageWithData:responseObject];
        [weakSelf setUI];
    } Faile:^(NSError *error) {
        
    }];
}

-(void)setUI{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(15));
        make.right.equalTo(self.view).offset(-WIDTH_PRO(15));
        make.height.mas_equalTo(HEIGHT_PRO(100));
        make.top.equalTo(self.view).offset((ZWHNavHeight)+WIDTH_PRO(15));
    }];
    [topView layoutIfNeeded];
    topView.qmui_dashPhase = 3;
    topView.qmui_dashPattern = @[@3,@3];
    topView.qmui_borderColor = [UIColor qmui_colorWithHexString:@"BBBBBB"];
    topView.qmui_borderWidth = 1;
    topView.qmui_borderPosition = QMUIViewBorderPositionBottom;
    topView.layer.cornerRadius = WIDTH_PRO(8);
    topView.layer.masksToBounds = YES;
    
    QMUILabel *toptip = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(20) textColor:[UIColor qmui_colorWithHexString:@"EA5519"]];
    toptip.text = @"邀请好友 扫描加入";
    toptip.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:toptip];
    [toptip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(topView);
    }];

    UIView *midView = [[UIView alloc]init];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(15));
        make.right.equalTo(self.view).offset(-WIDTH_PRO(15));
        make.height.mas_equalTo(HEIGHT_PRO(340));
        make.top.equalTo(topView.mas_bottom);
    }];
    
    midView.layer.cornerRadius = WIDTH_PRO(8);
    midView.layer.masksToBounds = YES;
    
    for (NSInteger i=0; i<2; i++) {
        UIView *corView = [[UIView alloc]init];
        corView.backgroundColor = LINECOLOR;
        corView.layer.cornerRadius = WIDTH_PRO(9);
        corView.layer.masksToBounds = YES;
        [self.view addSubview:corView];
        [corView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(WIDTH_PRO(18));
            make.centerY.equalTo(topView.mas_bottom);
            make.centerX.equalTo(i==0?topView.mas_left:topView.mas_right);
        }];
    }
    
    _codeImg = [[UIImageView alloc]initWithImage:_imageCode];
    _codeImg.contentMode = UIViewContentModeScaleAspectFill;
    [midView addSubview:_codeImg];
    [_codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_PRO(200));
        make.height.mas_equalTo(HEIGHT_PRO(210));
        make.centerX.equalTo(midView);
        make.top.equalTo(midView).offset(HEIGHT_PRO(30));
    }];
    
    QMUILabel *midtip = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:[UIColor qmui_colorWithHexString:@"8A8A8A"]];
    midtip.text = @"扫一扫二维码,快加入我们";
    midtip.numberOfLines = 2;
    midtip.textAlignment = NSTextAlignmentCenter;
    [midView addSubview:midtip];
    [midtip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_codeImg);
        make.top.equalTo(_codeImg.mas_bottom).offset(HEIGHT_PRO(11));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINECOLOR;
    [midView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(midView);
        make.height.mas_equalTo(1);
        make.top.equalTo(midtip.mas_bottom).offset(4);
    }];
    
    QMUIButton *btn = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"saveImage"] title:@"保存到手机"];
    btn.tintColorAdjustsTitleAndImage = [UIColor qmui_colorWithHexString:@"8A8A8A"];
    btn.imagePosition = QMUIButtonImagePositionLeft;
    btn.spacingBetweenImageAndTitle = 6;
    btn.titleLabel.font = ZWHFont(14);
    [midView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(HEIGHT_PRO(15));
        make.centerX.equalTo(midView);
    }];
    [btn addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
}

-(void)saveImg{
    UIImage *img = _imageCode;
    NSData* imageData =  UIImagePNGRepresentation(img);
    UIImage* newImage = [UIImage imageWithData:imageData];
    
    
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error==nil){
        [QMUITips showSucceed:@"保存成功"];
    }else{
        [QMUITips showError:@"保存失败"];
    }
}



@end
