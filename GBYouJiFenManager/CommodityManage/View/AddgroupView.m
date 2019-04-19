//
//  AddgroupView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddgroupView.h"
#import "AddDetailTableViewCell.h"
#import "FMDBGroup.h"
@implementation AddgroupView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _titleArray=@[@"组合名称",@"可选数量",@"组合备注"];
       
        [self addKeyBoardNotify];
        [self creatUI];
    }
    return self;
}
-(void)addKeyBoardNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark--键盘事件
//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
  
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    offset = self.table.frame.origin.y+self.table.frame.size.height - (self.frame.size.height - kbHeight);
    
    
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(self.frame.origin.x, -offset, self.frame.size.width, self.frame.size.height);
        }];
    }
}
///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {

    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, self.frame.size.height);
    }];
}
-(void)creatUI
{
    _table = [[UITableView alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
    _table.userInteractionEnabled=YES;
    [self addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-50);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(220);
        
    }];
    _table.layer.borderWidth=1;
    _table.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _table.layer.cornerRadius=8;
    _table.scrollEnabled=NO;
    //缩放动画
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_table.layer addAnimation:animation forKey:nil];
    
    
}
#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
    AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
    }
    
    cell.inputText.tag=indexPath.row+1;
    if (indexPath.row==0)
    {
        cell.inputText.placeholder=@"例如饮品主食";
        [cell.inputText becomeFirstResponder];
    }else if (indexPath.row==2)
    {
        cell.inputText.placeholder=@"组合备注";
        
    }else
    {
        
        cell.inputText.placeholder=@"最多可选数量";
        cell.inputText.keyboardType=UIKeyboardTypeNumberPad;
    }
    
    cell.nameLable.text=_titleArray[indexPath.row];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"uppic_1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
     [button mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(view.mas_right);
         make.height.mas_equalTo(view.mas_height);
         make.width.mas_equalTo(view.mas_height);
         make.top.mas_equalTo(view.mas_top);
     }];
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.backgroundColor=MainColor;
    [button addTarget:self action:@selector(buttClick) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
    
}
-(void)buttClick
{
     UITextField *text1=(UITextField*)[self.table viewWithTag:1];
     UITextField *text2=(UITextField*)[self.table viewWithTag:2];
     UITextField *text3=(UITextField*)[self.table viewWithTag:3];

 
    if (text1.text.length==0||text2.text.length==0)
    {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"名称和基数不能为空"];
    }else
    {
        GroupModel *model=[[GroupModel alloc]init];
        //    NSLog(@"%ld", [[FMDBGroup shareInstance]getGroupData].count);
        model.GP_Name=text1.text;
        model.BasicQuantity=text2.text;
        model.beiZhu=text3.text;
//        model.GP_No=[NSString stringWithFormat:@"%ld",[[FMDBGroup shareInstance]getGroupData].count+1];
        self.backBlock(model);
        [self closeClick];
    }
//
   
  
  
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  
}
-(void)closeClick
{

    [self removeFromSuperview];
}
@end
