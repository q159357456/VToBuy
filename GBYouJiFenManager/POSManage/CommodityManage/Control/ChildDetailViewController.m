//
//  ChildDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ChildDetailViewController.h"
#import "CommodityBtnViewController.h"
#import "ProductModel.h"
#import "GroupModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "DosAgeView.h"
#import "CoverView.h"
#import "TastManagerCollectionViewCell.h"
#import "GroupCollectionReusableView.h"
typedef void(^SomeBlock)();
@interface ChildDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    float offset;
    CAKeyframeAnimation * keyAnimaion ;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL is;
@property(nonatomic,assign)float height;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)DosAgeView *dosAgeView;

@end

@implementation ChildDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
  
  
    [self addKeyBoardNotify];

    [self getproductdata];
        

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
-(void)setCollectionview:(UICollectionView *)collectionview
{
    _collectionview=collectionview;
    [_collectionview registerNib:[UINib nibWithNibName:@"TastManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TastManagerCollectionViewCell"];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionview addGestureRecognizer:_longPress];
    [self.collectionview registerNib:[UINib nibWithNibName:@"GroupCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BHEADER"];
    
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
            ProductModel*model=_dataArray[indexPath.row];
          
            cell.addImage.hidden=YES;
            cell.lable.hidden=NO;
            cell.contentView.layer.cornerRadius=8;
            cell.contentView.layer.masksToBounds=YES;
            cell.lable.backgroundColor=[ColorTool colorWithHexString:@"#f5f5f5"];
            cell.contentView.layer.borderWidth=1;
            cell.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cell.lable.font=[UIFont systemFontOfSize:16];
            cell.lable.text=[NSString stringWithFormat:@"%@X%@",model.ProductName,[model.Dosage removeZeroWithStr]];
            
            DefineWeakSelf;
            cell.deletBlock=^{
                
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [weakSelf deleteProductWithModel:model];
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
             //添加商品
            CommodityBtnViewController *com=[[CommodityBtnViewController alloc]init];
            com.title=@"选择套餐子件";
            com.combArray=[NSMutableArray arrayWithArray:_dataArray];
            __weak typeof(self)weakSelf=self;
            com.backBlock=^(NSMutableArray *chooseArray){

                [weakSelf addproductWithArray:chooseArray];
            };
            [self.navigationController pushViewController:com animated:YES];
        

        }else
        {
            TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
            if (cell.btnDelete.hidden==NO)
            {
                [cell.layer removeAllAnimations];
                cell.btnDelete.hidden=YES;
                
            }else
            {
                _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                _dosAgeView=[[NSBundle mainBundle]loadNibNamed:@"DosAgeView" owner:nil options:nil][0];
                  ProductModel*model=_dataArray[indexPath.row];
                _dosAgeView.count=model.Dosage.integerValue;
                
                DefineWeakSelf;
                _dosAgeView.combBlock=^(NSInteger count){
                    
                    [weakSelf.coverView removeFromSuperview];
                    [weakSelf editeGroupWithModel:model Dosage:[NSString stringWithFormat:@"%ld",count]];
                    
                };
                [_coverView addSubview:_dosAgeView];
                [_dosAgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(_coverView.mas_centerX);
                    make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
                    make.width.mas_equalTo(250);
                    make.height.mas_equalTo(200);
                    
                }];
                [self.view addSubview:_coverView];

      
            }
            
            
        }

}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGSize size = {screen_width, 50};
    return size;
    
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 初始化表头


    GroupCollectionReusableView  *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BHEADER" forIndexPath:indexPath];
    
    headerView.lable.text=@"添加商品";
    return headerView;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((screen_width-20)/3,(screen_width-20)*0.6/3);
    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
    
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


