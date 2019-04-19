//
//  ComboViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ComboViewController.h"
#import "AddComboViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "CoverView.h"
#import "TypeSetView.h"
#import "TastManagerCollectionViewCell.h"
#import "AddComboViewController.h"
@interface ComboViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
        CAKeyframeAnimation * keyAnimaion ;
    
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic ,retain)FMDBMember *model;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)TypeSetView *typeSetView;
@property(nonatomic,copy)NSString *classifyName;
@property(nonatomic,copy)NSString *classifyNo;
@end

@implementation ComboViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
   self.model = [[FMDBMember shareInstance] getMemberData][0];
    [self getAllData];
    // Do any additional setup after loading the view from its nib.
}

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
-(void)setCollectionview:(UICollectionView *)collectionview
{
    _collectionview=collectionview;
    [_collectionview registerNib:[UINib nibWithNibName:@"TastManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TastManagerCollectionViewCell"];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionview addGestureRecognizer:_longPress];
    
    
}
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectIndexPath = [self.collectionview indexPathForItemAtPoint:[_longPress locationInView:self.collectionview]];
            // 找到当前的cell
            TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:selectIndexPath];
            if (cell.lable.hidden) {
                return;
            }else
            {
                
                // 定义cell的时候btn是隐藏的, 在这里设置为NO
                [cell.btnDelete setHidden:NO];
                [self statAnimation:cell];
            }
            
            
            break;
        }
        case UIGestureRecognizerStateChanged:  break;
 
        case UIGestureRecognizerStateEnded: break;
         default: break;
           
       
     
           
    }
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

-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$Property$=$C",model.SHOPID];
      NSDictionary *dic=@{@"FromTableName":@"inv_product[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"A.ProductNo,A.ProductName,A.Classify_2",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        [self.dataArray removeAllObjects];
        self.dataArray=[ProductModel getDataWithDic:dic1];
        [self.dataArray addObject:[self getImage]];
        [self.collectionview reloadData];
       
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)deletDataWithModel:(ProductModel*)pmodel
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Del",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"ProductName":pmodel.ProductName,@"Property":@"C",@"Classify_2":pmodel.Classify_2,@"ProductNo":pmodel.ProductNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self getAllData];
                
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}
-(void)addCombWithStr:(NSString*)str classiNo:(NSString*)classifiNo
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"ProductName":str,@"Property":@"C",@"Classify_2":classifiNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
          
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self getAllData];
            
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
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
        ProductModel *model=_dataArray[indexPath.row];
        cell.contentView.layer.borderWidth=1;
        cell.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.addImage.hidden=YES;
        cell.lable.hidden=NO;
        cell.lable.backgroundColor=[ColorTool colorWithHexString:@"#f5f5f5"];;
        cell.lable.text=model.ProductName;
        DefineWeakSelf;
        cell.deletBlock=^{
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf deletDataWithModel:model];
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
        };
        
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_dataArray[indexPath.row] isKindOfClass:[UIImage class]])
    {
        _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _typeSetView=[[NSBundle mainBundle]loadNibNamed:@"TypeSetView" owner:nil options:nil][0];
        _typeSetView.funType=@"comb";
   
        DefineWeakSelf;
        _typeSetView.combBlock=^(ClassifyModel *model,NSString *productName){
            [weakSelf.coverView removeFromSuperview];
            [weakSelf addCombWithStr:productName classiNo:model.classifyNo];
            
        };
        [_coverView addSubview:_typeSetView];
        [_typeSetView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_coverView.mas_centerX);
            make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
            make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
            make.height.mas_equalTo(50*4+1);
            
        }];
        [self.view addSubview:_coverView];


        
    }else
    {
        TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
        if (cell.btnDelete.hidden==NO)
        {
            [cell.layer removeAllAnimations];
            cell.btnDelete.hidden=YES;
            
        }else
        {
            ProductModel *model=_dataArray[indexPath.row];
            AddComboViewController *small=[[AddComboViewController alloc]init];
            small.title=@"创建套餐明细";
            small.model=model;
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


-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
