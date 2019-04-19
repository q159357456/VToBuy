//
//  StorePreviewViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StorePreviewViewController.h"
#import "ChooseTableViewCell.h"
#import "StorePreTableViewCell.h"
#import "StorePreTwoTableViewCell.h"
#import "StorePreThreeTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "CouponModel.h"
#import "XRCarouselView.h"
#import "PictureModel.h"
@interface StorePreviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *pictureArray;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)XRCarouselView *carouseview;
@end

@implementation StorePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
   self.model=[[FMDBMember shareInstance]getMemberData][0];
    self.tableview.contentInset=UIEdgeInsetsMake(screen_width/2, 0,5, 0);
   
    [self getPictureData];
 
    
    // Do any additional setup after loading the view from its nib.
}
-(UIView*)getHeaderview
{
    if (![self.tableview.subviews containsObject:_carouseview]) {
        _carouseview=[[XRCarouselView alloc]initWithFrame:CGRectMake(0,-screen_width/2, screen_width, screen_width/2)];
        
        
        
        _carouseview.imageArray=_pictureArray;
        _carouseview.time=2;
        _carouseview.imageClickBlock=^(NSInteger index){
            
        };
        
    }
    return _carouseview;

}
//滚动tableview 完毕之后
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float offSet=scrollView.contentOffset.y;
    
    if(offSet < -150) {
        
        CGRect f = self.imageview.frame;
        f.origin.y= offSet ;
        f.size.height=  -offSet;
        
//        _imageview.frame=CGRectMake(20,-screen_width+20, 70, 70);
        //改变头部视图的fram
//        self.imageview.frame= f;
        //        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+20, 80, 80);
        //        _iconImageView.frame = avatarF;
        //        _nameLabel.frame= CGRectMake(f.size.width/2-70, (f.size.height-headViewHeight)+100, 140, 40);
    }
    
}

-(void)getPictureData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_ShopPhoto",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
//        NSLog(@"---%@",dic1);
        [self changePicureDataWithArray:[PictureModel getDataWithDic:dic1]];
        [self getAllData];
    
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
-(void)changePicureDataWithArray:(NSArray*)array
{
    _pictureArray=[NSMutableArray array];
    for (PictureModel *model in array) {
        NSString *str=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PhotoUrl];
        NSString *urlStr=[str URLEncodedString];
        [_pictureArray addObject:urlStr];
    }
   
    
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"sales_coupon",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@",self.model.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"---%@",dic1);
        
        _dataArray=[CouponModel getDataWithDic:dic1];

        [self.tableview reloadData];
         [self.tableview addSubview:[self getHeaderview]];
        [self getLogo];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}
-(void)getLogo
{
    

    _imageview=[[UIImageView alloc]init];
    [_imageview sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",PICTUREPATH,self.model.LogoUrl] URLEncodedString]] placeholderImage:[UIImage imageNamed:@"shzx2"]];
    _imageview.frame=CGRectMake(20,-20, 62, 62);
    _imageview .layer.cornerRadius=30;
    _imageview.layer.masksToBounds=YES;
    _imageview.layer.borderColor=[UIColor whiteColor].CGColor;
    _imageview.layer.borderWidth=2;
    [self.tableview addSubview:_imageview];

}
#pragma mark--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 3;
    }else if (section==1)
    {
        return 1;
    }else
        
    {
        return 1;
    }
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        if (indexPath.row==1)
        {
            StorePreTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"StorePreTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else
        {
            ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
           
            if (indexPath.row==0)
            {
                MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
                cell.contentLable.textAlignment=NSTextAlignmentLeft;
                cell.left.constant=100;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.contentLable.text=model.ShopName;

                
            }else
            {
//                MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
                cell.left.constant=12;
                cell.right.constant=12;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.contentLable.text=@"暂无简介";
            }
             return cell;
        
        }
   
    }else if (indexPath.section==1)
    {
        StorePreTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"StorePreTwoTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
     
    }else
        
    {
        StorePreThreeTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"StorePreThreeTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dataArray=_dataArray;
        return cell;
   
    }
    
    
    
    return nil;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==2)
        {
            return 100;
        }else
        {
            return 50;
        }
       
        
    }else if (indexPath.section==1)
    {
      
         return 50;
       
        
    }else
        
    {
     
        return 26+_dataArray.count*98+5;
    }

   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
        return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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
