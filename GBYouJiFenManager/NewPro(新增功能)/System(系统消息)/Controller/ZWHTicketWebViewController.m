//
//  ZWHTicketWebViewController.m
//  FengHuaKe
//
//  Created by Syrena on 2018/9/8.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "ZWHTicketWebViewController.h"
#import <WebKit/WebKit.h>

@interface ZWHTicketWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *detailWebView;

@end

@implementation ZWHTicketWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.titleView.needsLoadingView = YES;
    self.titleView.loadingViewHidden = NO;
    [self setUI];
}

-(void)setUI{
    [self.view addSubview:self.detailWebView];
    [self.detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.detailWebView.scrollView.backgroundColor = [UIColor whiteColor];
    [self showDetail];
}


#pragma mark - 景点详情
-(void)showDetail{
    //sender.selected = !sender.selected;
//    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
//                            "<head> \n"
//                            "<style type=\"text/css\"> \n"
//                            "body {font-size:15px;}\n"
//                            "</style> \n"
//                            "</head> \n"
//                            "<body>"
//                            "<script type='text/javascript'>"
//                            "window.onload = function(){\n"
//                            "var $img = document.getElementsByTagName('img');\n"
//                            "}"
//                            "</script>%@"
//                            "</body>"
//                            "</html>",_remark];
    
    NSString *htmlString = [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@",SCREEN_WIDTH, _remark];
    [_detailWebView loadHTMLString:htmlString baseURL:nil];
    /*"for(var p in  $img){\n"
     " $img[p].style.width = '100%%';\n"
     "$img[p].style.height ='auto'\n"
     "}\n"*/
}

#pragma mark - UIWebView Delegate Methods

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.titleView.loadingViewHidden = YES;
}


/*-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [self.detailWebView stringByEvaluatingJavaScriptFromString:js];
    [self.detailWebView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    
    // 获取webView的高度
    CGFloat webViewHeight = [[self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    NSLog(@"%.f", webViewHeight);
    //self.detailWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight);
}

-(UIWebView *)detailWebView{
    if (!_detailWebView) {
        _detailWebView = [[UIWebView alloc]init];
        _detailWebView.delegate = self;
    }
    return _detailWebView;
}*/

-(WKWebView *)detailWebView{
    if (!_detailWebView) {
        _detailWebView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        _detailWebView.navigationDelegate = self;
        //_detailWebView.scrollView.contentInset = UIEdgeInsetsMake(80,0, 0, 0);
        //_detailWebView.navigationDelegate=self;
        //[_detailWebView.scrollView addSubview:self.webHeaderView];
//        [_detailWebView loadHTMLString:self.catageModel.content baseURL:nil];
//        [_detailWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    return _detailWebView;
}



@end
