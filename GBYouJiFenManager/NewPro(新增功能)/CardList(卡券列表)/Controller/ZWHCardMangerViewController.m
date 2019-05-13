//
//  ZWHCardMangerViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHCardMangerViewController.h"
#import <SGPagingView.h>
#import <SGPageContentScrollView.h>
#import "ZWHCardListViewController.h"
#import "ZWHCardModel.h"
#import "AddClipViewController.h"
#import "ZWHAddCardViewController.h"

@interface ZWHCardMangerViewController ()<SGPageTitleViewDelegate,SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property(nonatomic,strong)NSArray *classArr;

@property(nonatomic,strong)NSArray *VCArr;
@property(nonatomic,assign)NSInteger seleindex;


@end

@implementation ZWHCardMangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡券管理";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTitle) name:@"refreshCard" object:nil];
    
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"01" forKey:@"mode"];
    [dict setValue:model.SHOPID forKey:@"shopid"];
    [dict setValue:@(1) forKey:@"pageindex"];
    [dict setValue:@(10) forKey:@"pagesize"];
    [dict setValue:CIPHERTEXT forKey:@"CipherText"];
    NSLog(@"dict====>%@",dict);
    MJWeakSelf;
    [self showEmptyViewWithLoading];
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"/PosService.asmx/ShopCouponList" With:dict and:^(id responseObject) {
        NSDictionary *resdict=[JsonTools getData:responseObject];
        NSLog(@"resdict===>%@",resdict);
        [self hideEmptyView];
        if ([resdict[@"message"] isEqualToString:@"OK"]) {
            NSArray *ary = resdict[@"DataSet"][@"Table"];
            [ZWHCardModel mj_objectClassInArray];
            ZWHCardModel *model = [ZWHCardModel mj_objectWithKeyValues:ary[0]];
            weakSelf.classArr = @[[NSString stringWithFormat:@"普通券(%@)",model.num1.length>0?model.num1:@"0"],[NSString stringWithFormat:@"VIP券(%@)",model.num2.length>0?model.num2:@"0"],[NSString stringWithFormat:@"已结束(%@)",model.num3.length>0?model.num3:@"0"]];
            [weakSelf setUI];
            //[weakSelf.pageTitleView resetTitle:@"abc" forIndex:0];
        }else{
            [QMUITips showError:@"获取失败"];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 * 刷新标题
 */
-(void)refreshTitle{
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"01" forKey:@"mode"];
    [dict setValue:model.SHOPID forKey:@"shopid"];
    [dict setValue:@(1) forKey:@"pageindex"];
    [dict setValue:@(10) forKey:@"pagesize"];
    [dict setValue:CIPHERTEXT forKey:@"CipherText"];
    MJWeakSelf;
    [self showEmptyViewWithLoading];
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"/PosService.asmx/ShopCouponList" With:dict and:^(id responseObject) {
        NSDictionary *resdict=[JsonTools getData:responseObject];
        NSLog(@"%@",resdict);
        [self hideEmptyView];
        if ([resdict[@"message"] isEqualToString:@"OK"]) {
            NSArray *ary = resdict[@"DataSet"][@"Table"];
            [ZWHCardModel mj_objectClassInArray];
            ZWHCardModel *model = [ZWHCardModel mj_objectWithKeyValues:ary[0]];
            weakSelf.classArr = @[[NSString stringWithFormat:@"普通券(%@)",model.num1.length>0?model.num1:@"0"],[NSString stringWithFormat:@"VIP券(%@)",model.num2.length>0?model.num2:@"0"],[NSString stringWithFormat:@"已结束(%@)",model.num3.length>0?model.num3:@"0"]];
            for (NSInteger i=0; i<weakSelf.classArr.count; i++) {
                [weakSelf.pageTitleView resetTitle:weakSelf.classArr[i] forIndex:i];
            }
        }else{
            [QMUITips showError:@"获取失败"];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
    }];
}





-(void)setUI{
    ZWHCardListViewController *vc1 = [[ZWHCardListViewController alloc]init];
    vc1.mode = @"01";
    
    ZWHCardListViewController *vc2 = [[ZWHCardListViewController alloc]init];
    vc2.mode = @"02";
    
    ZWHCardListViewController *vc3 = [[ZWHCardListViewController alloc]init];
    vc3.mode = @"03";
    _VCArr = @[vc1,vc2,vc3];
    [self setupPageView];
    
    QMUIButton *btn1 = [[QMUIButton alloc]qmui_initWithImage:nil title:@"添加优惠券"];
    [btn1 setTitleColor:[UIColor blackColor] forState:0];
    btn1.titleLabel.font = ZWHFont(14);
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(HEIGHT_PRO(50));
    }];
    
    QMUIButton *btn2 = [[QMUIButton alloc]qmui_initWithImage:nil title:@"添加股东券券"];
    [btn2 setTitleColor:[UIColor blackColor] forState:0];
    btn2.titleLabel.font = ZWHFont(14);
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(btn1.mas_right);
        make.height.mas_equalTo(HEIGHT_PRO(50));
    }];
    btn2.qmui_borderColor = LINECOLOR;
    btn2.qmui_borderWidth = 1;
    btn2.qmui_borderPosition = QMUIViewBorderPositionLeft;
    
    [btn1 addTarget:self action:@selector(addNormalCard) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(addShareCard) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 添加优惠券
-(void)addNormalCard{
    AddClipViewController*comm=[[AddClipViewController alloc]init];
    comm.title=@"新增卡券";
    comm.backBlock=^{
        //[weakSelf getAllData];
    };
    
    [self.navigationController pushViewController:comm animated:YES];
}


#pragma mark - 添加股东券
-(void)addShareCard{
    ZWHAddCardViewController *vc = [[ZWHAddCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - 分页控制器
- (void)setupPageView {
    
    
    
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.titleGradientEffect = YES;
    configure.titleSelectedColor = navigationBarColor;
   // configure.indicatorColor = defaultColor2;
    configure.showIndicator = NO;
    configure.bottomSeparatorColor = [UIColor qmui_colorWithHexString:@"f3f3f3"];
    configure.showVerticalSeparator = YES;
    configure.verticalSeparatorColor = [UIColor qmui_colorWithHexString:@"f3f3f3"];
    configure.verticalSeparatorReduceHeight = 20.0f;
    
    /// pageTitleView
    NSLog(@"%f",ZWHNavHeight);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, (ZWHNavHeight), self.view.frame.size.width, 44) delegate:self titleNames:_classArr configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, (ZWHNavHeight)+44, self.view.frame.size.width, SCREEN_HEIGHT-(ZWHNavHeight)-44-HEIGHT_PRO(50)) parentVC:self childVCs:_VCArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:self.pageContentScrollView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    _seleindex = selectedIndex;
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    _seleindex = targetIndex;
}





@end
