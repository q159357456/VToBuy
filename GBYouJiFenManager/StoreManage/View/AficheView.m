//
//  AficheView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AficheView.h"
#import "AficheCollectionViewCell.h"
#import "AfivchModel.h"
#import "KTPageControl.h"
@interface AficheView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *supView;
}
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)KTPageControl *pageControl;


@end
@implementation AficheView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
       
        [self creatUI];
     
        
    }
    return self;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=dataArray;
    if (_dataArray.count) {
        [self creatPage];
    }
}
-(void)creatUI
{
    //
    supView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width*4/5, screen_height/2+50)];
    supView.center=self.center;
    supView.backgroundColor=[UIColor whiteColor];
    supView.layer.cornerRadius=8;
    supView.layer.masksToBounds=YES;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [supView.layer addAnimation:animation forKey:nil];
    [self addSubview:supView];
    
    //加imageview
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, -5,supView.width,supView.height/3)];
   
    imageview.image=[UIImage imageNamed:@"gonggao_3"];
     [supView addSubview:imageview];
    //加buttonx
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(supView.width-30, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"uppic_1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [supView addSubview:button];
    
    //加collectionview
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
   
    //设置水平最小间隙
    layout.minimumInteritemSpacing = 0;
    //设置垂直方向的最小间隙
    layout.minimumLineSpacing = 0;
     _collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0,imageview.height,supView.width,supView.height-imageview.height-50) collectionViewLayout:layout];
     layout.itemSize=CGSizeMake(supView.width, _collectionview.height);
    [_collectionview registerNib:[UINib nibWithNibName:@"AficheCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AficheCollectionViewCell"];
    _collectionview.backgroundColor = [UIColor whiteColor];
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    _collectionview.scrollsToTop = NO;
    _collectionview.showsVerticalScrollIndicator = NO;
    _collectionview.showsHorizontalScrollIndicator = NO;
    _collectionview.pagingEnabled=YES;
    [_collectionview reloadData];
    
    [supView addSubview:_collectionview];
    
}
-(void)creatPage
{
  
    //加pagecontroller

    if (_pageControl == nil) {
        
        _pageControl = [[KTPageControl alloc] init];
           _pageControl = [[KTPageControl alloc] initWithFrame:CGRectMake(0, _collectionview.y+_collectionview.height,supView.width,50)];
        
        
        
        //有图片显示图片、没图片则显示设置颜色

        _pageControl.currentImage =[UIImage imageNamed:@"page_2"];
        _pageControl.defaultImage=[UIImage imageNamed:@"page_1"];
        //        _pageControl.defaultImage =[UIImage imageNamed:@"detail_piclunbounselec_suiji"];
        
       
        _pageControl.pageSize = CGSizeMake(12, 12);
        _pageControl.numberOfPages = _dataArray.count;
        _pageControl.currentPage = 0;
            [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
            [supView addSubview:_pageControl];
        [supView addSubview:_pageControl];
        
        
    }


}
-(void)pageChanged:(UIPageControl *)pc
{
    NSInteger page=pc.currentPage;
    [_collectionview scrollRectToVisible:CGRectMake(_collectionview.width*page,_collectionview.x,_collectionview.width, _collectionview.height) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    _pageControl.currentPage = page;
//    NSLog(@"%@",NSStringFromUIEdgeInsets(scrollView.contentInset));
}
-(void)close
{

    [self removeFromSuperview];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AfivchModel *model=_dataArray[indexPath.row];
    AficheCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"AficheCollectionViewCell" forIndexPath:indexPath];
    cell.titleLable.text=model.Title;
    cell.contentLable.text=model.Msg;
    
    return cell;
  
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
}

//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    
    return UIEdgeInsetsMake(0, 0,0, 0);
    
}
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


@end
