//
//  ZWHSystemViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/10/10.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHSystemViewController.h"
#import "AfivchModel.h"
#import "ZWHTicketWebViewController.h"

@interface ZWHSystemViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTableview;

@end

@implementation ZWHSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    [self creatView];
}

-(void)creatView{
    _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _listTableview.delegate = self;
    _listTableview.dataSource = self;
    [_listTableview registerClass:[QMUITableViewCell class] forCellReuseIdentifier:@"QMUITableViewCell"];
    [self.view addSubview:_listTableview];
    [_listTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ZWHNavHeight);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - <uitableviewdelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMUITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    AfivchModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.Title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHTicketWebViewController *vc = [[ZWHTicketWebViewController alloc]init];
    AfivchModel *model = _dataArray[indexPath.row];
    vc.remark = model.Msg;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
