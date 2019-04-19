//
//  AddClassifyViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddClassifyViewController.h"
#import "TreeTableView.h"
#import "AddDetailViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface AddClassifyViewController ()
@property(nonatomic,strong)TreeTableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)ClassifyModel *clasiModel;
@end
@implementation AddClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _dataArray=[NSMutableArray array];
    if ([self.funType isEqualToString:@"mananger"])
    {
        //管理大类
        
        
    }else
    {
        //选择大类
        [self addRightButton];
        
    }
    //服务器获取大类
    [self getClassify];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)commit
{
    if (self.clasiModel.classifyNo.length>0)
    {
         self.backBlock(self.clasiModel);
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self alertShowWithStr:@"请选择分类"];
    }
  
}
-(void)getClassify
{
//    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"%@",dic1);
        _dataArray=[ClassifyModel getDataWithDic:dic1];
        if (!_tableview)
        {

            [self creatClssifyTable];
        }else
        {

            [_tableview getData:_dataArray];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)creatClssifyTable
{
    _tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-80-44) withData:_dataArray];
    __weak typeof(self)weakSelf=self;
    _tableview.backBlock=^(ClassifyModel *model){

        if (model.selected)
        {
             weakSelf.clasiModel=model;
        }else
        {
            weakSelf.clasiModel=nil;
        }
       
    };
    [self.view addSubview:_tableview];
//       if ([self.funType isEqualToString:@"mananger"])
//       {
//            [self creatBttom];
//       }else
//       {
//           
//           
//       }
    
    [self creatBttom];
   
}
-(void)creatBttom
{


    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
   
    NSArray *nameArray=@[@"编辑",@"删除",@"新增"];
    NSArray *imageArray=@[@"edit",@"delete",@"add"];
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/3*i,screen_height-59,screen_width/3-1, 59);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        if (i>0) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/3*i-1,screen_height-50, 1, 40)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [self.view addSubview:lineView];
        }
        
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.backgroundColor=[UIColor whiteColor];
        
        button.tag=i+1;
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }

}
-(void)touch:(UIButton*)butt
{
    if (butt.tag==1)
    {
        NSLog(@"编辑");
        if (self.clasiModel.classifyNo.length==0)
        {
            [self alertShowWithStr:@"先选中要编辑的类别"];
            
        }else
        {
            AddDetailViewController *detail=[[AddDetailViewController alloc]init];
            detail.clssiModel=self.clasiModel;
            detail.funType=@"Edit";
            detail.title=@"编辑大类";
            __weak typeof(self)weakSelf=self;
            detail.backBlock=^{
                [weakSelf getClassify];
            };
            [self.navigationController pushViewController:detail animated:YES];

        }
       
        
        
    }else if (butt.tag==2)
    {
        NSLog(@"删除");
        [self alertShowWithString:@"是否确认删除？"];
        
        
    }else
    {
        NSLog(@"新增");
       
        AddDetailViewController *detail=[[AddDetailViewController alloc]init];
        detail.clssiModel=self.clasiModel;
         detail.funType=@"Add";
        detail.title=@"新增大类";
         __weak typeof(self)weakSelf=self;
        detail.backBlock=^{
            [weakSelf getClassify];
        };
        [self.navigationController pushViewController:detail animated:YES];
    }
}
-(void)deletClassify
{
   
    
    NSDictionary *jsonDic;
    if (self.clasiModel.classifyNo.length==0)
    {
        [self alertShowWithStr:@"先选中要删除的类别"];
        
    }else
    {
        MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
      
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"加载中"];
       jsonDic=@{@"Command":@"Del",@"TableName":@"Inv_Classify",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"ClassifyName":self.clasiModel.classifyName,@"Status":self.clasiModel.Status,@"ParentNo":self.clasiModel.classifyNo,@"ClassifyNo":self.clasiModel.classifyNo,@"ClassifyType":@"02"}]};
        
        
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            
            NSString *str=[JsonTools getNSString:responseObject];
      
            if ([str isEqualToString:@"OK"])
            {
                //删除成功
                [self getClassify];
                
            }else
            {
                [self alertShowWithStr:@"删除失败"];
            }

            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

    }
    

}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)alertShowWithString:(NSString *)string
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deletClassify];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    
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
