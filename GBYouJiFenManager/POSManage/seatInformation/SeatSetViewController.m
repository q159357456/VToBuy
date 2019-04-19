//
//  SeatSetViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SeatSetViewController.h"
#import "ReserveTableViewCell.h"
#import "RoomTypeModel.h"
#import "FloorModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "AreaSetView.h"
#import "TypeSetView.h"
#import "CoverView.h"
#import "roomDataModel.h"
#import "AddSeatViewController.h"
#import "SeatCodeViewController.h"
#import "seatDetailTableViewCell.h"
@interface SeatSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)FloorModel *floorModel;
@property(nonatomic,strong)RoomTypeModel *roomModel;
@property(nonatomic,strong)roomDataModel *seatModel;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)AreaSetView *areaSetView;
@property(nonatomic,strong)TypeSetView *typeSetView;





@end

@implementation SeatSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _model=[[FMDBMember shareInstance]getMemberData][0];
    [self createUI];
    if ([self.funType isEqualToString:@"Area"])
    {
        [self getAreaArraydata];
    }else if ([self.funType isEqualToString:@"Seat"])
    {
        [self getseatArraydata];
    }
    else
    {
        [self gettypeArraydata];
        
    }
    [self quckilyCreat];

}
-(void)quckilyCreat
{
    if (self.floorNo.length) {
        UIButton *button=(UIButton*)[self.view viewWithTag:1];
        [self touch:button];
    }
    if (_goTocreatArea) {
        UIButton *button=(UIButton*)[self.view viewWithTag:1];
        [self touch:button];
        
    }

}
#pragma mark-getdata
-(void)getAreaArraydata
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
                [SVProgressHUD dismiss];
           self.floorModel=nil;
        NSDictionary *dic1=[JsonTools getData:responseObject];
//                NSLog(@"%@",dic1);
        self.dataArray=[FloorModel getDataWithDic:dic1];
        [self .tableview reloadData];
 
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

-(void)gettypeArraydata
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"POSST[A]||POSAF[B]{ left (A.company=B.company and A.shopid=B.shopid and A.ST005=B.AF001)}",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.roomModel=nil;
        NSDictionary *dic1=[JsonTools getData:responseObject];
