//
//  equipmentManegeViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/14.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "equipmentManegeViewController.h"
#import "POSCollectionViewCell.h"
#import "MobileViewController.h"
#import "HouseDataViewController.h"
@interface equipmentManegeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation equipmentManegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}

-(void)initCollectionView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleArray=@[@"电脑设备绑定",@"平板设备绑定",@"电子秤设置",@"后厨打印机"];
    _imageArray=@[@"002",@"001",@"023",@"015"];
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
            //电脑设备绑定
            MobileViewController *mvc = [[MobileViewController alloc] init];
            mvc.title = self.titleArray[indexPath.row];
            mvc.tagNum = 101;
            
            [self.navigationController pushViewController:mvc animated:YES];
        }
            
            break;
        case 1:
        {
            //平板设备绑定
            HouseDataViewController *hvc = [[HouseDataViewController alloc] init];
            hvc.title = self.titleArray[indexPath.row];
            hvc.tagNum = 100;
            [self.navigationController pushViewController:hvc animated:YES];
        }
            break;
        case 2:
        {
            //电子秤设置
            MobileViewController *mvc = [[MobileViewController alloc] init];
            mvc.title = self.titleArray[indexPath.row];
            mvc.tagNum = 113;
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }
            break;
        case 3:
        {
            //后厨打印机
            HouseDataViewController *mvc = [[HouseDataViewController alloc] init];
            mvc.title = self.titleArray[indexPath.row];
            mvc.tagNum = 114;
            
            [self.navigationController pushViewController:mvc animated:YES];
            
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
    
}



@end
