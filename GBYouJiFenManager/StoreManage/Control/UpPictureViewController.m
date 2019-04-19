//
//  UpPictureViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "UpPictureViewController.h"
#import "UpPictureTableViewCell.h"
#import "UpPictureCollectionViewCell.h"
#import "BigPictureViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "PictureModel.h"
#import "ImageCutoutViewController.h"
typedef void(^SomeBlock)();
@interface UpPictureViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YKCutPhotoDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSMutableArray *pictureArray;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSMutableArray *needArray;
@end

@implementation UpPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.pictureArray=[NSMutableArray array];
    _needArray=[NSMutableArray array];
     [_pictureArray addObject:@"uppic_2"];
    [_collectionview registerNib:[UINib nibWithNibName:@"UpPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UpPictureCollectionViewCell"];

    self.doneButton.layer.cornerRadius=5;
    [self getButtonState];
    [self getPictureData];
        // Do any additional setup after loading the view from its nib.
}
#pragma mark YKCutPhotoDelegate
-(void)getBackCutPhotos:(NSData *)data
{
        [_pictureArray  insertObject:data atIndex:_pictureArray.count-1];
        [self getButtonState];
        [self.collectionview reloadData];
}
-(void)getButtonState
{
    BOOL is=NO;
    for (NSInteger i=0; i<_pictureArray.count; i++) {
        if ([_pictureArray[i] isKindOfClass:[NSData class]]) {
            is=YES;
            break;
        }
    }
    if (is) {
        self.doneButton.enabled=YES;
    }else
    {
        self.doneButton.enabled=NO;
    }
    if (!self.doneButton.enabled)
    {
        self.doneButton.backgroundColor=[UIColor lightGrayColor];
    }else
    {
        self.doneButton.backgroundColor=MainColor;
    }

    
}
-(void)getPictureData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_ShopPhoto",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        NSArray *array=[PictureModel getDataWithDic:dic1];
        [_pictureArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
        [self.collectionview reloadData];

    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    return _pictureArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UpPictureCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"UpPictureCollectionViewCell" forIndexPath:indexPath];
   
    
    if ([_pictureArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        
        cell.picImage.image=[UIImage imageNamed:_pictureArray[indexPath.row]];
        cell.closeButton.hidden=YES;
     
        cell.classiLable.hidden=YES;
 
        
    }else if([_pictureArray[indexPath.row] isKindOfClass:[NSData class]])
    {
        cell.picImage.image=[UIImage imageWithData:_pictureArray[indexPath.row]];
        cell.closeButton.hidden=NO;
        cell.classiLable.hidden=YES;
        __weak typeof(self)weakSelf=self;
        cell.closeBlock=^{
            // 删除还未上传的
            [weakSelf.pictureArray removeObjectAtIndex:indexPath.row];
            [weakSelf getButtonState];
            [weakSelf.collectionview reloadData];

        };
        
        
    }else
    {
        
        PictureModel *model=_pictureArray[indexPath.row];
                NSString *str=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PhotoUrl];
                NSString *urlStr=[str URLEncodedString];
        //        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                NSLog(@"%@",urlStr);
        //        [_pictureArray insertObject:data atIndex:0];
        [cell.picImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        cell.closeButton.hidden=NO;
        cell.classiLable.hidden=YES;
          __weak typeof(self)weakSelf=self;
        cell.closeBlock=^{
            //删除已经上传的
           [weakSelf deletPictureWithIndex:indexPath.row];
        };

        
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_pictureArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        
        [self addPicture];
    }else
    {
        
        [self bigPictureWithIndex:indexPath.row];
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((screen_width-25)/4,(screen_width-25)*36/4*23+10);
    
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

-(void)bigPictureWithIndex:(NSInteger)index
{
    if([_pictureArray[index] isKindOfClass:[NSData class]])
    {
        BigPictureViewController *big=[[BigPictureViewController alloc]init];
        UIImage *image=[UIImage imageWithData:_pictureArray[index]];
        big.image=image;
        [self presentViewController:big animated:YES completion:nil];
    }else
    {
        
        PictureModel *model=_pictureArray[index];
        NSString *str=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PhotoUrl];
        NSString *urlStr=[str URLEncodedString];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        UIImage *image=[UIImage imageWithData:data];
        BigPictureViewController *big=[[BigPictureViewController alloc]init];
        big.image=image;
        [self presentViewController:big animated:YES completion:nil];
   
        
    }
}
-(void)deletPictureWithIndex:(NSInteger)index
{
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    PictureModel *pmodel=_pictureArray[index];
    NSDictionary *jsonDic;
    jsonDic=@{@"Command":@"Del",@"TableName":@"CMS_ShopPhoto",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"ID":[NSString stringWithFormat:@"%@",pmodel.ID]}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    

    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"OK"])
        {
            [_pictureArray removeObjectAtIndex:index];
       
            [self.collectionview reloadData];
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithStr:@"删除失败,稍后再试"];
            
        }
        
    } Faile:^(NSError *error) {
        [self alertShowWithStr:@"上传失败,稍后再试"];
        return;
    
    }];


}
-(void)addPicture
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用照相机
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing=YES;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用相册
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
  
    }];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ImageCutoutViewController *cut=[[ImageCutoutViewController alloc]init];
    cut.delegate=self;
    cut.cutImage=image;
    [picker presentViewController:cut animated:YES completion:nil];

}
- (IBAction)done:(UIButton *)sender
{
    if (_pictureArray.count>=2)
    {
        [SVProgressHUD showWithStatus:@"加载中"];
     
        for (NSInteger i=0; i<_pictureArray.count; i++) {
            if ([_pictureArray[i] isKindOfClass:[NSData class]]) {
                [_needArray addObject:_pictureArray[i]];
            }
        }
        [self requestWithArray:_needArray index:0 completion:^{
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });

        }];
        
    }else
    {
        [self alertShowWithStr:@"请添加图片"];
    }

    
}
//上传图片
- (void)requestWithArray:(NSArray*)array index:(NSInteger)k completion:(SomeBlock)completion
{
    if (k>=array.count) {
        if (completion) {
            completion();
        }
        return;
    }
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
   jsonDic=@{ @"Command":@"Add",@"TableName":@"CMS_ShopPhoto",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSString *encodedImageStr = [array[k] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":encodedImageStr,@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"OK"])
        {
            [self requestWithArray:array index:k+1 completion:completion];
        }else
        {
              [SVProgressHUD dismiss];
            
            [self alertShowWithStr:@"上传失败,稍后再试"];
            return;
           
        }
        
        
    } Faile:^(NSError *error) {
        [self alertShowWithStr:@"上传失败,稍后再试"];
        return;
     
    }];

    
}
-(void)delePictureWith:(NSInteger)index
{
    
    
    
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
