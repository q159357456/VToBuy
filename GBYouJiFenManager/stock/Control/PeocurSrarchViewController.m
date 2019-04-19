//
//  PeocurSrarchViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/22.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PeocurSrarchViewController.h"
#import "FirstTableViewCell.h"
#import "ADShopInfoModel.h"
#import "DownOrderTableViewCell.h"
#import "ProductModel.h"
#import "FMDBShopCar.h"
#import "FMDBShopInfo.h"
#import "STShopCarViewController.h"
#import "RegisterNav.h"
#import "PeocurDetailViewController.h"
@interface PeocurSrarchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CAAnimationDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *shopInfoArray;
@property(nonatomic,strong)NSMutableArray *productArray;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UITextField *seacher;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CALayer *dotLayer;
@property (nonatomic,strong) UIBezierPath *path;
@property (strong, nonatomic) IBOutlet UILabel *contLable;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *shopCarButton;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;

@end

@implementation PeocurSrarchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tableView reloadData];

   
}


- (void)viewDidLoad {
    [super viewDidLoad];
        self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)B2BSearchShopInfoWithStr:(NSString*)str
{
    NSMutableString *string=[NSMutableString stringWithString:@"ProductName$LIKE$%"];
    [string appendString:[NSString stringWithFormat:@"%@",str]];
    [string appendString:@"%"];
    
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"inv_bproduct",@"SelectField":@"*",@"Condition":string,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
        NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"----%@",dic1);
        if (dic1) {
            self.productArray=[ProductModel getDataWithDic:dic1];
        }
        [self.tableView reloadData];
        
    } Faile:^(NSError *error) {
        
    }];
    
    
}
#pragma mark--textfild
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self B2BSearchShopInfoWithStr:textField.text];
    
    [self.seacher resignFirstResponder];
    return YES;
}
-(NSMutableArray *)shopInfoArray
{
    if (!_shopInfoArray) {
        _shopInfoArray=[NSMutableArray array];
    }
    return _shopInfoArray;
}
-(void)creatUI
{
    self.navView.backgroundColor=navigationBarColor;
    self.seacher.returnKeyType=UIReturnKeySearch;
    self.searchView.layer.cornerRadius=10;
    self.searchView.layer.masksToBounds=YES;
    self.seacher.placeholder=@"请输入商品名称";
    self.seacher.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.seacher.delegate=self;
    self.searchView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    _productArray=[NSMutableArray array];
    _seacher.returnKeyType= UIReturnKeySearch;
    _doneButton.backgroundColor=navigationBarColor;
    self.contLable.backgroundColor=navigationBarColor;
    self.contLable.layer.cornerRadius=10;
    self.contLable.layer.masksToBounds=YES;
    [self changeState];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark-table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        return self.productArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    static NSString *cellid=@"DownOrderTableViewCell";
    DownOrderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"DownOrderTableViewCell" owner:nil options:nil][0];
    }
    if (self.productArray.count) {
        ProductModel *model=self.productArray[indexPath.row];
        
        //count
        BOOL is=NO;
        for (ProductModel *pmodel in [[FMDBShopCar shareInstance]getShopCarModel]) {
            if ([model.ProductNo isEqualToString:pmodel.ProductNo])
            {
                is=YES;
                model.count=pmodel.count;
                break;
            }
        }
        if (!is) {
            model.count=0;
        }
        NSString *url=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[url URLEncodedString]] placeholderImage:[UIImage imageNamed:@"holder"]];
        cell.lable1.text=model.ProductName;
        cell.lable2.text=[NSString stringWithFormat:@"¥%@",model.RetailPrice];
        cell.lable4.text=[NSString stringWithFormat:@"%ld",model.count];
        cell.pluseButton.hidden=NO;
        cell.minceButton.hidden=NO;
        cell.TastButton.hidden=YES;
        if (model.count==0)
        {   cell.lable4.hidden=YES;
            cell.minceButton.hidden=YES;
        }else
        {  cell.lable4.hidden=NO;
            cell.minceButton.hidden=NO;
        }
        DefineWeakSelf;
        __weak typeof(DownOrderTableViewCell*)weakCell=cell;
        cell.pluseBlock=^(UIImageView *image,UIButton *butt){
            model.count++;
            [[FMDBShopCar shareInstance]insertUser:model];
            [self insertShopInfoWithStr:model.shopname :model.SupplierNo];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            CGRect rect=[weakCell convertRect:butt.frame toView:self.view];
            [self JoinCartAnimationWithRect:rect];
            
        };
        cell.minceBlock=^{
            if (model.count>0) {
                if (model.count==1)
                {
                    model.count--;
                    [[FMDBShopCar shareInstance]deleteTable:model];
                    
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                    [weakSelf changeState];
                    
                }else
                {
                    model.count--;
                    [[FMDBShopCar shareInstance]insertUser:model];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                    [weakSelf changeState];
                    
                }
                
                
            }
            
            
            
        };
        
        
    }
    
    return cell;
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

        return 10;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 110;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //详情
    ProductModel *model=self.productArray[indexPath.row];
    PeocurDetailViewController *detail=[[PeocurDetailViewController alloc]init];
    detail.title=@"商品详情";
    detail.proModel=model;
    [self.navigationController pushViewController:detail animated:YES];
    
    
    
}
#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    CGRect brect=[self.shopCarButton convertRect:self.shopCarButton.frame toView:self.view];
    CGFloat endX=brect.origin.x+20;
    CGFloat enY=brect.origin.y+20;
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(endX, enY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 150, startY - 150)];
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
    _dotLayer.cornerRadius = (15 + 15) /4;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
    
}
-(void)insertShopInfoWithStr:(NSString*)shopName :(NSString*)shopid
{
    ADShopInfoModel *model=[[ADShopInfoModel alloc]init];
    model.SHOPID=shopid;
    model.ShopName=shopName;
    [[FMDBShopInfo shareInstance]insertShopInfo:model];
}
-(void)changeState
{
    
    NSArray *dataArray=[[FMDBShopCar shareInstance]getShopCarModel];
    
    if (dataArray.count==0) {
        
        self.doneButton.enabled=NO;
        self.priceLable.hidden=YES;
        self.contLable.hidden=YES;
        self.shopCarButton.enabled=NO;
        
    }else
    {
        self.shopCarButton.enabled=YES;
        self.doneButton.enabled=YES;
        self.contLable.hidden=NO;
        self.contLable.text=[NSString stringWithFormat:@"%ld",dataArray.count];
        float prie=0;
        for (ProductModel *model in dataArray) {
            prie=prie+model.count*model.RetailPrice.floatValue;
            self.priceLable.text=[NSString stringWithFormat:@"%.2f",prie];
        }
    }
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    [self changeState];
    [layerAnimation removeFromSuperlayer];
    
    
    
}
- (IBAction)clickShopCar:(UIButton *)sender {
    STShopCarViewController *shop=[[STShopCarViewController alloc]init];
    RegisterNav *reNav= [[RegisterNav alloc] initWithRootViewController:shop];
    CCViewController *fancyViewController = (CCViewController *) self;
    
    fancyViewController.interactionEnabled = YES;
    NSString *className = @"CCLayerAnimation";
    id transitionInstance = [[NSClassFromString(className) alloc] init];
    fancyViewController.animationController = transitionInstance;
    fancyViewController.animationController.type = 0;
    if ([self respondsToSelector:@selector(setTransitioningDelegate:)]){
        reNav.transitioningDelegate = self.transitioningDelegate;
    }
    shop.title=@"购物车";
    [self presentViewController:reNav animated:YES completion:nil];
}
- (IBAction)done:(UIButton *)sender {
    STShopCarViewController *shop=[[STShopCarViewController alloc]init];
    RegisterNav *reNav= [[RegisterNav alloc] initWithRootViewController:shop];
    CCViewController *fancyViewController = (CCViewController *) self;
    
    fancyViewController.interactionEnabled = YES;
    NSString *className = @"CCLayerAnimation";
    id transitionInstance = [[NSClassFromString(className) alloc] init];
    fancyViewController.animationController = transitionInstance;
    fancyViewController.animationController.type = 0;
    if ([self respondsToSelector:@selector(setTransitioningDelegate:)]){
        reNav.transitioningDelegate = self.transitioningDelegate;
    }
    shop.title=@"购物车";
    [self presentViewController:reNav animated:YES completion:nil];
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
