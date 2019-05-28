//
//  ChooseTipsView.m
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/5/27.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import "ChooseTipsView.h"
@interface ChooseTipsView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,copy)void(^chooseDone)(NSString * values);
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSArray * dataArray;
@end
@implementation ChooseTipsView
+(void)startChooseTipsCallBack:(void(^)(NSString * values))callback
{
    ChooseTipsView * temp  = [[ChooseTipsView alloc]init];
    temp.frame = UIApplication.sharedApplication.keyWindow.bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:temp];

    
}

-(instancetype)init
{
    if (self = [super init]) {
         self.backgroundColor = A_COLOR_STRING(0x191919, 0.8f);
        UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 515)];
        self.contentView = contenView;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView * collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        collectionview.delegate = self;
        collectionview.dataSource = self;
        self.collectionView = collectionview;
        UITextField * textfield = [[UITextField alloc]init];
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor = MainColor;
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:collectionview];
        [self.contentView addSubview:textfield];
        [self.contentView addSubview:btn1];
        [self.contentView addSubview:btn2];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
        [collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.bottom);
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(200);
        }];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(collectionview.bottom);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 45));
        }];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(collectionview.bottom);
            make.left.mas_equalTo(self.contentView).offset(2);
            make.right.mas_equalTo(btn1.mas_left).offset(-10);
            make.height.mas_equalTo(45);
        }];
       
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textfield.mas_bottom).offset(20);
            make.left.right.mas_equalTo(self.contentView).offset(50);
            make.height.mas_equalTo(50);
        }];
        [self getdata];
    }
    return self;
}
-(void)getdata{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_BaseVar",@"SelectField":@"*",@"Condition":@"moduleno$=$CMS$AND$varfield$=$shoplabel",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"dic1dic1==>%@",dic1);

//        m = dic1@[@""];
        [weakSelf.collectionView reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

#pragma mark - collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    return cell;
}

@end


@implementation TipsModel



@end
