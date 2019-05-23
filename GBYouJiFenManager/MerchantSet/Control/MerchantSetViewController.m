//
//  MerchantSetViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 夏盈萍. All rights reserved.
//

#import "MerchantSetViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "POSCollectionViewCell.h"
#import "ClipManagerViewController.h"
#import "FullcutViewController.h"
#import "OverflowViewController.h"
#import "discountViewController.h"
#import "HouseDataViewController.h"
#import "ZWHCardMangerViewController.h"
@interface MerchantSetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation MerchantSetViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController .navigationBar .translucent=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
//    _titleArray=@[@"优惠券",@"满就减",@"超值商品",@"砍价购",@"储值卡"];
//    _imageArray=@[@"MerchantSet_2",@"MerchantSet_3",@"33",@"MerchantSet_4",@"016"];
    _titleArray=@[@"优惠券",@"满就减"];
    _imageArray=@[@"MerchantSet_2",@"MerchantSet_3"];
        [self.collectionview registerNib:[UINib nibWithNibName:@"POSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POSCollectionViewCell"];
    _collectionview.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
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
    if (indexPath.row<_titleArray.count) {
        cell.name.text=_titleArray[indexPath.row];
        cell.img.image=[UIImage imageNamed:_imageArray[indexPath.row]];
    }
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //卡券管理
//            ClipManagerViewController *comm=[[ClipManagerViewController alloc]init];
//            comm.title=@"卡券管理";
//            [comm setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:comm animated:YES];
            ZWHCardMangerViewController *comm=[[ZWHCardMangerViewController alloc]init];
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
        }
            
            break;
        case 1:
        {
            //满减管理
            FullcutViewController *comm=[[FullcutViewController alloc]init];
            comm.title=@"满减管理";
//            comm.funType=@"manager";
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
        }
            break;
        case 2:
        {
            //超值商品
            OverflowViewController *combo=[[OverflowViewController alloc]init];
            combo.title=@"超值商品管理";
            [combo setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:combo animated:YES];
            
            
        }
            break;
        case 3:
        {
            //砍价管理
            ClipManagerViewController *comm=[[ClipManagerViewController alloc]init];
            comm.title=@"砍价管理";
            comm.funType=@"KanJia";
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
        }
            break;
        case 4:
        {
            //充值规则
            HouseDataViewController *comm=[[HouseDataViewController alloc]init];
            comm.title=@"充值规则";
            comm.tagNum = 115;
            [comm setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:comm animated:YES];
            
            
        }
            break;
        case 5:
        {
       
 
            
            
        }
            break;

      
            
        default:
            break;
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   return CGSizeMake(screen_width/4, screen_width/4);
    
}
////设置section的上左下右边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    //上  左   下  右
//
//}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0;
}


@end
