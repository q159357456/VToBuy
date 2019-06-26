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
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,copy)void(^doneCallBack)(NSString *value);
@end
@implementation ChooseTipsView
+(void)startChooseTipsCallBack:(void(^)(NSString * values))callback
{
    ChooseTipsView * temp  = [[ChooseTipsView alloc]init];
    temp.doneCallBack = ^(NSString *value) {
        callback(value);
    };
    temp.frame = UIApplication.sharedApplication.keyWindow.bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:temp];

    
}

-(instancetype)init
{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
         self.backgroundColor = A_COLOR_STRING(0x191919, 0.8f);
        UIView *contenView = [[UIView alloc]init];
        self.contentView = contenView;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-SCALE(100));
            make.size.mas_equalTo(CGSizeMake(screen_width, 340));
        }];
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = @"选择标签";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView * collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        collectionview.delegate = self;
        collectionview.dataSource = self;
        collectionview.backgroundColor = [UIColor whiteColor];
        self.collectionView = collectionview;
        UITextField * textfield = [[UITextField alloc]init];
        textfield.borderStyle = UITextBorderStyleLine;
        UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor = [UIColor lightGrayColor];
        btn2.backgroundColor = MainColor;
        [btn1 setTitle:@"添加" forState:UIControlStateNormal];
        [btn2 setTitle:@"确定" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        btn1.layer.cornerRadius = 8;
        btn1.layer.masksToBounds = YES;
        btn2.layer.cornerRadius = 8;
        btn2.layer.masksToBounds = YES;
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:collectionview];
        [self.contentView addSubview:textfield];
        [self.contentView addSubview:btn1];
        [self.contentView addSubview:btn2];
        self.textfield = textfield;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
        [collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(140);
        }];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(collectionview.mas_bottom);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 45));
        }];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(collectionview.mas_bottom);
            make.left.mas_equalTo(self.contentView).offset(2);
            make.right.mas_equalTo(btn1.mas_left).offset(-10);
            make.height.mas_equalTo(45);
        }];
//
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textfield.mas_bottom).offset(25);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCALE(300), 50));
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
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"dic1dic1==>%@",dic1);
        for (NSDictionary *dic in dic1[@"DataSet"][@"Table"]) {
            TipsModel *model = [[TipsModel alloc]init];
            model.name = dic[@"VarValue"];
            [weakSelf.dataArray addObject:model];
        }
        [weakSelf.collectionView reloadData];
    } Faile:^(NSError *error) {
        [SVProgressHUD dismiss];
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
    TipsModel * model = self.dataArray[indexPath.item];
    UILabel * label = [[UILabel alloc]init];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(cell);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:SCALE(13)];
    label.text = model.name;
    if (model.isSelected) {
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
    }else
    {
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = [UIColor lightGrayColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     TipsModel * model = self.dataArray[indexPath.item];
     model.isSelected = !model.isSelected;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (screen_width - SCALE(10)*5)/4;
    CGFloat h = 150/4;
    return CGSizeMake(w, h);
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return SCALE(10);
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, SCALE(10), 10, SCALE(10));
}

-(void)add{
    
    if (self.textfield.text.length>0) {
        TipsModel *model = [[TipsModel alloc]init];
        model.name = self.textfield.text;
        [self.dataArray addObject:model];
        [self.collectionView reloadData];
        self.textfield.text = @"";
    }
}
-(void)done{
    
    if (self.dataArray.count) {
        NSMutableArray * temp = [NSMutableArray array];
        for (TipsModel *model in self.dataArray) {
            if (model.isSelected) {
               [temp addObject:model.name];
            }
       
        }
        if (temp.count) {
            self.doneCallBack([temp componentsJoinedByString:@";"]);
        }
        
    }
    
    [self removeFromSuperview];
    
}
@end


@implementation TipsModel



@end
