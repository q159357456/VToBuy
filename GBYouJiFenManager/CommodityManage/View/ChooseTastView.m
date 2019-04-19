//
//  ChooseTastView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/1.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ChooseTastView.h"
#import "TagsFrame.h"
#import "TaskFrameTableViewCell.h"
@interface ChooseTastView()<UITableViewDelegate,UITableViewDataSource>
{
    float _h;
}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *tagsArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *tasteArray;
@property(nonatomic,copy)NSString *price;


@end
@implementation ChooseTastView

-(instancetype)initWithFrame:(CGRect)frame Model:(INV_ProductModel*)model
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.alpha = 1;
        _price=model.RetailPrice;
      
        [self getTagsArrayWithModel:model];
    
        
        
    }
    return self;
    
}
-(void)getTagsArrayWithModel:(INV_ProductModel*)model;
{
    _tagsArray=[NSMutableArray array];
    for (NSDictionary *dic in model.POSDC)
    {
        POSDCModel *model=[[POSDCModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        model.posdiArray=[NSMutableArray array];
        if (model.POSDI) {
           
            for (NSDictionary *dic1 in dic[@"POSDI"])
            {
                POSDIModel *dmodel=[[POSDIModel alloc]init];
                dmodel.DI001=dic1[@"DI001"];
                dmodel.DI002=dic1[@"DI002"];
                dmodel.DI003=dic1[@"DI003"];
                dmodel.DI004=dic1[@"DI004"];
                dmodel.DI005=dic1[@"DI005"];
                dmodel.DI006=dic1[@"DI006"];
                dmodel.DI007=dic1[@"DI007"];
                dmodel.DI008=dic1[@"DI008"];
                dmodel.DI009=dic1[@"DI009"];
                dmodel.DI010=dic1[@"DI010"];
                dmodel.DI011=dic1[@"DI011"];
                dmodel.DI012=dic1[@"DI012"];
                [model.posdiArray addObject:dmodel];
            }
            [_tagsArray addObject:model];

        }
        
    }
    _dataArray=[NSMutableArray array];
    [_tagsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TagsFrame *frame = [[TagsFrame alloc] init];
        
        POSDCModel *model=(POSDCModel*)obj;
        frame.tagsMinPadding=20;
        frame.width=screen_width*0.8 ;
        frame.startX=80;
        frame.startY=40;
        frame.tagsMargin=10;
        frame.tagsArray =model.posdiArray;
        [_dataArray addObject:frame];
        
    }];

    _h=0;
    for (NSInteger i=0; i<_dataArray.count; i++) {
        _h= _h+[_dataArray[i] tagsHeight]+40;
    }
    [self getTableview];
}
-(void)getTableview
{
    
    self.table=[[UITableView alloc]init];
    //    self.table.center=self.center;
    [self addSubview:_table];
    __weak typeof (self) weakSelf = self;
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        //固定中心点
        make.center.equalTo(weakSelf);
        //固定的size
        
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.8);
        
        make.height.mas_equalTo(_h+100);
    }];
    //获得tableview的frame
    
    
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.layer.cornerRadius=10;
    self.table.layer.masksToBounds=YES;
    
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.table.layer addAnimation:animation forKey:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TagsFrame *frame=_dataArray[indexPath.row];
    POSDCModel *model=_tagsArray[indexPath.row];
    TaskFrameTableViewCell *cell = [TaskFrameTableViewCell cellWithTableView:tableView];
    cell.tagsFrame=frame;
    [cell setTastStr:model.DC002];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagsFrame *frame=_dataArray[indexPath.row];
    return [frame tagsHeight]+40;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable=[[UILabel alloc]init];
    lable.font=[UIFont boldSystemFontOfSize:17];
    lable.textColor=MainColor;
    lable.textAlignment=NSTextAlignmentCenter;
    lable.backgroundColor=[UIColor groupTableViewBackgroundColor];
  
    lable.text=[NSString stringWithFormat:@"¥%@",_price];

    return lable;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"加入购物车" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:21];
    button.backgroundColor=MainColor;
    [button addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)addClick:(UIButton*)butt
{
    //遍历cell获得数据

    _tasteArray=[NSMutableArray array];
    for (TaskFrameTableViewCell *cell in self.table.visibleCells)
    {
        for (POSDIModel *model in cell.dataArray) {
            [_tasteArray addObject:model];
        }
    }
 
    self.addShopCarBlock(_tasteArray);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
