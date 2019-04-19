//
//  ProcurementViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ProcurementViewController.h"
#import "ADClassifyModel.h"
#import "ProductModel.h"
#import "MYSegmentView.h"
#import "MainTouchTableTableView.h"
#import "ProcurChildViewController.h"
#import "BillStateViewController.h"
#import "PeocurSrarchViewController.h"
#import "SegmentView.h"
@interface ProcurementViewController ()<UIScrollViewDelegate, SCNavTabBarDelegate>
{
    UIView *searchView;
    SegmentView     *_navTabBar;
    UIScrollView    *_mainView;
    NSMutableArray  *_titles;
    NSInteger       _currentIndex;
}
@property(nonatomic,strong)NSMutableArray *bigClassifyArray;
@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MYSegmentView * RCSegView;
@property (nonatomic, strong)NSMutableArray *subViewControllers;
@end

@implementation ProcurementViewController
@synthesize mainTableView;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
     _currentIndex = 0;
   
    [self getClassify];
    // Do any additional setup after loading the view from its nib.
}

-(void)addSearchBar{
    //搜索框
    searchView = [[UIView alloc] initWithFrame:CGRectMake(8,71,screen_width-140,42)];
    searchView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 8;
    searchView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchView.layer.borderWidth=1;
    [self.view addSubview:searchView];
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 22, 22)];
    [searchImage setImage:[UIImage imageNamed:@"search"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 42)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    placeHolderLabel.text = @"搜索进货商品";
    placeHolderLabel.textColor = [UIColor grayColor];
    [placeHolderLabel setTextAlignment:NSTextAlignmentCenter];
    [searchView addSubview:placeHolderLabel];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [searchView addGestureRecognizer:tap];
    //加button
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"stock_2"] forState:UIControlStateNormal];
    [button setTitle:@"我的订单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame=CGRectMake(screen_width-120, 71, 100, 42);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(mine) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 119, screen_width,1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView];
    //
    _navTabBar = [[SegmentView alloc] initWithFrame:CGRectMake(0,120, SCREEN_WIDTH , 44)];
    _navTabBar.backgroundColor = [UIColor whiteColor];
    _navTabBar.delegate = self;
    _navTabBar.lineColor = [UIColor lightGrayColor];
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 164, SCREEN_WIDTH, SCREEN_HEIGHT-164)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
    UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(0,163, SCREEN_WIDTH, 1)];
    linev.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];
    [self.view addSubview:linev];
    
    //先加第一个
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT-164);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];


    
}
-(void)mine
{
    BillStateViewController *bill=[[BillStateViewController alloc]init];
    bill.title=@"我的";
    [self.navigationController pushViewController:bill animated:YES];
}
-(void)tapClick
{
    PeocurSrarchViewController *search=[[PeocurSrarchViewController alloc]init];
    search.title=@"搜索商品";
    [self.navigationController pushViewController:search animated:NO];
}

-(NSMutableArray *)bigClassifyArray
{
    if (!_bigClassifyArray) {
        _bigClassifyArray=[NSMutableArray array];
    }
    return _bigClassifyArray;
}

#pragma mark--data
//获得大类
-(void)getClassify
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":MCompany,@"shopid":MShop,@"parentno":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BClassifyInfo" With:dic and:^(id responseObject) {
         [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        self.bigClassifyArray=[ADClassifyModel getDatawithdic:dic1];
        NSLog(@"---%ld",self.bigClassifyArray.count);
        [self getChildData];
       
    } Faile:^(NSError *error) {
        
    }];
}
-(void)getChildData
{
 
    _titles=[NSMutableArray array];
    _subViewControllers=[NSMutableArray array];
    for (NSInteger i=0; i<self.bigClassifyArray.count; i++) {
        ProcurChildViewController *peo=[[ProcurChildViewController alloc]init];
        ADClassifyModel *model=self.bigClassifyArray[i];
        peo.classiNo=model.ClassifyNo;
        peo.titleArray=self.bigClassifyArray;
        peo.flag=i;
        [_titles addObject:model.ClassifyName];
        [_subViewControllers addObject:peo];
        
    }
    [self addSearchBar];
}
//滑动scroview切换视图控制器
#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = _currentIndex;
    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:NotifacStock object:[NSNumber numberWithInteger:_currentIndex] userInfo:nil];
}
//点击按钮切换视图
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
  
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
        
       
    }else{
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    }
    _navTabBar.currentItemIndex = index;
    UIViewController *viewController = (UIViewController *)_subViewControllers[index];
    viewController.view.frame = CGRectMake(index * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
  
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:NotifacStock object:[NSNumber numberWithInteger:index] userInfo:nil];
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
