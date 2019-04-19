//
//  MyDiscountChoseView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/11.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MyDiscountChoseView.h"
@interface MyDiscountChoseView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIPickerView * pickerView;//自定义pickerview
@property (nonatomic,strong)NSArray * letter;//保存要展示的数字
@property (nonatomic,strong)NSArray * number;//保存要展示的数字
@property(nonatomic,copy)NSString *str1;
@property(nonatomic,copy)NSString *str2;

@end
@implementation MyDiscountChoseView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        // 初始化pickerView
        self.backgroundColor=[UIColor whiteColor];
        self.alpha=1;
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(20, 30,self.width-40, self.height-60)];
        [self addSubview:self.pickerView];
        //lable
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.width, 20)];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.text=@"选择折扣(左边个位右边小数点后一位)";
        lable.textColor=[UIColor lightGrayColor];
        [self addSubview:lable];
        //初始化button
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20, self.height-50, self.width-40, 40);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.backgroundColor=MainColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //指定数据源和委托
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
      
        
        //获取需要展示的数据
        [self loadData];
    }
    return self;
}
-(void)buttClick
{
    NSString *str=[NSString stringWithFormat:@"%@.%@",_str1,_str2];

    self.buttBlock(str);
}
#pragma mark 加载数据
-(void)loadData
{
    //需要展示的数据以数组的形式保存
    self.letter = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    self.number = @[@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"0"];
    [self.pickerView selectRow:4 inComponent:0 animated:YES];
    [self.pickerView selectRow:4 inComponent:1 animated:NO];
    _str1=self.letter[4];
    _str2=self.number[4];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.letter.count;
            break;
        case 1:
            result = self.number.count;
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.letter[row];
            break;
        case 1:
            title = self.number[row];
            break;
        default:
            break;
    }
    
    return title;
}
#pragma mark 给pickerview设置字体大小和颜色等
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor lightGrayColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    return pickerLabel;
}
//选中某行后回调的方法，获得选中结果
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component ==0)
    {
//        self.pickerViewSelect = self.pickerViewArr[row];
        _str1=self.letter[row];
   
    }
    else
    {
         _str2 = self.number[row];
//        self.pickerViewSelect2 = self.pickerViewArr2[row];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
