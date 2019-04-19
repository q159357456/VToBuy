//
//  CloseReportDetailViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/22.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "CloseReportDetailViewController.h"
#import "CommidityBigClassViewController.h"
@interface CloseReportDetailViewController ()<UITextViewDelegate>

@end

@implementation CloseReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initReportScrollView];
    [self initFootView];
}

-(void)initReportScrollView
{
    _ReportScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-50)];
    _ReportScrollView.contentSize = CGSizeMake(screen_width, 1320);
    _ReportScrollView.bounces = NO;
    
    for (int i = 0; i<33; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1), screen_width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_ReportScrollView addSubview:line];
    }
    
    for (int j = 0; j<33; j++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, 5*(j+1)+35*j, 1, 30)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_ReportScrollView addSubview:line];
    }
    
    for (int z = 0; z<33; z++) {
        NSArray *listArray = @[@"交班单别",@"交班单号",@"营业日期",@"班别编号",@"操作机号",@"交班时间",@"单据数量",@"房台附加金额",@"结业者",@"备注",@"营业日期序号",@"交班序号",@"本币金额",@"人数",@"招待金额",@"会员赠金消费",@"会员本金消费",@"会员消费单数",@"会员本金充值",@"净营收",@"营业收入",@"非营业收入",@"其他方式付款金额",@"其他付款方式单据数",@"会员赠金充值",@"结业状态",@"押金进出数量统计",@"押金",@"保龄局数",@"迷保局数",@"卡务收入",@"折扣金额",@"区域"];
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0,2*(z+1)+38*z, 100, 36)];
        textV.font = [UIFont systemFontOfSize:13];
        textV.textAlignment = NSTextAlignmentCenter;
        textV.text = listArray[z];
        textV.delegate = self;
        [_ReportScrollView addSubview:textV];
    }
    
    NSString *areaStr;
    for (FloorModel *model in self.CArr) {
        if ([model.itemNo isEqualToString:self.cModel.area]) {
            areaStr = model.FloorInfo;
        }
    }
    
    for (int x = 0; x<33; x++) {
        NSArray *contentArray = @[self.cModel.PI001,self.cModel.PI002,self.cModel.operateTime,self.cModel.classesTimes,self.cModel.operateMachine,self.cModel.PI006,self.cModel.FormsNumber,self.cModel.PI008,self.cModel.PI009,self.cModel.PI010,self.cModel.PI011,self.cModel.PI012,self.cModel.PI013,self.cModel.PI014,self.cModel.PI015,self.cModel.PI016,self.cModel.PI017,self.cModel.PI018,self.cModel.PI019,self.cModel.PI020,self.cModel.PI021,self.cModel.PI022,self.cModel.PI023,self.cModel.PI024,self.cModel.PI025,self.cModel.status,self.cModel.UDF03,self.cModel.UDF07,self.cModel.UDF08,self.cModel.UDF09,self.cModel.UDF10,self.cModel.UDF11,areaStr];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(110,2*(x+1)+38*x, screen_width-120, 36)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:13];
        lab.tag = 800+x;
        lab.text = contentArray[x];
        [_ReportScrollView addSubview:lab];
    }
    
    [self.view addSubview:_ReportScrollView];
}

-(void)initFootView
{
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-50, screen_width, 50)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_footView addSubview:line];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(screen_width/2, 3, 1, 44)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_footView addSubview:line1];
    
    for (int i = 0; i<2; i++) {
        NSArray *title = @[@"商品大类",@"付款大类明细"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(screen_width/2), 0, screen_width/2, 50)];
        [btn setTitle:title[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 700 +i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
    }
    [self.view addSubview:_footView];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

-(void)btnClick:(UIButton *)button
{
    NSLog(@"按钮被点击。。");
    if (button.tag == 700) {
        NSLog(@"商品大类按钮被点击...");
        CommidityBigClassViewController *CBCVC = [[CommidityBigClassViewController alloc] init];
        CBCVC.title = @"商品大类";
        CBCVC.str1 = _cModel.PI001;
        CBCVC.str2 = _cModel.PI002;
        CBCVC.tagNumber = 850;
        [self.navigationController pushViewController:CBCVC animated:YES];
    }else
    {
        NSLog(@"付款大类明细被点击...");
        CommidityBigClassViewController *CBCVC = [[CommidityBigClassViewController alloc] init];
        CBCVC.title = @"付款大类明细";
        CBCVC.str1 = _cModel.PI001;
        CBCVC.str2 = _cModel.PI002;
        CBCVC.tagNumber = 852;
        [self.navigationController pushViewController:CBCVC animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
