//
//  BillStateViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BillStateViewController.h"
#import "BillStateSonViewController.h"
#import "MainTouchTableTableView.h"

@interface BillStateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MYSegmentView * RCSegView;


@end

@implementation BillStateViewController
@synthesize mainTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    self.keyTableView = mainTableView;
}
-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,screen_width,screen_height)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
        mainTableView.scrollEnabled=NO;
        
    }
    return mainTableView;
}
#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT-(ZWHNavHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


-(UIView *)setPageViewControllers
{
    if (!_RCSegView)
    {
        
        if (!_stock)
        {
            //买家模式
            BillStateSonViewController *son1=[[BillStateSonViewController  alloc]init];
            son1.fun=1;
            BillStateSonViewController *son2=[[BillStateSonViewController  alloc]init];
            son2.fun=2;
            BillStateSonViewController *son3=[[BillStateSonViewController  alloc]init];
            son3.fun=3;
            BillStateSonViewController *son4=[[BillStateSonViewController  alloc]init];
            son4.fun=4;
            BillStateSonViewController *son5=[[BillStateSonViewController  alloc]init];
            son5.fun=5;
            
            NSArray *controllers=@[son1,son2,son3,son4,son5];
            
            NSArray *titleArray =@[@"待付款",@"待审核",@"待收货",@"已完单",@"已退货"];
            
            MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-(ZWHNavHeight)) controllers:controllers titleArray:titleArray ParentController:self lineWidth:screen_width/6 lineHeight:3.];
            
            _RCSegView = rcs;
            
        }else
        {
            //卖家模式
            BillStateSonViewController *son1=[[BillStateSonViewController  alloc]init];
            son1.fun=2;
            BillStateSonViewController *son2=[[BillStateSonViewController  alloc]init];
            son2.fun=3;
            BillStateSonViewController *son3=[[BillStateSonViewController  alloc]init];
            son3.fun=4;
            BillStateSonViewController *son4=[[BillStateSonViewController  alloc]init];
            son4.fun=5;
     
            
            NSArray *controllers=@[son1,son2,son3,son4];
            
            NSArray *titleArray =@[@"待审核",@"待收货",@"已结单",@"已退单"];
            
            MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64) controllers:controllers titleArray:titleArray ParentController:self lineWidth:screen_width/6 lineHeight:3.];
            
            _RCSegView = rcs;
            
        }
        
    }
    return _RCSegView;
}


@end
