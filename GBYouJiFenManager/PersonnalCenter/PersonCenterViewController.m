//
//  PersonCenterViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/11.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonOneTableViewCell.h"
#import "AddDetailTableViewCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FMDBMember.h"
#import "ChangePassViewController.h"
#import "DepositViewController.h"
#import "AccountViewController.h"
#import "ChooseTableViewCell.h"
#import "PersonTwoTableViewCell.h"
#import "CrashDetailViewController.h"
#import "ScoreViewController.h"
#import "ZWHInviteCodeViewController.h"
#import "ZWHPersonOneTableViewCell.h"

@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSArray *titileArray;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)MemberModel *myModel;

@end

@implementation PersonCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refrsh];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerClass:[ZWHPersonOneTableViewCell class] forCellReuseIdentifier:@"ZWHPersonOneTableViewCell"];
    _titileArray=@[@"手机验证",@"申请提现",@"提现账户",@"商户结算",@"修改密码",@"客服电话",@"公司编号",@"店铺编号"];
    self.tableview.contentInset=UIEdgeInsetsMake(150, 0, 100, 0);
    [self.tableview addSubview:[self getHeaderview]];
    [self.tableview addSubview:[self getFootview]];
    
    QMUIButton *btn = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"ewm"] title:@""];
    [btn addTarget:self action:@selector(zwhInviteCode:) forControlEvents:UIControlEventTouchUpInside];
    btn.tintColorAdjustsTitleAndImage = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

#pragma mark - 邀请码
-(void)zwhInviteCode:(QMUIButton *)btn{
    ZWHInviteCodeViewController *vc = [[ZWHInviteCodeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(UIView*)getFootview
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(50,623, screen_width-100,40);
    button.backgroundColor=MainColor;
    button.layer.cornerRadius=8;
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}
-(void)outClick
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认退登陆？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[FMDBMember shareInstance]deleteTable];
        [self page];
        
    }];
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)crashClick
{
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    if ([model.IsReportManager isEqualToString:@"True"]) {
        CrashDetailViewController *cash=[[CrashDetailViewController alloc]init];
        cash.leftCrash=model.Cash1;
        cash.title=@"账户明细";
        [cash setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cash animated:YES];
    }else{
        [QMUITips showInfo:@"您的权限不能访问此功能"];
    }
}
-(void)scoreClick
{
    ScoreViewController *cash=[[ScoreViewController alloc]init];
    cash.title=@"佣金记录";
    [cash setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cash animated:YES];
    NSLog(@"佣金账户");
}

