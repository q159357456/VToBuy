//
//  ZWHShareQRViewController.m
//  ZHONGHUILAOWU
//
//  Created by Syrena on 2018/11/23.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "ZWHShareQRViewController.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "UMSocialUIManager.h"
#import "ZWHShareCollectionViewCell.h"
#import "ZWHADModel.h"

@interface ZWHShareQRViewController ()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource,ZWHShareCollectionViewCellDelegate>

@property(nonatomic,strong)UITableView *listTableView;

@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)TYCyclePagerView *scroImage;

@property(nonatomic,strong)QMUIGridView *bottomGridView;

@property(nonatomic,strong)NSMutableArray *adArray;

@property(nonatomic,strong)UIImage *qrimg;

@property(nonatomic,assign)BOOL isImg;

@property(nonatomic,strong)NSString *qrUrl;


@end

@implementation ZWHShareQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享好友";
    _adArray = [NSMutableArray array];
    [self creatUI];
    //[self getpositionData];
}

#pragma mark - 创建UI
-(void)creatUI{
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.showsHorizontalScrollIndicator = NO;
    _listTableView.separatorStyle = 0;
    _listTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listTableView];
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    self.keyTableView = _listTableView;
    
    //UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZWHTabHeight)];
    //foot.backgroundColor = lineColor;
    //self.listTableView.tableFooterView = foot;
    
    [self setHeaderView];
    [self setfootView];

    [self getpositionData];
}


-(void)getCodeurl{
    MJWeakSelf;
    //[self showEmptyViewWithLoading];
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"SystemCommService.asmx/GetInviteQRcodeUrl" With:@{} and:^(id responseObject) {
        NSString *resdict=[JsonTools getNSString:responseObject];
        NSLog(@"%@",resdict);
        //weakSelf.qrCodeImg = resdict;
        [weakSelf getQCodeImg];
    } Faile:^(NSError *error) {
        
    }];
}

-(void)getQCodeImg{
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *url=[NSString stringWithFormat:@"/upload/%@",model.LogoUrl];
    _qrUrl = [NSString stringWithFormat:@"http://shop.dgyjian.com/wxshop/appfxkq.aspx?fromid=%@&cardid=%@&shopid=%@&mode=lq&p_id=%@&p_type=M",_coumodel.UDF02,_coumodel.ID,_coumodel.SHOPID,_coumodel.UDF02];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/GeneratePayURLImgQRCode" With:@{@"url":[NSString stringWithFormat:@"http://shop.dgyjian.com/wxshop/appfxkq.aspx?fromid=%@&cardid=%@&shopid=%@&mode=lq&p_id=%@&p_type=M",_coumodel.UDF02,_coumodel.ID,_coumodel.SHOPID,_coumodel.UDF02],@"sourceImg":url} and:^(id responseObject) {
        weakSelf.qrimg=[UIImage imageWithData:responseObject];
        [weakSelf.scroImage reloadData];
    } Faile:^(NSError *error) {
        
    }];
}



-(void)getpositionData{
    NSDictionary *dict = @{@"cityname":@"",@"ad_type":@"Share"};

    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"MallService.asmx/GetADInfo_new" With:dict and:^(id responseObject) {
        NSDictionary *dic = [JsonTools getData:responseObject];
        [self hideEmptyView];
        if ([dic[@"message"] isEqualToString:@"OK"]) {
            NSLog(@"%@",dict);
            weakSelf.adArray = [ZWHADModel mj_objectArrayWithKeyValuesArray:dic[@"DataSet"][@"Table"]];
            weakSelf.pageControl.numberOfPages = weakSelf.adArray.count;
            [weakSelf.scroImage setNeedUpdateLayout];
            [weakSelf.scroImage reloadData];
            [weakSelf getCodeurl];
        }else{
            [QMUITips showError:dic[@"message"]];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}


-(void)setHeaderView{
    _scroImage = [[TYCyclePagerView alloc]init];
    _scroImage.autoScrollInterval = 4;
    _scroImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(480));
    _scroImage.layout.itemSize = CGSizeMake(WIDTH_PRO(255), HEIGHT_PRO(410));
    _scroImage.isInfiniteLoop = YES;
    _scroImage.dataSource = self;
    _scroImage.delegate = self;
    [_scroImage registerClass:[ZWHShareCollectionViewCell class] forCellWithReuseIdentifier:@"ZWHShareCollectionViewCell"];
    self.listTableView.tableHeaderView = _scroImage;
    [_scroImage setNeedUpdateLayout];
    [_scroImage reloadData];
    
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_scroImage.frame) - 26, CGRectGetWidth(_scroImage.frame), 26)];
    _pageControl.numberOfPages = _adArray.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = navigationBarColor;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_scroImage addSubview:_pageControl];
}