//                 NSLog(@"%@",dic1);
        self.dataArray=[RoomTypeModel getDataWithDic:dic1];
        [self.tableview reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getseatArraydata
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];

    NSDictionary *dic=@{@"FromTableName":@" POSSI[A]||POSAF[B]{ left (A.company=B.company and A.shopid=B.shopid and A.SI004=B.AF001)} ||POSST[C]{left (A.company=C.company and a.shopid=C.shopid and  A.SI003=C.ST001)}",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
         self.seatModel=nil;
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"%@",dic1);
        self.dataArray=[roomDataModel getDataWithDic:dic1];
        [self.tableview reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)createUI
{
    NSArray *title;
    
    if ([self.funType isEqualToString:@"Area"])
    {
         title=@[@"区域名称",@"区域编号"];
    
    }else if ([self.funType isEqualToString:@"Seat"])
    {
           title = @[@"房台名称",@"房台类型",@"房台区域",@"房台二维码"];
    }
    else
    {
          title = @[@"类型名称",@"类型编号",@"所属区域"];
    }

    
    UIView*ItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    ItemView.backgroundColor = navigationBarColor;
 
    for (int i = 0; i<title.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20+i*(screen_width-20)/title.count,0,(screen_width-20)/title.count, 40)];
        lab.text = title[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor=[UIColor whiteColor];
        [ItemView addSubview:lab];
    }
    [self.view addSubview:ItemView];
    
    //
    [self cretTable];
    
    
    //底部按钮
    [self creatBttom];
    
}
-(void)cretTable
{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, screen_width, screen_height-104-60) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
    if ([_tableview respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableview.estimatedRowHeight = 0;
            _tableview.estimatedSectionHeaderHeight = 0;
            _tableview.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
}

-(void)creatBttom
{
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60-64, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    NSArray *nameArray;
    NSArray *imageArray;
    if([self.funType isEqualToString:@"Seat"])
    {
       nameArray=@[@"删除",@"编辑",@"新增"];
        imageArray=@[@"delete",@"edit",@"add"];
    }else
    {
       nameArray=@[@"新增",@"删除",@"编辑"];
       imageArray=@[@"add",@"delete",@"edit"];
    }
    
  
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/nameArray.count*i,screen_height-59-64,screen_width/nameArray.count-1, 59);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        if (i>0) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/nameArray.count*i-1,screen_height-50-64, 1, 40)];
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
        //增
        if ([self.funType isEqualToString:@"Area"])
        {
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            _areaSetView=[[NSBundle mainBundle]loadNibNamed:@"AreaSetView" owner:nil options:nil][0];
            DefineWeakSelf;
            _areaSetView.backBlock=^{
                [weakSelf.coverView removeFromSuperview];
                //通知中心
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil userInfo:nil];

                if (weakSelf.goTocreatArea)
                {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else
                {
                     [weakSelf getAreaArraydata];
                }

               
            };
            [_coverView addSubview:_areaSetView];
            [_areaSetView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(_coverView.mas_centerX);
                make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
                make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
                make.height.mas_equalTo(200);
                
            }];
            
            [window addSubview:_coverView];
            
        }else if ([self.funType isEqualToString:@"Seat"])
        {
            
            //删除房台
             if (self.seatModel)
             {
                 if ([self.seatModel.SI005 intValue] == 0) {
                     
                     [self alertShowWithString:@"是否确认删除？"];
                    
                 }else
                 {
                      [self alertShowWithStr:@"房台已占用，不能删除"];
                 }
             }else
             {
                [self alertShowWithStr:@"请先选中需要删除条目"];
             }
                 
          
        }
        else
        {
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            _typeSetView=[[NSBundle mainBundle]loadNibNamed:@"TypeSetView" owner:nil options:nil][0];
            _typeSetView.funType=@"type";
            if (_floorNo.length) {
                _typeSetView.floorNo=_floorNo;
                _typeSetView.floorName=_floorName;
            }
            DefineWeakSelf;
            _typeSetView.backBlock=^{
              
                [weakSelf.coverView removeFromSuperview];
                //通知中心
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil userInfo:nil];
                if (weakSelf.floorNo.length)
                {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else
                {
                     [weakSelf gettypeArraydata];
                }
               
            };
            [_coverView addSubview:_typeSetView];
            [_typeSetView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(_coverView.mas_centerX);
                make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
                make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
                make.height.mas_equalTo(50*4+1);
                
            }];
            [window addSubview:_coverView];
            
        }
        
        
        
    }else if (butt.tag==2)
    {
        //删
        if ([self.funType isEqualToString:@"Area"])
        {
            if (self.floorModel)
            {
                NSDictionary* jsonDic=@{ @"Command":@"Del",@"TableName":@"POSAF",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"AF002":self.floorModel.FloorInfo,@"AF001":self.floorModel.itemNo}]};
                [self deletModelWithJsonDic:jsonDic];
            }else
            {
                 [self alertShowWithStr:@"请先选中需要删除条目"];
            }
            
            
        }else if ([self.funType isEqualToString:@"Seat"])
        {
            
            //编辑房台
            if (_seatModel)
            {
                AddSeatViewController *add=[[AddSeatViewController alloc]init];
                add.title=@"编辑房台";
                DefineWeakSelf;
                add.backBlock=^{
                    [weakSelf getseatArraydata];
                };
                add.seatModel=_seatModel;
                [self.navigationController pushViewController:add animated:YES];
                
            }else
            {
                [self alertShowWithStr:@"请先选中需要编辑条目"];
            }
           
        }
        else
        {
              if (self.roomModel)
              {
                  NSDictionary* jsonDic=@{ @"Command":@"Del",@"TableName":@"POSST",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ST002":self.roomModel.RoomName,@"ST001":self.roomModel.itemNo}]};
                  [self deletModelWithJsonDic:jsonDic];
                  
              }else
              {
                   [self alertShowWithStr:@"请先选中需要删除条目"];
              }
            
        }
        
        
    }else
    {
        //改
        if ([self.funType isEqualToString:@"Area"])
        {
            if (self.floorModel)
            {
                UIWindow *window=[UIApplication sharedApplication].keyWindow;
                _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                _areaSetView=[[NSBundle mainBundle]loadNibNamed:@"AreaSetView" owner:nil options:nil][0];
                 _areaSetView.titleLable.text=@"  编辑";
                _areaSetView.floorModel=self.floorModel;
                DefineWeakSelf;
                _areaSetView.backBlock=^{
                    [weakSelf.coverView removeFromSuperview];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil userInfo:nil];
                    [weakSelf getAreaArraydata];
                };
                [_coverView addSubview:_areaSetView];
                [_areaSetView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(_coverView.mas_centerX);
                    make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
                    make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
                    make.height.mas_equalTo(200);
                    
                }];
                [window addSubview:_coverView];

            }else
            {
                [self alertShowWithStr:@"请先选中需要编辑条目"];
            }
           
            
        }else if ([self.funType isEqualToString:@"Seat"])
        {
          //新增房台
            AddSeatViewController *add=[[AddSeatViewController alloc]init];
            add.title=@"新增房台";
            DefineWeakSelf;
            add.backBlock=^{
                [weakSelf getseatArraydata];
            };
            [self.navigationController pushViewController:add animated:YES];
            
        
        }
        else
        {
            if (_roomModel)
            {
                UIWindow *window=[UIApplication sharedApplication].keyWindow;
                _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                _typeSetView=[[NSBundle mainBundle]loadNibNamed:@"TypeSetView" owner:nil options:nil][0];
                _typeSetView.funType=_funType;
                _typeSetView.titleLable.text=@"  编辑";
                _typeSetView.roomModel=_roomModel;
                DefineWeakSelf;
                _typeSetView.backBlock=^{
                    [weakSelf.coverView removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil userInfo:nil];
                    [weakSelf gettypeArraydata];
                };
                [_coverView addSubview:_typeSetView];
                [_typeSetView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerX.mas_equalTo(_coverView.mas_centerX);
                    make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
                    make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
                    make.height.mas_equalTo(50*4+1);
                    
                }];
                [window addSubview:_coverView];
            }else
            {
                [self alertShowWithStr:@"请先选中需要编辑条目"];
            }
          
        }
        
    }
}