//刷新
-(void)refrsh{
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    NSString *con = [NSString stringWithFormat:@"shopid$=$%@",model.SHOPID];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Shop",@"SelectField":@"*",@"Condition":con,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
//    NSLog(@"====>%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetCommSelectDataInfo3 With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSArray *arry=[MemberModel getDataWithDicPerson:dic1];
        if (arry.count>0)
        {
            MemberModel *model=arry[0];
            if ([model.Status isEqualToString:@"True"])
            {
                self.myModel = model;
                [[FMDBMember shareInstance]updateUser:model];
                //存入模式
                [[NSUserDefaults standardUserDefaults]setValue:dic1[@"DataSet"][@"Shop"][0][@"IsPreOrder"] forKey:@"IsPreOrder"];
                [[NSUserDefaults standardUserDefaults] synchronize ];
                [[NSUserDefaults standardUserDefaults]setValue:dic1[@"DataSet"][@"Shop"][0][@"pos_runmodel"] forKey:@"POS_RunModel"];
                [[NSUserDefaults standardUserDefaults]setValue:dic1[@"DataSet"][@"Shop"][0][@"ShopType"] forKey:@"ShopType"];
                [[NSUserDefaults standardUserDefaults] synchronize ];
                [self.tableview reloadData];
            }
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titileArray.count+3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MemberModel *model;
    if (self.myModel) {
        model = self.myModel;
    }else{
        model = [[FMDBMember shareInstance]getMemberData][0];
    }
    if (indexPath.row==0)
    {
        
        ZWHPersonOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHPersonOneTableViewCell" forIndexPath:indexPath];
        [cell.yongBtn addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.xianBtn addTarget:self action:@selector(crashClick) forControlEvents:UIControlEventTouchUpInside];
        cell.yongjin.text = [NSString stringWithFormat:@"%.2f",[model.Cash2 floatValue]];
        cell.xianjin.text = [NSString stringWithFormat:@"%.2f",[model.Cash1 floatValue]];
        cell.chongzhi.text = [NSString stringWithFormat:@"%.2f",[model.Cash3 floatValue]];
        return cell;
        
        
    }else if(indexPath.row==9)
    {
        
        ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        cell.contentLable.textAlignment=NSTextAlignmentLeft;
        NSString *str=[NSString stringWithFormat:@"         %@",@"注册码:"];
        cell.contentLable.text=str;
        return cell;
        
    }else if(indexPath.row==10)
    {
        PersonTwoTableViewCell*cell=[[NSBundle mainBundle]loadNibNamed:@"PersonTwoTableViewCell" owner:nil options:nil][0];
        cell.contentlable.text=model.UDF01;
        cell.copyBlock=^{
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            pasteboard.string =model.UDF01;
            
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
            
        };
        return cell;
    }
    else
    {
        static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle=  UITableViewCellSelectionStyleDefault;
        cell.nameLable.text=_titileArray[indexPath.row-1];
        
        cell.inputText.enabled=NO;
        
        if (indexPath.row==7) {
            cell.inputText.text=model.COMPANY;
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==8) {
            cell.inputText.text=model.SHOPID;
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==6)
        {
            cell.inputText.text=model.telphone;
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==1) {
            cell.inputText.text=model.Mobile;
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==4) {
            cell.inputText.text=model.ShopDiscount;
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row!=1&&indexPath.row!=4&&indexPath.row!=6&&indexPath.row!=7&&indexPath.row!=8)
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        return cell;
        
    }
    
    return nil;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    switch (indexPath.row) {
        case 1:
        {
            NSLog(@"手机验证");
        }
            break;
        case 2:
        {
            
            if ([model.IsCashManager isEqualToString:@"True"]) {
                DepositViewController *change=[[DepositViewController alloc]init];
                change.title=@"申请提现";
                [change setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:change animated:YES];
            }else{
                [QMUITips showInfo:@"您的权限不能访问此功能"];
            }
        }
            break;
        case 3:
        {
            if ([model.IsCashManager isEqualToString:@"True"]) {
                NSLog(@"提现账户");
                AccountViewController *change=[[AccountViewController alloc]init];
                change.title=@"提现账户";
                [change setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:change animated:YES];
            }else{
                [QMUITips showInfo:@"您的权限不能访问此功能"];
            }
        }
            break;
        case 4:
        {
            NSLog(@"会员折扣");
        }
            break;
        case 5:
        {
            NSLog(@"修改密码");
            ChangePassViewController *change=[[ChangePassViewController alloc]init];
            change.title=@"修改密码";
            [change setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:change animated:YES];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}
-(void)page
{
    [UIView animateWithDuration:0.5 animations:^
     {
         self.view.alpha = 0.9;
     } completion:^(BOOL finished)
     {
         
         
         //做翻页动画
         [UIView transitionWithView:self.view.window duration:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
         
         AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
         
         appDelegate.window.rootViewController=[LoginViewController alloc];
         
     }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 90;
        
    }else
    {
        return 50;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(UIView*)getHeaderview
{
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    _imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, -150, screen_width, 150)];
    _imageview.backgroundColor=navigationBarColor;
    NSString *url=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.LogoUrl];
    
    UIImageView *headpicture=[[UIImageView alloc]init];
    headpicture.layer.cornerRadius=40;
    headpicture.layer.masksToBounds=YES;
    [headpicture sd_setImageWithURL:[NSURL URLWithString:[url URLEncodedString]] placeholderImage:[UIImage imageNamed:@"11-1"]];
    headpicture.layer.borderColor = [UIColor whiteColor].CGColor;
    headpicture.layer.borderWidth = 3;
    UILabel *shoplable=[[UILabel alloc]init];
    _imageview.contentMode=UIViewContentModeScaleAspectFill;
    _imageview.clipsToBounds=YES;
    shoplable.text=model.ShopName;
    shoplable.textColor = [UIColor whiteColor];
    [_imageview addSubview:headpicture];
    [_imageview addSubview:shoplable];
    [headpicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview).offset(WIDTH_PRO(30));
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.mas_equalTo(_imageview.mas_bottom).offset(-30);
        
    }];
    [shoplable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headpicture.mas_right).offset(20);
        make.centerY.equalTo(headpicture.mas_centerY);
        make.height.mas_equalTo(20);
        //make.right.mas_equalTo(_imageview.mas_right);
        //make.bottom.mas_equalTo(_imageview.mas_bottom).offset(-60);
    }];
    return _imageview;
    
}
//滚动tableview 完毕之后
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float offSet=scrollView.contentOffset.y;
    
    if(offSet < -150) {
        
        CGRect f = self.imageview.frame;
        f.origin.y= offSet ;
        f.size.height=  -offSet;
        
        
        //改变头部视图的fram
        self.imageview.frame= f;
        //        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+20, 80, 80);
        //        _iconImageView.frame = avatarF;
        //        _nameLabel.frame= CGRectMake(f.size.width/2-70, (f.size.height-headViewHeight)+100, 140, 40);
    }
    
}


@end
