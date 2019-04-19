//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "ClassifyModel.h"
#import "trreeTableViewCell.h"
@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）


@end

@implementation TreeTableView

-(instancetype)initWithFrame:(CGRect)frame withData : (NSMutableArray *)data{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _data = data;
        
        _tempData = [self createTempData:data];
    }
    return self;
}
-(void)getData:(NSMutableArray *)data
{
    _data=data;
     _tempData = [self createTempData:data];
    [self reloadData];
}
/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSMutableArray*)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        ClassifyModel *model = [_data objectAtIndex:i];
        if (model.expand) {
            [tempArray addObject:model];
        }
    }
    return tempArray;
}
-(void)setDoneButt:(BOOL)doneButt
{
    _doneButt=doneButt;
    
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ClassifyModel_CELL_ID = @"ClassifyModel_cell_id";
    
    trreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassifyModel_CELL_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"trreeTableViewCell" owner:nil options:nil][0];
    }
    
    ClassifyModel *model = [_tempData objectAtIndex:indexPath.row];
    //
    if (model.selected)
    {
        [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"slected_2"]forState:UIControlStateNormal];
        
    }else
    {
        [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"slected_1"] forState:UIControlStateNormal];
    }
    __weak typeof(self)weakSelf=self;
    cell.selectedBlock=^{
        for (ClassifyModel *Mmodel in _tempData) {
            //判断选择
            if (!_doneButt)
            {
                if ([Mmodel.classifyNo isEqualToString:model.classifyNo])
                {
                    Mmodel.selected=!Mmodel.selected;
                }else
                {
                    Mmodel.selected=NO;
                }
            }else
            {
                if ([Mmodel.classifyNo isEqualToString:model.classifyNo])
                {
                    Mmodel.selected=!Mmodel.selected;
                    break;
                }
            }
     
        }
        
        [self reloadData];
             weakSelf.backBlock(model);

    };
    //
    BOOL is=NO;
    for (ClassifyModel *pmodel in _data) {
        if ([pmodel.parentno isEqualToString:model.classifyNo]) {
            is=YES;
            break;
        }
    }
    if (is)
    {
        BOOL isopen=NO;
        for (ClassifyModel *jmodel in _tempData) {
            if ([jmodel.parentno isEqualToString:model.classifyNo])
            {
                isopen=YES;
                break;
            }
        }
        if (isopen)
        {
            [cell.backImageView setImage:[UIImage imageNamed:@"extend_1"]];
        }else
        {
            [cell.backImageView setImage:[UIImage imageNamed:@"extend_2"]];
        }
       
    }else
    {
        [cell.backImageView setImage:nil];
        
    }
    //
    CGFloat led=5;
    for (NSInteger i=0; i<model.depth; i++) {
        led=led+30;
    }
    cell.leding.constant=led;
    cell.namelable.text=model.classifyName;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)jugeWithModel:(ClassifyModel *)model
{
    
}
#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 0.01;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    ClassifyModel *parentModel = [_tempData objectAtIndex:indexPath.row];
  
   
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        ClassifyModel *model = [_data objectAtIndex:i];
        if ([model.parentno isEqualToString:parentModel.classifyNo] ) {
            
            model.expand = !model.expand;
            if (model.expand) {
                NSLog(@"展开");
                 NSLog(@"%ld",endPosition);
                [_tempData insertObject:model atIndex:endPosition];
                expand = YES;
            }else{
               
                expand = NO;
                endPosition = [self removeAllClassifyModelsAtParentClassifyModel:parentModel];
               
                break;
            }
            endPosition++;
        }
    }
    
//    //获得需要修正的indexPath
//    NSMutableArray *indexPathArray = [NSMutableArray array];
//    for (NSUInteger i=startPosition; i<endPosition; i++) {
//        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [indexPathArray addObject:tempIndexPath];
//    }
//    
//    //插入或者删除相关节点
//    if (expand) {
//        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
//    }else{
//        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
//    }
    [self reloadData];
}


/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *
 *
 *  @return 邻接父节点的位置距离该父节点的长度，也就是该父节点下面所有的子孙节点的数量
 */
-(NSUInteger)removeAllClassifyModelsAtParentClassifyModel : (ClassifyModel *)parentMode{
    NSUInteger startPosition = [_tempData indexOfObject:parentMode];
 
    NSUInteger endPosition ;
//    if ([self judge])
//    {
//        endPosition = startPosition;
//    }else
//    {
        endPosition = startPosition+1;
//    }
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        ClassifyModel *model = [_tempData objectAtIndex:i];
      
        if (model.depth == parentMode.depth) {
           
            break;
        }
        endPosition++;
    
        model.expand = NO;
    }
    if (endPosition>startPosition) {
     
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}
-(BOOL)judge
{
    NSInteger k=0;
    for (ClassifyModel *model in _data)
    {
        
        if (model.parentno.length>0)
        {
            
        }else
        {
            k++;
        }
    }
 
    if (k>1)
    {
      
        return YES;
    }else
    {
        
        return NO;
    }
}
@end