-(void)alertShowWithString:(NSString *)string
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //确认删除房台
        NSDictionary* jsonDic=@{ @"Command":@"Del",@"TableName":@"POSSI",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"SI002":self.seatModel.roomName,@"SI003":self.seatModel.roomType,@"SI004":self.seatModel.floorArea,@"SI015":self.seatModel.isValid,@"SI018":self.seatModel.isBook,@"SI001":self.seatModel.itemNo}]};
        [self deletModelWithJsonDic:jsonDic];

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.funType isEqualToString:@"Area"])
    {
        static NSString *cellid=@"ReserveViewController ";
        ReserveTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ReserveTableViewCell" owner:nil options:nil][0];
            
        }
        FloorModel *model=_dataArray[indexPath.row];
            NSArray *array=@[model.FloorInfo,model.itemNo];
            [cell initLabelWithArray:array];
            if (model.selected)
            {
                cell.selectLab.backgroundColor=navigationBarColor;
        
            }else
            {
                cell.selectLab.backgroundColor=[UIColor whiteColor];
            }
        
        return cell;
    }else if ([self.funType isEqualToString:@"Seat"])
    {
        static NSString *cellid=@"seatDetailTableViewCell";
        seatDetailTableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"seatDetailTableViewCell" owner:nil options:nil][0];
            
        }

       roomDataModel *model=_dataArray[indexPath.row];
       NSArray *array=@[model.roomName,model.ST002,model.AF002];
           [cell initLabelWithArray:array];
        if (model.selected)
        {
            cell.selectLabel.backgroundColor=navigationBarColor;
            
        }else
        {
            cell.selectLabel.backgroundColor=[UIColor whiteColor];
        }
        cell.codeBlock = ^{
                        if (model)
                        {
                            SeatCodeViewController *code=[[SeatCodeViewController alloc]init];
                            code.seatNo=model.itemNo;
                            code.seatNa=model.roomName;
                            code.title=@"房台二维码";
                            [self.navigationController pushViewController:code animated:YES];
                        }else
                        {
                            [self alertShowWithStr:@"请先选中房台"];
                        }

        };
       return cell;
    }
    else
    {
        static NSString *cellid=@"ReserveViewController ";
        ReserveTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ReserveTableViewCell" owner:nil options:nil][0];
            
        }
        RoomTypeModel *model=_dataArray[indexPath.row];
            NSArray *array=@[model.RoomName,model.itemNo,model.AF002];
            [cell initLabelWithArray:array];
            if (model.selected)
            {
                cell.selectLab.backgroundColor=navigationBarColor;
        
            }else
            {
                cell.selectLab.backgroundColor=[UIColor whiteColor];
            }
        
        return cell;
    }


    
    
   // return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
     if ([self.funType isEqualToString:@"Area"])
     {
      
         FloorModel *model=_dataArray[indexPath.row];
    
         for (FloorModel *smodel in _dataArray) {
             if ([smodel.itemNo isEqualToString:model.itemNo])
             {
                 smodel.selected=!smodel.selected;
                 //
                 if (smodel.selected==YES) {
                     self.floorModel=smodel;
                 }else
                 {
                     self.floorModel=nil;
                 }
             }else
             {
                 smodel.selected=NO;
             }
         }

     }else if ([self.funType isEqualToString:@"Seat"])
     {
         
         roomDataModel *model=_dataArray[indexPath.row];
         
             for (roomDataModel *smodel in _dataArray) {
                 if ([smodel.itemNo isEqualToString:model.itemNo])
                 {
                     smodel.selected=!smodel.selected;
                     //
                     if (smodel.selected==YES) {
                         self.seatModel=smodel;
                     }else
                     {
                         self.seatModel=nil;
                     }
                    
                 }else
                 {
                     smodel.selected=NO;
                 }
             }
     }
     else
     {
     
    
         RoomTypeModel *model=_dataArray[indexPath.row];
         for (RoomTypeModel *smodel in _dataArray) {
             if ([smodel.itemNo isEqualToString:model.itemNo])
             {
                 smodel.selected=!smodel.selected;
                 //
                 if (smodel.selected==YES) {
                     self.roomModel=smodel;
                 }else
                 {
                     self.roomModel=nil;
                 }
             }else
             {
                 smodel.selected=NO;
             }
         }

         
     }
       [self.tableview reloadData];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)deletModelWithJsonDic:(NSDictionary *)jsondic
{
    [SVProgressHUD showWithStatus:@"加载中"];
    

    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsondic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            //通知中心
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [SVProgressHUD dismiss];
                
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil userInfo:@{@"Type":@"delet"}];
            if (_roomModel)
            {
                [self gettypeArraydata];
            }else if (_floorModel)
            {
                [self getAreaArraydata];
            }else
            {
                [self getseatArraydata];
            }
                
           
           
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"上传失败稍后再试"];
        }
        
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
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
