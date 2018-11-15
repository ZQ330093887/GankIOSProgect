//
//  WLWebController.m
//  WangliBank
//
//  Created by 王启镰 on 16/6/21.
//  Copyright © 2016年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "WYWebController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"

@interface WYWebController ()<UIWebViewDelegate>

@end

@implementation WYWebController{
    UIWebView *_webView;
    
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = TintColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self hideTabBar];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addLeftButton{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"加载中...";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
}

- (void)selectRightAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomSpaceHeight )];
    _webView.backgroundColor = [UIColor blueColor];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    [_webView.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    NSLog(@"i am dealloc");
}

@end
