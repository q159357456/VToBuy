//
//  ZWHNorSearchViewController.m
//  FengHuaKe
//
//  Created by Syrena on 2018/8/24.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "ZWHNorSearchViewController.h"
#import "IQKeyboardManager.h"
#import "ZWHOrderOnlineViewController.h"
#import <IQKeyboardManager.h>



@interface ZWHNorSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSArray *keywords;
@property(nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;

@property(nonatomic, strong) QMUILabel *titleLabel;
@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;

@property(nonatomic, strong) UIView *qdRecentSearchView;

@property(nonatomic, strong) UITableView *searchTable;

@property(nonatomic,strong)UISearchBar *searchBar;

@end

@implementation ZWHNorSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setsearchbar];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0];
}

- (void)showKeyboard {
    [self.searchBar becomeFirstResponder];
}

-(void)setUI{
    _searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:_searchTable];
    [_searchTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    
    
    [_searchTable layoutIfNeeded];
    _searchTable.delegate = self;
    _searchTable.dataSource = self;
    _searchTable.separatorStyle = 0;
    _searchTable.backgroundColor = [UIColor whiteColor];
    _searchTable.showsVerticalScrollIndicator = NO;
    [self.searchTable registerClass:[QMUITableViewCell class] forCellReuseIdentifier:@"QMUITableViewCell"];
    self.keyTableView = _searchTable;
    
    
    //self.keywords = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat", @"Metabolism", @"Nuturally"];
    self.keywords = @[];
    
    [self.view addSubview:self.qdRecentSearchView];
    [_qdRecentSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    _qdRecentSearchView.alpha = 0;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - 自定义searchbar
-(void)setsearchbar{
    UIView *navView = [[UIView alloc]init];
    navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ZWHNavHeight);
    navView.backgroundColor = navigationBarColor;
    [self.view addSubview:navView];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH_PRO(260), 30)];
    _searchBar.placeholder = @"输入房台号";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor blackColor];
    
    
    [navView addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(WIDTH_PRO(15));
        make.right.equalTo(navView).offset(-WIDTH_PRO(45));
        make.bottom.equalTo(navView).offset(-4);
        make.height.mas_equalTo(20);
    }];
    [_searchBar layoutIfNeeded];
    
    UIView *searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.subviews.firstObject.backgroundColor = [UIColor whiteColor];
    
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = searchField.height/2;
        searchField.layer.masksToBounds = YES;
    }
    
    //更新searchbar高度  因为苹果经常会改变
    [_searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(searchField.height);
    }];
    [_searchBar updateConstraints];
    
    QMUIButton *cancel = [[QMUIButton alloc]init];
    [cancel setTitle:@"取消" forState:0];
    [cancel setTitleColor:[UIColor whiteColor] forState:0];
    cancel.titleLabel.font = ZWHFont(15);
    [navView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView).offset(-WIDTH_PRO(15));
        make.centerY.equalTo(_searchBar);
    }];
    [cancel addTarget:self action:@selector(cancelWith:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 取消搜索
-(void)cancelWith:(QMUIButton *)btn{
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - uitabledelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMUITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.textLabel.text = _keywords[indexPath.row];
    return cell;
}


#pragma mark - getter
-(UIView *)qdRecentSearchView{
    if (!_qdRecentSearchView) {
        _qdRecentSearchView = [[UIView alloc]init];
        _qdRecentSearchView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
        self.titleLabel.text = @"最近搜索";
        self.titleLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        [self.titleLabel sizeToFit];
        self.titleLabel.qmui_borderPosition = QMUIViewBorderPositionBottom;
        [_qdRecentSearchView addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_qdRecentSearchView).offset(WIDTH_PRO(8));
            make.top.equalTo(_qdRecentSearchView).offset(HEIGHT_PRO(15));
            make.right.equalTo(_qdRecentSearchView).offset(-WIDTH_PRO(8));
        }];
        
        self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
        self.floatLayoutView.padding = UIEdgeInsetsZero;
        self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);
        [_qdRecentSearchView addSubview:self.floatLayoutView];
        [self.floatLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_qdRecentSearchView).offset(WIDTH_PRO(8));
            make.top.equalTo(_titleLabel.mas_bottom).offset(HEIGHT_PRO(15));
            make.right.equalTo(_qdRecentSearchView).offset(-WIDTH_PRO(8));
            make.bottom.equalTo(_qdRecentSearchView).offset(-HEIGHT_PRO(15));
        }];
        
        for (NSInteger i = 0; i < self.keywords.count; i++) {
            QMUIGhostButton *button = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorGray];
            [button setTitle:self.keywords[i] forState:UIControlStateNormal];
            button.titleLabel.font = UIFontMake(14);
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
            [self.floatLayoutView addSubview:button];
        }
    }
    return _qdRecentSearchView;
}

#pragma mark - search delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    switch (_state) {
        case 0:
        {
//            [self.navigationController popViewControllerAnimated:YES];
//            if (_contextBlock) {
//                _contextBlock(searchBar.text);
//            }
            //在线取单
            ZWHOrderOnlineViewController *comm=[[ZWHOrderOnlineViewController alloc]init];
            comm.searchStr = searchBar.text;
            [self.navigationController pushViewController:comm animated:YES];
            
        }
            break;
        default:
            break;
    }
}







@end
