//
//  ZWHMainDetailViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/10/19.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHMainDetailViewController.h"

@interface ZWHMainDetailViewController ()

@property(nonatomic,strong)QMUITextView *textView;

@end

@implementation ZWHMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setUI];
}

#pragma mark - setui
-(void)setUI{
    _textView = [[QMUITextView alloc]init];
    _textView.layer.borderColor = navigationBarColor.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 6;
    _textView.layer.masksToBounds = YES;
    _textView.placeholder = @"基础评价";
    _textView.font = ZWHFont(14);
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(15));
        make.right.equalTo(self.view).offset(-WIDTH_PRO(15));
        make.top.equalTo(self.view).offset(ZWHNavHeight+HEIGHT_PRO(15));
        make.height.mas_equalTo(HEIGHT_PRO(250));
    }];
    
    QMUIButton *btn = [[QMUIButton alloc]init];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.backgroundColor = navigationBarColor;
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(WIDTH_PRO(30));
        make.right.equalTo(self.view).offset(-WIDTH_PRO(30));
        make.top.equalTo(_textView.mas_bottom).offset(HEIGHT_PRO(15));
        make.height.mas_offset(HEIGHT_PRO(40));
    }];
    if (_model) {
        [btn setTitle:@"保存" forState:0];
        [btn addTarget:self action:@selector(editOld) forControlEvents:UIControlEventTouchUpInside];
        _textView.text = _model.info;
    }else{
        [btn setTitle:@"添加" forState:0];
        [btn addTarget:self action:@selector(addNew) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 修改
-(void)editOld{
    if (!(_textView.text.length>0)) {
        [QMUITips showInfo:@"请输入基础内容"];
        return;
    }
    MemberModel *userModel = [[FMDBMember shareInstance] getMemberData][0];
    NSDictionary *jsonDic=@{@"Command":@"Edit",@"TableName":@"crm_evaluationinfo",@"Data":@[@{@"shopid":userModel.SHOPID,@"info":_textView.text,@"sysid":_model.sysid}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    MJWeakSelf;
    [self showEmptyViewWithLoading];
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        [weakSelf hideEmptyView];
        if ([str isEqualToString:@"OK"])
        {
            [QMUITips showSucceed:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mainrefresh" object:nil];
        }else{
            [QMUITips showError:@"修改失败"];
        }
    } Faile:^(NSError *error) {
    }];

}


#pragma mark - 添加
-(void)addNew{
    if (!(_textView.text.length>0)) {
        [QMUITips showInfo:@"请输入基础内容"];
        return;
    }
    MemberModel *userModel = [[FMDBMember shareInstance] getMemberData][0];
    NSDictionary *jsonDic=@{@"Command":@"Add",@"TableName":@"crm_evaluationinfo",@"Data":@[@{@"shopid":userModel.SHOPID,@"info":_textView.text}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    MJWeakSelf;
    [self showEmptyViewWithLoading];
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        [weakSelf hideEmptyView];
        if ([str isEqualToString:@"OK"])
        {
            [QMUITips showSucceed:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"mainrefresh" object:nil];
        }else{
            [QMUITips showError:@"添加失败"];
        }
    } Faile:^(NSError *error) {
    }];
}




@end
