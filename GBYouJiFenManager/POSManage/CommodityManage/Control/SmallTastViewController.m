//
//  SmallTastViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SmallTastViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "CoverView.h"
#import "TastManagerCollectionViewCell.h"
#import "AreaSetView.h"
#import "TasteRequestModel.h"
#import "TreeTableView.h"
#import "ClassifyModel.h"
@interface SmallTastViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CAKeyframeAnimation * keyAnimaion ;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MemberModel *model;
@property (strong, nonatomic) IBOutlet UICollectionView *collectonView;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)AreaSetView *tastSetView;

@property (strong, nonatomic) IBOutlet UILabel *classylable;
@property(nonatomic,strong)TreeTableView *tableview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Lheight;
@property(nonatomic,strong)NSMutableArray *classifyArray;
@property (strong, nonatomic) IBOutlet UIButton *addClaButton;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@end

@implementation SmallTastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[ColorTool colorWithHexString:@"#f5f5f5"];
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    [self getClassifyData];
  
    // Do any additional setup after loading the view from its nib.
}
-(void)setCollectonView:(UICollectionView *)collectonView
{
    _collectonView=collectonView;
    [_collectonView registerNib:[UINib nibWithNibName:@"TastManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TastManagerCollectionViewCell"];
    _collectonView=collectonView;
    _collectonView.backgroundColor=[ColorTool colorWithHexString:@"#f5f5f5"];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectonView addGestureRecognizer:_longPress];
    
    
}
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectIndexPath = [self.collectonView indexPathForItemAtPoint:[_longPress locationInView:self.collectonView]];
            // 找到当前的cell
            TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectonView cellForItemAtIndexPath:selectIndexPath];
            if (cell.lable.hidden) {
                return;
            }else
            {
                
                // 定义cell的时候btn是隐藏的, 在这里设置为NO
                [cell.btnDelete setHidden:NO];
                [self statAnimation:cell];
//                [self.collectonView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
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
//            
//            [self.collectonView cancelInteractiveMovement];
        }
            break;
    }
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    NSIndexPath *selectIndexPath = [self.collectonView indexPathForItemAtPoint:[_longPress locationInView:self.collectonView]];
    // 找到当前的cell
    TastManagerCollectionViewCell *cell = (TastManagerCollectionViewCell *)[self.collectonView cellForItemAtIndexPath:selectIndexPath];
    [cell.btnDelete setHidden:YES];
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [self.collectonView reloadData];
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
-(void)setAddClaButton:(UIButton *)addClaButton
{
    _addClaButton=addClaButton;
    _addClaButton.backgroundColor=navigationBarColor;
    _addClaButton.layer.cornerRadius=8;
    _addClaButton.layer.masksToBounds=YES;
}
-(void)getClassifyData
{
 
    NSArray *arry=[_tastModel.classifyList componentsSeparatedByString:@","];
   
    
    NSMutableString *str=[NSMutableString stringWithString:[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$(",_model.COMPANY,_model.SHOPID]];
    for (NSInteger i=0;i<arry.count;i++) {
        NSString *aStr;
        if (i==arry.count-1)
        {
           aStr=[NSString stringWithFormat:@"ClassifyNo$=$%@",arry[i]];
        }else
        {
          
            aStr=[NSString stringWithFormat:@"ClassifyNo$=$%@$OR$",arry[i]];
        }
        
        [str appendString:aStr];
    }

    [str appendString:@")"];

    NSLog(@"－－－－－－－－－－－%@",str);
    [self getClassifyWithCondition:str];
    
}

-(NSMutableArray*)classifyArray
{
    if (!_classifyArray) {
        
        _classifyArray=[NSMutableArray array];
    }
    return _classifyArray;
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
-(void)getData
{
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    
    NSString *condition= [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$DI003$=$%@",self.model.COMPANY,self.model.SHOPID,self.tastModel.itemNo];
    NSDictionary *dic=@{@"FromTableName":@"POSDI",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        [self.dataArray removeAllObjects];
        self.dataArray=[TasteRequestModel getDataWith:dic1];
        [self.dataArray addObject:[self getImage]];
//                NSLog(@"---%@",dic1);
        [self.collectonView reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)addDataWithStr:(NSString*)str
{
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DI002":str,@"DI003":_tastModel.itemNo}]};
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
-(void)addClassifyWithStr:(NSString*)str
{
   
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSDC",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"DC002":self.tastModel.classifyName,@"DC003":str,@"DC001":self.tastModel.itemNo}]};
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
                [self changeLable];
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
- (IBAction)addClassifyData:(UIButton *)sender
{
    [self getClassify];
}
-(void)getClassifyWithCondition:(NSString*)condition
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];

    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        self.classifyArray=[ClassifyModel getDataWithDic:dic1];
        [self changeLable];
        [self getData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}
-(void)getClassify
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
         NSLog(@"%@",dic1);
        [self creatClssifyTableWithClassifyArray:[ClassifyModel getDataWithDic:dic1]];
       
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)creatClssifyTableWithClassifyArray:(NSMutableArray *)array
{
    _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_coverView];
    _tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(30, 24,screen_width-60, screen_height*0.7 ) withData:array];
    _tableview.doneButt=YES;
    [_coverView addSubview:_tableview];
    [_coverView addSubview:[self getFootview]];
    __weak typeof(self)weakSelf=self;
    [self.classifyArray removeAllObjects];
    _tableview.backBlock=^(ClassifyModel *model){

        if (model.selected)
        {
            [weakSelf.classifyArray addObject:model];
        }else
        {
            if ([weakSelf.classifyArray containsObject:model]) {
                [weakSelf.classifyArray removeObject:model];
            }
        }
      
      
    };
   
    
}
-(void)radiosWithView:(UIView*)view
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = view.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
}
-(void)changeLable
{
    if (!self.classifyArray.count)
    {
        self.classylable.text=@"还没有添加可使用分类,点击下方按钮可添加";
    }else
    {
       NSMutableArray *titleArray=[NSMutableArray array];
        for (ClassifyModel *model in self.classifyArray) {
            [titleArray addObject:model.classifyName];
        }
        NSString *str=[titleArray componentsJoinedByString:@","];
    
        self.classylable.text=[NSString stringWithFormat:@"可使用分类: %@",str];
        self.classylable.numberOfLines = 0;
     
        self.classylable.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [ self.classylable sizeThatFits:CGSizeMake(screen_width-11, MAXFLOAT)];
        self.Lheight.constant=size.height+17;
    }
}
-(UIView*)getFootview
{

    UIView *buttView=[[UIView alloc]initWithFrame:CGRectMake(30, 24+screen_height*0.7, screen_width-60, 50)];
    buttView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(20,5, buttView.width-40,40);
    button.backgroundColor=MainColor;
    button.layer.cornerRadius=8;
    [button setTitle:@"确认选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttClick) forControlEvents:UIControlEventTouchUpInside];
    [buttView addSubview:button];
    return buttView;
    
}
-(void)buttClick
{
  
    [_tableview removeFromSuperview];
    [_coverView removeFromSuperview];
    NSMutableArray *nuArray=[NSMutableArray array];
    for (ClassifyModel * model in self.classifyArray) {
        [nuArray addObject:model.classifyNo];
    }
   
    NSString *str=[nuArray componentsJoinedByString:@";"];

    [self addClassifyWithStr:str];
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

        TasteRequestModel *model=_dataArray[indexPath.row];
        cell.addImage.hidden=YES;
        cell.lable.hidden=NO;
        cell.lable.backgroundColor=[ColorTool colorWithHexString:@"#f5f5f5"];;
        cell.contentView.layer.cornerRadius=5;
        cell.contentView.layer.masksToBounds=YES;
        cell.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth=1;
        cell.lable.font=[UIFont systemFontOfSize:14];
        cell.lable.text=model.tasteName;
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
-(void)deletDataWithModel:(TasteRequestModel*)model
{
    
    [SVProgressHUD showWithStatus:@"玩命加载中"];

    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DI001":model.itemNo,@"DI002":model.tasteName,@"DI003":model.tasteClasses}]};
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([_dataArray[indexPath.row] isKindOfClass:[UIImage class]])
    {
        _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _tastSetView=[[NSBundle mainBundle]loadNibNamed:@"AreaSetView" owner:nil options:nil][0];
        _tastSetView.funType=@"SmallTast";
        DefineWeakSelf;
        _tastSetView.tastBlock=^(NSString *str){
            [weakSelf.coverView removeFromSuperview];
            [weakSelf addDataWithStr:str];
        };
        [_coverView addSubview:_tastSetView];
        [_tastSetView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_coverView.mas_centerX);
            make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70-64);
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
            return;
        }

        
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
       return CGSizeMake((screen_width-25)/4,(screen_width-25)*0.8/4);
    
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
