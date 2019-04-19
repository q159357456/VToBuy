//
//  TastManagerViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "TastManagerViewController.h"
#import "TastManagerCollectionViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "CoverView.h"
#import "AreaSetView.h"
#import "TasteKindModel.h"
#import "SmallTastViewController.h"
@interface TastManagerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CAKeyframeAnimation * keyAnimaion ;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectonView;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)AreaSetView *tastSetView;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@end

@implementation TastManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
     self.model = [[FMDBMember shareInstance] getMemberData][0];
    [self getData];
  
    
}
-(void)setCollectonView:(UICollectionView *)collectonView
{
    _collectonView=collectonView;
    [_collectonView registerNib:[UINib nibWithNibName:@"TastManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TastManagerCollectionViewCell"];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectonView addGestureRecognizer:_longPress];
    
    
}
-(void)statAnimation:(UIView*)view
{
    //创建动画
    keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-1 / 180.0 * M_PI),@(1 /180.0 * M_PI),@(-1/ 180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.1;
    keyAnimaion.repeatCount = MAXFLOAT;
    [view.layer addAnimation:keyAnimaion forKey:nil];
    
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectIndexPath = [self.collectonView indexPathForItemAtPoint:[_longPress locationInView:self.collectonView]];
           
            TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectonView cellForItemAtIndexPath:selectIndexPath];
            if (cell.lable.hidden) {
                return;
            }else
            {
            
                [cell.btnDelete setHidden:NO];
                [self statAnimation:cell];
//                 [self.collectonView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            
            
            break;
        }
//        case UIGestureRecognizerStateChanged:
//        {
//    
//
//        
//            [self.collectonView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
//            break;
//        }
//        case UIGestureRecognizerStateEnded:
//        {
//           
//            [self.collectonView endInteractiveMovement];
//            break;
//        }
        default:
        {
          
//            [self.collectonView cancelInteractiveMovement];
        }
            break;
    }
}
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
//{
//    NSIndexPath *selectIndexPath = [self.collectonView indexPathForItemAtPoint:[_longPress locationInView:self.collectonView]];
//
//    TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectonView cellForItemAtIndexPath:selectIndexPath];
//    [cell.btnDelete setHidden:YES];
//    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//    [self.collectonView reloadData];
//}


-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
       
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(UIImage*)getImage
{
     UIImage *image=[UIImage imageNamed:@"uppic_2"];
    return image;
}
-(void)getData
{
     [SVProgressHUD showWithStatus:@"玩命加载中"];
  
    NSString *condition= [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    NSDictionary *dic=@{@"FromTableName":@"POSDC",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        [self.dataArray removeAllObjects];
        self.dataArray=[TasteKindModel getDataWithDic:dic1];
        [self.dataArray addObject:[self getImage]];
//        NSLog(@"---%@",dic1);
        
        [self.collectonView reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)addDataWithStr:(NSString*)str
{
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDC",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DC002":str,@"DC003":@"0"}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getData];
                [SVProgressHUD dismiss];
                
               
            });
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"上传失败稍后再试"];
        }
        
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}
-(void)deletDataWithModel:(TasteKindModel*)model
{
    
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    
    NSDictionary *jsonDic;
 jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDC",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DC002":model.classifyName,@"DC003":model.classifyList,@"DC001":model.itemNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dataArray removeObject:model];
                [self.collectonView reloadData];
                [SVProgressHUD dismiss];
                
            });
        
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"上传失败稍后再试"];
        }
        
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TastManagerCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TastManagerCollectionViewCell" forIndexPath:indexPath];
    cell.btnDelete.hidden=YES;
    if (indexPath.row==_dataArray.count-1)
    {
        cell.contentView.layer.borderColor=[UIColor clearColor].CGColor;
        cell.lable.hidden=YES;
        cell.addImage.hidden=NO;
        cell.addImage.image=_dataArray[indexPath.row];
        
    }else
    {
      
        cell.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth=1;
        TasteKindModel *model=_dataArray[indexPath.row];
        cell.addImage.hidden=YES;
        cell.lable.hidden=NO;
        cell.lable.text=model.classifyName;
        cell.lable.backgroundColor= [ColorTool colorWithHexString:@"#f5f5f5"];
      
        DefineWeakSelf;
        cell.deletBlock=^{
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
                 [weakSelf deletDataWithModel:model];
            }];
            [alert addAction:action];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];
           
        };
        
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_dataArray[indexPath.row] isKindOfClass:[UIImage class]])
    {
        _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _tastSetView=[[NSBundle mainBundle]loadNibNamed:@"AreaSetView" owner:nil options:nil][0];
        _tastSetView.funType=@"Tast";
        DefineWeakSelf;
        _tastSetView.tastBlock=^(NSString *str){
            [weakSelf.coverView removeFromSuperview];
            [weakSelf addDataWithStr:str];
        };
        [_coverView addSubview:_tastSetView];
        [_tastSetView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_coverView.mas_centerX);
            make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
            make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
            make.height.mas_equalTo(200);
            
        }];
        [self.view addSubview:_coverView];

       
    }else
    {
         TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectonView cellForItemAtIndexPath:indexPath];
        if (cell.btnDelete.hidden==NO)
        {
            [cell.layer removeAllAnimations];
            cell.btnDelete.hidden=YES;
            
        }else
        {
            TasteKindModel *model=_dataArray[indexPath.row];
            SmallTastViewController *small=[[SmallTastViewController alloc]init];
            small.title=[NSString stringWithFormat:@"创建口味明细-%@",model.classifyName];
            small.tastModel=model;
            [self.navigationController pushViewController:small animated:YES];
        }
     
  
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((screen_width-20)/3,(screen_width-20)*0.6/3);


    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    
    return UIEdgeInsetsMake(20, 5, 5, 5);
    
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5;
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 5;
    
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
