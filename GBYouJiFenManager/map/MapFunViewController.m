//
//  MapFunViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MapFunViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

//#import <BaiduMapAPI_Search/BMKSearchBase.h>

//#import <BMKGeocodeSearch.h>



#import "LocationCell.h"
#import "LocationModel.h"
#define kBaiduMapMaxHeight 400
#define kCurrentLocationBtnWH 50
#define kPading 10

@interface MapFunViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
   
     BOOL isFirstLocation;
    BOOL isdeSlect;
}
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator ;
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;
@property (nonatomic,strong)BMKPoiSearch* poisearch;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,assign)CLLocationCoordinate2D currentCoordinate;
@property(nonatomic,assign)NSInteger currentSelectLocationIndex;
@property(nonatomic,strong)UIImageView *centerCallOutImageView;
@property(nonatomic,strong)UIButton *currentLocationBtn;
@end

@implementation MapFunViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    self.geocodesearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    self.geocodesearch.delegate = nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((screen_width-60)/2,(_tableView.height-60)/2, 60, 60)];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator startAnimating];
    [_tableView addSubview:self.activityIndicator];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [self configUI];
    [self setLocationWithName:@"广东省东莞市"];

    
   
}
-(void)startLocation
{
    NSLog(@"开始定位");
    self.currentSelectLocationIndex=0;
    self.currentLocationBtn.selected=YES;
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}
-(void)addRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)commit
{
    if (!_dataSource.count) {
        return;
    }
      BMKPoiInfo *poiInfo =_dataSource[self.currentSelectLocationIndex];
  
       self.backBlock([NSString stringWithFormat:@"%f",poiInfo.pt.latitude],[NSString stringWithFormat:@"%f",poiInfo.pt.longitude]);
      [self.navigationController popViewControllerAnimated:YES];
}
-(void)configUI
{
    [self addRightButton];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@kBaiduMapMaxHeight);
    }];
    
    [self.view addSubview:self.centerCallOutImageView];
    [self.view bringSubviewToFront:self.centerCallOutImageView];
    [self.centerCallOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.mapView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.mapView layoutIfNeeded];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[LocationCell class] forCellReuseIdentifier:@"LocationCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    self.currentLocationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"location_back_icon"] forState:UIControlStateNormal];
    [self.currentLocationBtn setImage:[UIImage imageNamed:@"location_blue_icon"] forState:UIControlStateSelected];
    [self.currentLocationBtn addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.currentLocationBtn];
    [self.view bringSubviewToFront:self.currentLocationBtn];
    [self.currentLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kCurrentLocationBtnWH, kCurrentLocationBtnWH));
        make.bottom.equalTo(self.mapView.mas_bottom).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    //搜索地点
    
    
}

-(void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate
{
    _currentCoordinate=currentCoordinate;

}

- (void)dealloc
{
    if (_mapView)
    {
        _mapView = nil;
    }
    if (_geocodesearch)
    {
        _geocodesearch = nil;
    }
    if (_locService)
    {
        _locService=nil;
    }
}
#pragma mark - BMKMapViewDelegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@parammapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"用户位置更新");
//    isFirstLocation=NO;
    self.currentLocationBtn.selected=NO;
    [self.mapView  updateLocationData:userLocation];
    self.currentCoordinate=userLocation.location.coordinate;
    [self startGeocodesearchWithCoordinate:self.currentCoordinate];
    if (self.currentCoordinate.latitude!=0)
    {
        [self.locService stopUserLocationService];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@parammapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@parammapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"map view: click blank");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
            NSLog(@"绘制完成");
   
            CLLocationCoordinate2D tt =[mapView convertPoint:self.centerCallOutImageView.center toCoordinateFromView:self.centerCallOutImageView];
            if (!isdeSlect) {
                NSLog(@"获得数据");
                self.currentSelectLocationIndex=0;
                self.currentCoordinate=tt;
                [self startGeocodesearchWithCoordinate:self.currentCoordinate];
            }
            
    
 
       isdeSlect=NO;
}

