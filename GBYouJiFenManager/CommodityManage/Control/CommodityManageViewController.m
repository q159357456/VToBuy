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
 
    _titleArray=@[@"商品大类维护",@"商品管理",@"商品套餐",@"商家进货",@"口味设置"];
    _imageArray=@[@"11",@"22",@"44",@"77",@"007"];
 _collctinView.backgroundColor=[UIColor groupTableViewBackgroundColor];
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
    cell.name.text=_titleArray[indexPath.row];
    cell.img.image=[UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
               AddClassifyViewController *add=[[AddClassifyViewController alloc]init];
                add.funType=@"mananger";
                add.title=@"商品大类维护";
                [add setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:add animated:YES];
        }

            break;
        case 1:
        {
            CommodityBtnViewController *comm=[[CommodityBtnViewController alloc]init];
                comm.title=@"商品管理";
                comm.funType=@"manager";
                [comm setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:comm animated:YES];
        }
            break;
        case 2:
        {
            ComboViewController *combo=[[ComboViewController alloc]init];
            combo.title=@"套餐管理";
            [combo setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:combo animated:YES];
        }
            break;
 
        case 3:
        {
            //商家进货
          
//            NSString *word=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
//            NSString *userNo=[[NSUserDefaults standardUserDefaults]objectForKey:@"userword"];
//            NSString *urlStr=[NSString stringWithFormat:@"GBYouJiFenManager://%@?%@",userNo,word];
//            NSURL *appBUrl = [NSURL URLWithString:urlStr];
//            // 2.判断手机中是否安装了对应程序
//            if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
//                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"即将前往易捷购" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    dispatch_after(0.2, dispatch_get_main_queue(), ^{
//                        // 3. 打开应用程序App-B
//                        [[UIApplication sharedApplication] openURL:appBUrl];
//                        
//                    });
//                    
//                    
//                }];
//                
//                UIAlertAction* action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                [alert addAction:action];
//                [alert addAction:action1];
//                
//                [self presentViewController:alert animated:YES completion:nil];
//                
//            } else {
//                [self alertShowWithStr:@"还没有安装易捷购"];
//            }
            //判断是商户还是
            NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
            NSLog(@"%@",shopType);
            if ([shopType isEqualToString:@"DS"])
            {
                BillStateViewController *bill=[[BillStateViewController alloc]init];
                bill.title=@"我的";
                bill.stock=YES;
                  [bill setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:bill animated:YES];
            }else
            {
                
                ProcurementViewController *combo=[[ProcurementViewController alloc]init];
                combo.title=@"商家进货";
                [combo setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:combo animated:YES];
                
            }
    
           
            
        }
          
                break;
        case 4:
        {
       
                TastManagerViewController *combo=[[TastManagerViewController alloc]init];
                combo.title=@"口味管理";
                [combo setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:combo animated:YES];
            
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
   
   
        return CGSizeMake((screen_width-2)/3, (screen_width-2)/3);
    
}
////设置section的上左下右边距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    //上  左   下  右
//    return  UIEdgeInsetsMake(0,0,20,0);
//
//}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
