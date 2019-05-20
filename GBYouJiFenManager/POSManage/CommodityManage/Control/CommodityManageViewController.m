//
//  CommodityManageViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 夏盈萍. All rights reserved.
//

#import "CommodityManageViewController.h"
#import "AddClassifyViewController.h"
#import "AddProductViewController.h"
#import "CommodityBtnViewController.h"
#import "POSCollectionViewCell.h"
#import "ComboViewController.h"
#import "AddSeatViewController.h"
#import "TastManagerViewController.h"
#import "ProcurementViewController.h"
#import "BillStateViewController.h"
@interface CommodityManageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collctinView;


@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;


@end

@implementation CommodityManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=NO;
    _titleArray=@[@"商品管理",@"商品套餐",@"规格设置",@"供货商管理"];
    _imageArray=@[@"22",@"44",@"007",@"77"];
    _collctinView.backgroundColor=[UIColor whiteColor];
    [self.collctinView registerNib:[UINib nibWithNibName:@"POSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POSCollectionViewCell"];
    
}
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
            CommodityBtnViewController *comm=[[CommodityBtnViewController alloc]init];
                comm.title=@"商品管理";
                comm.funType=@"manager";
                [comm setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:comm animated:YES];
        }
            break;
        case 1:
        {
            ComboViewController *combo=[[ComboViewController alloc]init];
            combo.title=@"套餐管理";
            [combo setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:combo animated:YES];
        }
            break;
 
        case 2:
        {
     
            TastManagerViewController *combo=[[TastManagerViewController alloc]init];
            combo.title=@"口味管理";
            [combo setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:combo animated:YES];
            
        }
          
                break;
        case 3:
        {
       
            //商家进货
            BillStateViewController *bill=[[BillStateViewController alloc]init];
            bill.title=@"我的";
            bill.stock=YES;
            [bill setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:bill animated:YES];
            
        }
            break;
        default:
            break;
    }
    
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
   
        return CGSizeMake(screen_width/4, screen_width/4);
    
}
//设置section的上左下右边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    //上  左   下  右
//    return  UIEdgeInsetsMake(0,0,20,0);
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
