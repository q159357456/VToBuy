//
//  AddComboViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddComboViewController.h"
#import "ChildProViewController.h"
#import "ChildQunViewController.h"
#import "ChildDetailViewController.h"
@interface AddComboViewController ()
@property (nonatomic, strong) ChildProViewController *firstVC;
@property (nonatomic, strong) ChildQunViewController *secondVC;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UIView *headScrollView;
@property (nonatomic, strong) UIView *contentView;
@property(nonatomic,assign)NSInteger seleIndex;


@end

@implementation AddComboViewController
-(void)loadView
{
    [super loadView];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
      [self initialization];
     [self loadBaseUI];
   

    // Do any additional setup after loading the view from its nib.
}
- (void)initialization{
    _itemArray = [NSMutableArray arrayWithObjects:@"套餐基本信息",@"套餐内容", nil];
}
- (void)loadBaseUI{
    self.title = @"创建套餐";
    _headScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,50)];
    _headScrollView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
   
    [self.view addSubview:_headScrollView];
    for (int i = 0; i<_itemArray.count; i++) {
      
        UIButton *itemButton =[UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame=CGRectMake(screen_width*i/_itemArray.count+0.5 ,0, screen_width/_itemArray.count-1, 49);
        itemButton.tag = 100+i;
        [itemButton setTitle:_itemArray[i] forState:UIControlStateNormal];
        if (itemButton.tag==100) {
            itemButton.selected=YES;
            self.seleIndex=100;
        }
        itemButton.backgroundColor=[UIColor whiteColor];
        [itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [itemButton setTitleColor:MainColor forState:UIControlStateSelected];
        itemButton.titleLabel.font=[UIFont monospacedDigitSystemFontOfSize:20 weight:14];

        [_headScrollView addSubview:itemButton];

        [itemButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
      
      
    }

//    [_headScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44)];
//    _headScrollView.showsHorizontalScrollIndicator = NO;
//    _headScrollView.showsVerticalScrollIndicator = NO;
  
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50-64)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    [self addSubControllers];
}
- (void)addSubControllers{
    _firstVC = [[ChildProViewController alloc]init];
    _firstVC.model=self.model;
    [self addChildViewController:_firstVC];
    
    _secondVC = [[ChildQunViewController alloc]init];
    _secondVC.model=self.model;
    [self addChildViewController:_secondVC];
    


    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:_firstVC];
    //设置默认显示在容器View的内容
    [self.contentView addSubview:_firstVC.view];
    
//    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
//    NSLog(@"%@",NSStringFromCGRect(_firstVC.view.frame));
    
    _currentVC = _firstVC;
}
- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}
- (void)buttonClick:(UIButton *)sender{

    if ((sender.tag == 100 && _currentVC == _firstVC) || (sender.tag == 101 && _currentVC == _secondVC)) {
        return;
    }
    switch (sender.tag) {
        case 100:{
            sender.selected=YES;
            UIButton *butt=(UIButton*)[self.headScrollView viewWithTag:self.seleIndex];
            butt.selected=NO;
            self.seleIndex=sender.tag;
            [self fitFrameForChildViewController:_firstVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_firstVC];
        }
            break;
        case 101:{
            sender.selected=YES;
            UIButton *butt=(UIButton*)[self.headScrollView viewWithTag:self.seleIndex];
            butt.selected=NO;
            self.seleIndex=sender.tag;
            [self fitFrameForChildViewController:_secondVC];
            [self transitionFromOldViewController:_currentVC toNewViewController:_secondVC];
        }
            break;
            
    }
}
//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}
//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
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
