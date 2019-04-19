//
//  BusinessAreaViewController.m
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/4/17.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import "BusinessAreaViewController.h"
#import "CircleModel.h"
@interface BusinessAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSuorce;
@end

@implementation BusinessAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择商圈";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *condition = [NSString stringWithFormat:@"boroCode$=$%@",self.boroCode];
    DefineWeakSelf;
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:GetCommSelectDataInfo3 With:TableQuery_Ordinary(@"cms_circle", @"*", condition, @"") and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
        weakSelf.dataSuorce = [CircleModel transformToModelList:ResponseTable(dic1)];
        [weakSelf.tableView reloadData];
    } Faile:^(NSError *error) {
        
    }];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 47;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSuorce.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    CircleModel *model = self.dataSuorce[indexPath.row];
    cell.textLabel.text = model.circleName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CircleModel *model = self.dataSuorce[indexPath.row];
    if (self.callBack) {
        self.callBack(model.circleName, model.circleName);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
