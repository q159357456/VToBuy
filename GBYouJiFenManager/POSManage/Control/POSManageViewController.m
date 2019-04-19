//
//  POSManageViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 夏盈萍. All rights reserved.
//

#import "POSManageViewController.h"
#import "POSCollectionViewCell.h"
#import "POSSetViewController.h"
#import "roomSetViewController.h"
#import "SeatSetViewController.h"
#import "equipmentManegeViewController.h"
#import "reportFormsManageViewController.h"
#import "ReserveViewController.h"
@interface POSManageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation POSManageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createPOSUI];
    
    [self initTitleArr];
}

-(void)createPOSUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collection.alwaysBounceVertical = YES;
    self.view.backgroundColor=[UIColor whiteColor];
     _collection.backgroundColor=[UIColor whiteColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [_collection registerNib:[UINib nibWithNibName:@"POSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POSCollectionViewCell"];
    [self.view addSubview:_collection];
}

-(void)initTitleArr
{
    _TitleArr = [NSMutableArray arrayWithObjects:@"房台管理",@"设备管理",@"POS设置",@"报表管理",@"房台预定",nil];
    _ImageArr = [NSMutableArray arrayWithObjects:@"005",@"015",@"011",@"012",@"StoreManage_6", nil];
}

//实现协议方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _TitleArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    POSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"POSCollectionViewCell" forIndexPath:indexPath];
   
    cell.backgroundColor=[UIColor whiteColor];
    if (indexPath.row<_TitleArr.count) {
        cell.img.image = [UIImage imageNamed:_ImageArr[indexPath.row]];
        cell.name.text = _TitleArr[indexPath.row];
    }
  
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screen_width/4, screen_width/4);
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0;
}


//点击cell的响应事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
       //房台管理
        
        
        SeatSetViewController *seat=[[SeatSetViewController alloc]init];
        seat.title=@"房台管理";
        seat.funType=@"Seat";
        seat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:seat animated:YES];
        
    }
    if (indexPath.row == 1) {
        //设备管理
        
        equipmentManegeViewController *EMVC = [[equipmentManegeViewController alloc] init];
        EMVC.title = self.TitleArr[indexPath.row];
        EMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:EMVC animated:YES];
    }
    if (indexPath.row == 2) {
        //POS设置
        POSSetViewController *POSSVC = [[POSSetViewController alloc] init];
        POSSVC.title = _TitleArr[indexPath.row];
        POSSVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:POSSVC animated:YES];
 
    }
    if (indexPath.row == 3) {
        //报表管理
        reportFormsManageViewController *RFVC = [[reportFormsManageViewController alloc] init];
        RFVC.title = self.TitleArr[indexPath.row];
        RFVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:RFVC animated:YES];
    }
    if (indexPath.row==4) {
        ReserveViewController *RFVC = [[ ReserveViewController alloc] init];
        RFVC.title = self.TitleArr[indexPath.row];
        RFVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:RFVC animated:YES];
    }
    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    return  UIEdgeInsetsMake(0,0,70,0);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