-(void)getproductdata
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
      MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition;
       if (!_groupModel)
       {
           condition=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$A.Hproductno$=$%@$AND$A.Te_Gp$=$%@",model.COMPANY,model.SHOPID,self.model.ProductNo,@"0"];
       }else
       {
           condition=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$A.Hproductno$=$%@$AND$A.Te_Gp$=$%@",model.COMPANY,model.SHOPID,self.model.ProductNo,_groupModel.GP_No];
       }
    NSDictionary *dic=@{@"FromTableName":@"Bom_DetailProduct[A]||inv_product[B]{ left (A.company=B.company and A.shopid=B.shopid and A.DProductNo=B.ProductNo)}",@"SelectField":@"A.*,B.ProductName,B.ProductNo",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
//    NSLog(@"%@",dic);
//        NSDictionary *dic=@{@"FromTableName":@"Bom_DetailProduct[A]||inv_product[B]{ left (A.company=B.company and A.shopid=B.shopid and A.DProductNo=B.ProductNo)} ||BOM_GProduct[C]{left (A.company=C.company and a.shopid=C.shopid and  A.HProductNo=C.HProductNo and  A.Te_Gp=C.GP_No )}",@"SelectField":@"A.*,B.ProductName,B.ProductNo,C.GP_Name",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"---%@",dic1);
        [self.dataArray removeAllObjects];
        self.dataArray=[ProductModel getDataWithDic:dic1];
        [self.dataArray addObject:[self getImage]];
        [self.collectionview reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)deleteProductWithModel:(ProductModel*)model
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *membermodel=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    NSString *GP_No;
    NSString *BasicQuantity;
    if (!_groupModel) {
        
        //添加必选商品
        GP_No=@"0";
        BasicQuantity=@"0";
    }else
    {
        GP_No=_groupModel.GP_No;
        BasicQuantity=_groupModel.BasicQuantity;
    }

    jsonDic=@{@"Command":@"Del",@"TableName":@"BOM_DetailProduct",@"Data":@[@{@"COMPANY":membermodel.COMPANY,@"SHOPID":membermodel.SHOPID,@"CREATOR":@"admin",@"Te_Gp":GP_No,@"DProductNo":model.DProductNo,@"BasicQuantity":BasicQuantity,@"Dosage":model.Dosage,@"Unit":model.Unit,@"HProductNo":_model.ProductNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self getproductdata];
                
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
-(void)addproductWithArray:(NSMutableArray*)array
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    [self requestWithArray:array index:0 completion:^{
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getproductdata];
        });
    }];
}

- (void)requestWithArray:(NSArray*)array index:(NSInteger)k completion:(SomeBlock)completion
{
    if (k>=array.count) {
        if (completion) {
            completion();
        }
        return;
    }
    MemberModel *membermodel=[[FMDBMember shareInstance]getMemberData][0];
    ProductModel *model=array[k];
    NSDictionary *jsonDic;
    NSString *GP_No;
    NSString *BasicQuantity;
    if (!_groupModel) {
        //添加必选商品
        GP_No=@"0";
        BasicQuantity=@"0";
    }else
    {
        GP_No=_groupModel.GP_No;
       BasicQuantity=_groupModel.BasicQuantity;
    }
    jsonDic=@{ @"Command":@"Add",@"TableName":@"BOM_DetailProduct",@"Data":@[@{@"COMPANY":membermodel.COMPANY,@"SHOPID":membermodel.SHOPID,@"CREATOR":@"admin",@"Te_Gp":GP_No,@"DProductNo":model.ProductNo,@"BasicQuantity":BasicQuantity,@"Dosage":@"1",@"Unit":model.Unit,@"HProductNo":_model.ProductNo}]};
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
             [self requestWithArray:array index:k+1 completion:completion];
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
            return ;
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}

-(void)editeGroupWithModel:(ProductModel*)model Dosage:(NSString*)dasage
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *membermodel=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    NSString *GP_No;
    NSString *BasicQuantity;
    if (!_groupModel) {
        
        //添加必选商品
        GP_No=@"0";
        BasicQuantity=@"0";
    }else
    {
        GP_No=_groupModel.GP_No;
        BasicQuantity=_groupModel.BasicQuantity;
    }

    jsonDic=@{ @"Command":@"Edit",@"TableName":@"BOM_DetailProduct",@"Data":@[@{@"COMPANY":membermodel.COMPANY,@"SHOPID":membermodel.SHOPID,@"CREATOR":@"admin",@"Te_Gp":GP_No,@"DProductNo":model.ProductNo,@"BasicQuantity":BasicQuantity,@"Dosage":dasage,@"Unit":model.Unit,@"HProductNo":_model.ProductNo,@"Seq":model.Seq}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"----%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self getproductdata];
                
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


-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
    offset = self.height - (self.view.frame.size.height - kbHeight);
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
   
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
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
