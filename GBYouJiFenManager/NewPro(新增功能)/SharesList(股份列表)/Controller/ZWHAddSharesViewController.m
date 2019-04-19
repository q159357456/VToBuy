//
//  ZWHAddSharesViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/3.
//  Copyright © 2018年 秦根. All rights reserved.
//

#import "ZWHAddSharesViewController.h"
#import "ZWHSharesModel.h"
#import <IQKeyboardManager.h>

@interface ZWHAddSharesViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *shares;
@property(nonatomic,strong)UITextField *baseT;
@property(nonatomic,strong)QMUIButton *time;

@property(nonatomic,strong)UIImageView *codeImg;


@end

@implementation ZWHAddSharesViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"股份名额";
    self.view.backgroundColor = LINECOLOR;
    [self setUI];
    
    QMUIButton *btn = [[QMUIButton alloc]init];
    [btn setTitle:@"完成" forState:0];
    btn.tintColorAdjustsTitleAndImage = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(zwhdoneWith:) forControlEvents:UIControlEventTouchUpInside];
    if (_mymodel) {
        _shares.text = _mymodel.Ratio;
        [_time setTitle:[[NSDate dateTomorrow] stringWithFormat:@"yyyy-MM-dd"] forState:0];
        _baseT.text = [NSString stringWithFormat:@"%ld",_mymodel.BaseNum];
    }
}

#pragma mark - 完成
-(void)zwhdoneWith:(QMUIButton *)btn{
    [self.view endEditing:YES];
    if ([_state isEqualToString:@"0"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (!(self.shares.text.length>0)) {
            [QMUITips showError:@"请输入股份比例" inView:self.view hideAfterDelay:2];
            return;
        }
        if ([self.shares.text floatValue]>_maxShares) {
            [QMUITips showError:@"不能超过当前能分配的份额" inView:self.view hideAfterDelay:2];
            return;
        }
        
        if (!(self.baseT.text.length>0)) {
            [QMUITips showError:@"请输入计算份数，可为0"];
            return;
        }
        
        NSDictionary *dict = @{@"effective":self.time.titleLabel.text,@"baseNum":_baseT.text,@"ratio":self.shares.text,@"shopid":_mymodel.ShopID,@"memberid":_mymodel.MemberID,@"CipherText":CIPHERTEXT};
        [self showEmptyViewWithLoading];
        NSLog(@"%@",dict);
        MJWeakSelf;
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/posservice.asmx/PartnerModify" With:dict and:^(id responseObject) {
            NSString *str = [JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"succeed"]) {
                [self hideEmptyView];
                NOTIFY_POST(NOTIFY_SHARES);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [QMUITips showInfo:@"修改失败"];
            }
        } Faile:^(NSError *error) {
            [self hideEmptyView];
            NSLog(@"失败%@",error);
        }];
    }
}


