//
//  roomSetViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/14.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "roomSetViewController.h"
#import "POSCollectionViewCell.h"
#import "SeatSetViewController.h"
#import "AddSeatViewController.h"
@interface roomSetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation roomSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectionView];
    
}

-(void)initCollectionView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleArray=@[@"创建房台",@"房台管理"];
    _imageArray=@[@"004",@"005"];
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
            //创建房台
          ;
            AddSeatViewController *seat=[[AddSeatViewController alloc]init];
            seat.title=@"创建房台";
            [self.navigationController pushViewController:seat animated:YES];
        }
            
            break;
        case 1:
        {
            //房台管理
            SeatSetViewController *seat=[[SeatSetViewController alloc]init];
            seat.title=@"房台设置";
            seat.funType=@"Seat";
            [self.navigationController pushViewController:seat animated:YES];
            
        
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 1;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
