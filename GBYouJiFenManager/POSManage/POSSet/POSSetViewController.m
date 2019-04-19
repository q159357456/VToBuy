//
//  POSSetViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "POSSetViewController.h"
#import "POSCollectionViewCell.h"
#import "PageFototerViewController.h"
#import "elseSetViewController.h"
#import "POSSetModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "MobileViewController.h"
#import "HouseDataViewController.h"
#import "MobileViewController.h"
#import "FloorViewController.h"
#import "CashierManageViewController.h"
#import "discountViewController.h"
@interface POSSetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@end

@implementation POSSetViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    _model = [[FMDBMember shareInstance] getMemberData][0];
    _conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    [self getPOSSetData];
    
    [self initCollectionView];
}

-(void)getPOSSetData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"cms_commpara",@"SelectField":@"*",@"Condition":_conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataArray = [POSSetModel getDataWithDic:dic1];
        POSSetModel *setModel = _dataArray[0];
        NSLog(@"%@",setModel);
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}



-(void)initCollectionView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleArray=@[@"小票份数",@"小票页脚",@"其他设置",@"收银员管理",@"预定时间表",@"配送时间表",@"班次",@"结账方式",@"折扣设置"];
    _imageArray=@[@"17",@"18",@"19",@"21",@"22-1",@"010",@"014",@"008",@"20",@"21",@"MerchantSet_5"];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"POSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POSCollectionViewCell"];
    _collectionview.backgroundColor=[UIColor groupTableViewBackgroundColor];
}

#pragma mark--collction
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titleArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    POSCollectionViewCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"POSCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.name.text=_titleArray[indexPath.row];
    cell.img.image=[UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //小票份数
            PageFototerViewController *comm=[[PageFototerViewController alloc]init];
            comm.title=@"小票份数";
            comm.tagNum = 900;
            POSSetModel *model = _dataArray[0];
            comm.setModel = model;
            comm.backBlock = ^{
                [self getPOSSetData];
            };
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
        }
            
            break;
        case 1:
        {
            //小票页脚
            PageFototerViewController *comm=[[PageFototerViewController alloc]init];
            comm.title=@"小票页脚";
            comm.tagNum = 901;
            POSSetModel *model = _dataArray[0];
            comm.setModel = model;
            comm.backBlock = ^{
                [self getPOSSetData];
            };
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
        }
            break;
        case 2:
        {
            //其他设置
            elseSetViewController *comm=[[elseSetViewController alloc]init];
            comm.title=@"其他设置";
            POSSetModel *model = _dataArray[0];
            comm.modelSet = model;
            comm.backBlock = ^{
                [self getPOSSetData];
            };
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
            
        }
            break;
        case 3:
        {
            //收银员管理
            CashierManageViewController *comm=[[CashierManageViewController alloc]init];
            comm.title=self.titleArray[indexPath.row];
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
            
        }
            break;
        case 4:
        {

            //预定时间表
            MobileViewController *comm=[[MobileViewController alloc]init];
            comm.title=self.titleArray[indexPath.row];
            comm.tagNum = 109;
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
        }
            break;
        case 5:
        {
  
            //配送时间表
            FloorViewController *comm=[[FloorViewController alloc]init];
            comm.title=self.titleArray[indexPath.row];
            comm.tagNum = 110;
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
        }
            break;
        case 6:
        {
     
            //班次
            HouseDataViewController *comm=[[HouseDataViewController alloc]init];
            comm.title=self.titleArray[indexPath.row];
            comm.tagNum = 107;
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
        }
            break;
        case 7:
        {
           
            //结账方式
            HouseDataViewController *comm=[[HouseDataViewController alloc]init];
            comm.title=self.titleArray[indexPath.row];
            comm.tagNum = 116;
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];

            
            
        }
            break;
        case 8:
        {
            
          
      
                        discountViewController *comm=[[discountViewController alloc]init];
                        comm.title=@"折扣管理管理";
                        //            comm.funType=@"KanJia";
                        [comm setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:comm animated:YES];
            
            
        }
            break;
                
        default:
            break;
    }
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(screen_width/3-1, screen_width/3-1);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