#pragma mark - BMKGeoCodeSearchDelegate

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */

/*-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"获取经纬度");
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
        //地图绘制
        
        BMKMapStatus *mapStatus =[self.mapView getMapStatus];
        mapStatus.targetGeoPt=item.coordinate;
        [self.mapView setMapStatus:mapStatus withAnimation:YES];
    }
}*/


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"获取经纬度");
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
    //地图绘制
      
        BMKMapStatus *mapStatus =[self.mapView getMapStatus];
        mapStatus.targetGeoPt=item.coordinate;
        [self.mapView setMapStatus:mapStatus withAnimation:YES];
    }

}
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    
        [self.activityIndicator stopAnimating];
        if (error == BMK_SEARCH_NO_ERROR)
        {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:result.poiList];
            
            if (isFirstLocation)
            {
                //把当前定位信息自定义组装 放进数组首位
                BMKPoiInfo *first =[[BMKPoiInfo alloc]init];
                first.address=result.address;
                first.name=@"[当前位置]";
                first.pt=result.location;
                first.city=result.addressDetail.city;
                [self.dataSource insertObject:first atIndex:0];
            }
            
            [self.tableView reloadData];
        }
        
  
    
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;
    
    action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)startGeocodesearchWithCoordinate:(CLLocationCoordinate2D)coordinate
{
 
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
-(void)setLocationWithName:(NSString*)name
{
    BMKGeoCodeSearchOption *geocodeSearchOption  = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city=self.city;
    geocodeSearchOption.address = [NSString stringWithFormat:@"%@%@",self.district,self.detalAdress];;
    NSLog(@"%@",self.city);
    NSLog(@"%@",self.detalAdress);
    BOOL flag = [self.geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
        [self alertShowWithStr:[NSString stringWithFormat:@"未查询到%@,已定位到当前位置",self.detalAdress]];

        [self startLocation];
    }
    
}
#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationCell*cell =[tableView dequeueReusableCellWithIdentifier:@"LocationCell" ];
    
    BMKPoiInfo *model=[self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.address;
    cell.detailTextLabel.textColor=[UIColor grayColor];
    
    if (self.currentSelectLocationIndex==indexPath.row)
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType=UITableViewCellAccessoryNone;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isdeSlect=YES;
    BMKPoiInfo *model=[self.dataSource objectAtIndex:indexPath.row];
    BMKMapStatus *mapStatus =[self.mapView getMapStatus];
    mapStatus.targetGeoPt=model.pt;
    [self.mapView setMapStatus:mapStatus withAnimation:YES];
    self.currentSelectLocationIndex=indexPath.row;
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - InitMethod

-(BMKMapView*)mapView
{
    if (_mapView==nil)
    {
        _mapView =[BMKMapView new];
//        _mapView.zoomEnabled=NO;
        _mapView.zoomEnabledWithTap=NO;
        _mapView.zoomLevel=17;
        _mapView.isSelectedAnnotationViewFront = YES;
    }
    return _mapView;
}

-(BMKLocationService*)locService
{
    if (_locService==nil)
    {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}
-(BMKGeoCodeSearch*)geocodesearch
{
    if (_geocodesearch==nil)
    {
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    }
    return _geocodesearch;
}

-(UITableView*)tableView
{
    if (_tableView==nil)
    {
        _tableView=[UITableView new];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
        
    }
    return _tableView;
}

-(UIImageView*)centerCallOutImageView
{
    if (_centerCallOutImageView==nil)
    {
        _centerCallOutImageView=[UIImageView new];
        [_centerCallOutImageView setImage:[UIImage imageNamed:@"location_green_icon"]];
    }
    return _centerCallOutImageView;
}

-(NSMutableArray*)dataSource
{
    if (_dataSource==nil) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    
    return _dataSource;
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
