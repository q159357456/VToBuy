//
//  reportFormsManageViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/14.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "reportFormsManageViewController.h"
#import "POSCollectionViewCell.h"
#import "DateFormsViewController.h"
#import "CloseReportViewController.h"
@interface reportFormsManageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation reportFormsManageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
      [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectionView];
}

-(void)initCollectionView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleArray=@[@"交班报表",@"日结报表"];
    _imageArray=@[@"013",@"012"];
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
            //交班报表
            CloseReportViewController *cvc = [[CloseReportViewController alloc] initWithNibName:@"CloseReportViewController" bundle:nil];
            cvc.title = self.titleArray[indexPath.row];
            
            
            [self.navigationController pushViewController:cvc animated:YES];
        }
            
            break;
        case 1:
        {
            //日结报表
            DateFormsViewController *dvc = [[DateFormsViewController alloc] initWithNibName:@"DateFormsViewController" bundle:nil];
            dvc.title = self.titleArray[indexPath.row];
            
            [self.navigationController pushViewController:dvc animated:YES];
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