-(void)setfootView{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(150))];
    
    QMUILabel *lab = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"---海报分享给---";
    [foot addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(foot).offset(HEIGHT_PRO(8));
        make.centerX.equalTo(foot);
    }];
    [foot addSubview:self.bottomGridView];
    [_bottomGridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(foot);
        make.top.equalTo(lab.mas_bottom).offset(HEIGHT_PRO(6));
        make.height.mas_equalTo(HEIGHT_PRO(95));
    }];
    
    
    self.listTableView.tableFooterView = foot;
}





#pragma mark - TYCyclePagerViewDelegate
-(NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView{
    NSLog(@"%ld",_adArray.count);
    return _adArray.count;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    ZWHShareCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"ZWHShareCollectionViewCell" forIndex:index];
    if (_adArray.count>0) {
        ZWHADModel *model = _adArray[index];
        //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1]);
        [cell.backimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1]] placeholderImage:[UIImage qmui_imageWithColor:[UIColor whiteColor]]];
        if (_qrimg) {
            cell.QRimg.image = _qrimg;
            //cell.delegate = self;
        }
    }
    
    return cell;
}

-(TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView{
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(WIDTH_PRO(255), HEIGHT_PRO(410));
    layout.itemSpacing = WIDTH_PRO(30);
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    layout.itemHorizontalCenter = YES;
    return layout;
}

-(void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    _pageControl.currentPage = toIndex;
}


//分享模块
-(QMUIGridView *)bottomGridView{
    if (!_bottomGridView) {
        NSArray *titleArr = @[@"微信好友(海报)",@"朋友圈(海报)",@"微信好友(链接)",@"朋友圈(链接)"];
        NSArray *imageArr = @[@"weixin",@"pengyou",@"weixin",@"pengyou"];
        _bottomGridView = [[QMUIGridView alloc]initWithColumn:4 rowHeight:HEIGHT_PRO(95)];
        _bottomGridView.backgroundColor = [UIColor clearColor];
        for (NSInteger i=0;i<imageArr.count;i++) {
            QMUIButton *btn = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:imageArr[i]] title:titleArr[i]];
            [btn setTitleColor:[UIColor grayColor] forState:0];
            btn.titleLabel.font = ZWHFont(13);
            btn.imagePosition = QMUIButtonImagePositionTop;
            btn.spacingBetweenImageAndTitle = 8.0f;
            btn.backgroundColor = [UIColor clearColor];
            [_bottomGridView addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(bottomGirdViewWith:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _bottomGridView;
}

#pragma mark - 分享
-(void)bottomGirdViewWith:(QMUIButton *)btn{
    switch (btn.tag) {
        case 0: {
            // 微信
            _isImg = YES;
            [self shareTextToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case 1: {
            // 微信朋友圈
            _isImg = YES;
            [self shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
            
        }
            break;
        case 2: {
            // 微信
            _isImg = NO;
            [self shareTextToPlatformType:UMSocialPlatformType_WechatSession];
            
            
        }
            break;
        case 3: {
            // 微信朋友圈
            _isImg = NO;
            [self shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        default:
            break;
    }
}


//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (_isImg) {
        
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:[UIImage imageNamed:@"11-1"]];
        NSString *shopname;
        if (platformType==UMSocialPlatformType_QQ||platformType==UMSocialPlatformType_Qzone)
        {
            shopname=@"异见餐饮";
        }else
        {
            shopname=@"异见餐饮";
        }
        //NSString *url=[NSString stringWithFormat:@"%@?shopid=%@&shopname=%@",[userDefault objectForKey:@"codeUrl"],gSHOPID,shopname];
        
        //shareObject.webpageUrl =url;
        ZWHShareCollectionViewCell *cell = [_scroImage curIndexCell];
        shareObject.shareImage = [UIImage qmui_imageWithView:cell.contentView];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"分享成功");
                NSLog(@"response data is %@",data);
            }
        }];
    }else{
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"异见餐饮" descr:@"您的好友赠送您一大波贵宾尊享金券" thumImage:[UIImage imageNamed:@"11-1"]];
        NSString *url=_qrUrl;
        shareObject.webpageUrl =url;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"分享成功");
                NSLog(@"response data is %@",data);
            }
        }];
    }
    
}


-(void)returnImg:(UIImage *)img{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存到相册?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);//保存图片到照片库
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:sure];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error==nil){
        [QMUITips showSucceed:@"保存成功"];
    }else{
        [QMUITips showError:@"保存失败"];
    }
}


 
@end