-(void)setUI{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(15));
        make.right.equalTo(self.view).offset(-WIDTH_PRO(15));
        make.height.mas_equalTo(HEIGHT_PRO(240));
        make.top.equalTo(self.view).offset((ZWHNavHeight)+WIDTH_PRO(15));
    }];
    [topView layoutIfNeeded];
    topView.qmui_dashPhase = 3;
    topView.qmui_dashPattern = @[@6,@3];
    topView.qmui_borderColor = LINECOLOR;
    topView.qmui_borderWidth = 1;
    topView.qmui_borderPosition = QMUIViewBorderPositionBottom;
    
    
    QMUILabel *sharesL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    sharesL.text = @"股份份额:";
    [topView addSubview:sharesL];
    [sharesL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(WIDTH_PRO(36));
        make.top.equalTo(topView).offset(HEIGHT_PRO(17));
    }];
    
    _shares = [[UITextField alloc]init];
    _shares.layer.borderColor = LINECOLOR.CGColor;
    _shares.layer.borderWidth = 1;
    _shares.keyboardType = UIKeyboardTypeDecimalPad;
    //_shares.maximumTextLength = 2;
    _shares.delegate = self;
    _shares.placeholder = @"输入股份分配比例";
    [topView addSubview:_shares];
    [_shares mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_PRO(171));
        make.height.mas_equalTo(HEIGHT_PRO(30));
        make.centerY.equalTo(sharesL);
        make.left.equalTo(sharesL.mas_right).offset(WIDTH_PRO(8));
    }];
    [_shares layoutIfNeeded];
    
    QMUILabel *fenL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    fenL.text = @"%";
    [topView addSubview:fenL];
    [fenL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shares.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(_shares);
    }];
    
    QMUILabel *tip = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:navigationBarColor];
    tip.text = [NSString stringWithFormat:@"(当前最高可分配%.1f)",_maxShares];
    [topView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shares.mas_left);
        make.top.equalTo(_shares.mas_bottom);
    }];
    
    
    QMUILabel *baseL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    baseL.text = @"赠送基数:";
    [topView addSubview:baseL];
    [baseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sharesL.mas_left);
        make.top.equalTo(sharesL.mas_bottom).offset(HEIGHT_PRO(43));
    }];
    
    _baseT = [[UITextField alloc]init];
    _baseT.layer.borderColor = LINECOLOR.CGColor;
    _baseT.layer.borderWidth = 1;
    _baseT.keyboardType = UIKeyboardTypeNumberPad;
    //_shares.maximumTextLength = 2;
    _baseT.delegate = self;
    _baseT.placeholder = @"参与派派金计算的份数";
    [topView addSubview:_baseT];
    [_baseT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_PRO(171));
        make.height.mas_equalTo(HEIGHT_PRO(30));
        make.centerY.equalTo(baseL);
        make.left.equalTo(baseL.mas_right).offset(WIDTH_PRO(8));
    }];
    [_shares layoutIfNeeded];
    
    QMUILabel *baiL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    baiL.text = @"份";
    [topView addSubview:baiL];
    [baiL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseT.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(_baseT);
    }];
    
    
    QMUILabel *timeL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    timeL.text = @"生效日期:";
    [topView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseL.mas_left);
        make.top.equalTo(baseL.mas_bottom).offset(HEIGHT_PRO(43));
    }];
    
    _time = [[QMUIButton alloc]init];
    _time.titleLabel.font = ZWHFont(14);
    [_time setTitleColor:[UIColor blackColor] forState:0];
    [_time setTitle:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forState:0];
    _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [topView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shares.mas_left);
        make.centerY.equalTo(timeL);
    }];
    [_time addTarget:self action:@selector(zwhchooseTime) forControlEvents:UIControlEventTouchUpInside];
    
    QMUIButton *codeBtn = [[QMUIButton alloc]init];
    codeBtn.tintColorAdjustsTitleAndImage = navigationBarColor;
    codeBtn.layer.borderColor = navigationBarColor.CGColor;
    codeBtn.layer.borderWidth = 1;
    codeBtn.layer.cornerRadius = 6;
    codeBtn.layer.masksToBounds = YES;
    codeBtn.titleLabel.font = ZWHFont(14);
    [codeBtn setTitle:@"生产二维码" forState:0];
    [topView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_PRO(180));
        make.height.mas_equalTo(HEIGHT_PRO(35));
        make.centerX.equalTo(topView);
        make.bottom.equalTo(topView).offset(-HEIGHT_PRO(30));
    }];
    [codeBtn addTarget:self action:@selector(creatCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *midView = [[UIView alloc]init];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(15));
        make.right.equalTo(self.view).offset(-WIDTH_PRO(15));
        make.height.mas_equalTo(HEIGHT_PRO(300));
        make.top.equalTo(topView.mas_bottom);
    }];
    
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
    
    _codeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"11-1"]];
    [midView addSubview:_codeImg];
    [_codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_PRO(200));
        make.height.mas_equalTo(HEIGHT_PRO(210));
        make.centerX.equalTo(midView);
        make.top.equalTo(midView).offset(HEIGHT_PRO(30));
    }];
    
    QMUILabel *midtip = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:navigationBarColor];
    midtip.text = @"注:请您使用微信扫一扫,即可分配完成";
    midtip.textAlignment = NSTextAlignmentCenter;
    [midView addSubview:midtip];
    [midtip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_codeImg);
        make.top.equalTo(_codeImg.mas_bottom).offset(HEIGHT_PRO(11));
    }];
    
}


#pragma mark - 生产二维码
-(void)creatCode{
    [self.view endEditing:YES];
    if (!(self.shares.text.length>0)) {
        [QMUITips showError:@"请输入股份比例" inView:self.view hideAfterDelay:2];
        return;
    }
    if ([self.shares.text floatValue]>_maxShares) {
        [QMUITips showError:@"不能超过当前能分配的份额" inView:self.view hideAfterDelay:2];
        return;
    }
    if (!(self.baseT.text.length>0)) {
        [QMUITips showError:@"请输入计算份数，可为0"];
        return;
    }
    
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dict = @{@"date":self.time.titleLabel.text,@"baseNum":_baseT.text,@"nums":self.shares.text,@"shopid":model.SHOPID};
    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/posservice.asmx/GeneratePartnerURL" With:dict and:^(id responseObject) {
        [self hideEmptyView];
        UIImage *img = [UIImage imageWithData:responseObject];
        weakSelf.codeImg.image = img;
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
    
}



#pragma mark - 选择日期
-(void)zwhchooseTime{
    [self.view endEditing:YES];
    MJWeakSelf
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:zwhDateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        [weakSelf.time setTitle:[selectDate stringWithFormat:@"yyyy-MM-dd"] forState:0];
    }];
    datepicker.dateLabelColor = [UIColor clearColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = MAINCOLOR;//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    datepicker.minLimitDate = [_state isEqualToString:@"0"]?[NSDate date]:[NSDate dateTomorrow];
    [datepicker show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _shares) {
        if(((string.intValue<0) || (string.intValue>9))){
            //MyLog(@"====%@",string);
            if ((![string isEqualToString:@"."])) {
                return NO;
            }
            return NO;
        }
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger dotNum = 0;
        NSInteger flag=0;
        const NSInteger limited = 1;
        if((int)futureString.length>=1){
            
            if([futureString characterAtIndex:0] == '.'){//the first character can't be '.'
                return NO;
            }
            if((int)futureString.length>=2){//if the first character is '0',the next one must be '.'
                if(([futureString characterAtIndex:1] != '.'&&[futureString characterAtIndex:0] == '0')){
                    return NO;
                }
            }
        }
        NSInteger dotAfter = 0;
        for (int i = (int)futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                dotNum ++;
                dotAfter = flag+1;
                if (flag > limited) {
                    return NO;
                }
                if(dotNum>1){
                    return NO;
                }
            }
            flag++;
        }
        if(futureString.length - dotAfter > 2){
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
    
}


@end
