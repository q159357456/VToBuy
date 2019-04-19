//
//  DateFormsDetailViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/22.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "DateFormsDetailViewController.h"
#import "CommidityBigClassViewController.h"
@interface DateFormsDetailViewController ()<UITextViewDelegate>

@end

@implementation DateFormsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initReportScrollView];
    [self initFootView];
}


-(void)initReportScrollView
{
    _ReportScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-50)];
    _ReportScrollView.contentSize = CGSizeMake(screen_width, 1200);
    _ReportScrollView.bounces = NO;
    
    for (int i = 0; i<30; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1), screen_width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_ReportScrollView addSubview:line];
    }
    
    for (int j = 0; j<30; j++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, 5*(j+1)+35*j, 1, 30)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_ReportScrollView addSubview:line];
    }
    
    for (int z = 0; z<30; z++) {
        NSArray *listArray = @[@"交班单别",@"交班单号",@"营业日期",@"结业时间",@"操作机号",@"单据数量",@"房台附加金额",@"结业者",@"备注",@"营业日期序号",@"本币金额",@"人数",@"招待金额",@"会员赠金消费",@"会员本金消费",@"会员消费单数",@"会员本金充值",@"净营收",@"营业收入",@"非营业收入",@"其他方式付款金额",@"其他付款方式单据数",@"会员赠金充值",@"结业状态",@"押金进出数量统计",@"押金",@"保龄局数",@"迷保局数",@"卡务收入",@"折扣金额"];
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0,2*(z+1)+38*z, 100, 36)];
        textV.font = [UIFont systemFontOfSize:13];
        textV.textAlignment = NSTextAlignmentCenter;
        textV.text = listArray[z];
        textV.delegate = self;
        [_ReportScrollView addSubview:textV];
    }
    
    for (int x = 0; x<30; x++) {
        NSArray *contentArray = @[self.dModel.PI001,self.dModel.PI002,self.dModel.operateTime,self.dModel.classesTimes,self.dModel.operateMachine,self.dModel.FormsNumber,self.dModel.PI007,self.dModel.PI008,self.dModel.PI009,self.dModel.PI010,self.dModel.PI011,self.dModel.PI012,self.dModel.PI013,self.dModel.PI014,self.dModel.PI015,self.dModel.PI016,self.dModel.PI017,self.dModel.PI018,self.dModel.PI019,self.dModel.PI020,self.dModel.PI021,self.dModel.PI022,self.dModel.PI023,self.dModel.status,self.dModel.UDF03,self.dModel.UDF07,self.dModel.UDF08,self.dModel.UDF09,self.dModel.UDF10,self.dModel.UDF11];
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
        btn.tag = 705 +i;
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
    if (button.tag ==705 ) {
        CommidityBigClassViewController *CBCVC = [[CommidityBigClassViewController alloc] init];
        CBCVC.title = @"商品大类";
        CBCVC.str1 = _dModel.PI001;
        CBCVC.str2 = _dModel.PI002;
        CBCVC.tagNumber = 851;
        [self.navigationController pushViewController:CBCVC animated:YES];
    }
    else {
        
        NSLog(@"付款明细按钮被点击...");
        CommidityBigClassViewController *CBCVC = [[CommidityBigClassViewController alloc] init];
        CBCVC.title = @"付款大类明细";
        CBCVC.str1 = _dModel.PI001;
        CBCVC.str2 = _dModel.PI002;
        CBCVC.tagNumber = 853;
        [self.navigationController pushViewController:CBCVC animated:YES];
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
