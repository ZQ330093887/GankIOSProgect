//
//  MineViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/10.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "MineViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "PushGankViewController.h"
#import "WYWebController.h"
#import "CategoryListViewController.h"
#import "CategoryWelfareViewController.h"
#import "SearchController.h"
#import "BuildUpdateViewController.h"
#import "ShareMenuView.h"
#import "Masonry.h"
@interface MineViewController ()
@property(nonatomic,strong)NSArray *apps;
@property(nonatomic,strong)NSArray *ts;
@property(nonatomic,strong) NSArray<NSString *> *pictures;
@property(nonatomic,strong) NSArray<NSString *> *titlePic;
@end

static NSString* const cellID = @"cellID";

@implementation MineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarItem];
    [self loadImage];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
}

/**********导航部分***********/
-(void) initBarItem{
    //导航栏右边添加图片
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_search"] style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_add"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    //设置导航栏的背景
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = TintColor;
}

/** 加载图片(本地) */
- (void)loadImage {
    NSMutableArray *picArray = [NSMutableArray array];
     NSMutableArray *tp = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        NSString *imageName = [NSString stringWithFormat:@"category_%d",i];
        [picArray addObject:imageName];
    }
   
    for (int j = 9; j < 13; j++) {
        NSString *imageName = [NSString stringWithFormat:@"category_%d",j];
        [tp addObject:imageName];
    }
    _pictures = picArray.copy;
    
   
    _titlePic = tp.copy;
    
    _ts = @[@"干货推荐",@"感谢编辑",@"版本更新",@"关于作者"];
    
}
//1.加载数据
- (NSArray *)apps{
    if (!_apps) {
        _apps=@[@"all",@"iOS",@"Android",@"前端",@"瞎推荐",@"拓展资源",@"App",@"休息视频",@"福利"];
    }
    return _apps;
}


/*************正文****************/
- (void) initView{
    
    self.view.backgroundColor = PullDownColor;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    // 设置内容大小
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    // 是否反弹
    scrollView.bounces = YES;
    // 是否滚动
    scrollView.scrollEnabled = YES;
    //是否显示滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    
    UIView * titleV = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 80)];
    titleV.backgroundColor = PullDownColor;
    titleV.layer.cornerRadius = 10;
    //头部view添加点击事件
    UITapGestureRecognizer *gRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [titleV addGestureRecognizer:gRecognizer];
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    //设置圆角
    imgLogo.layer.cornerRadius = 25;
    //将多余的部分切掉
    imgLogo.layer.masksToBounds = YES;
    
    UILabel *  _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"用 Github登录";
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:21];
    
    UILabel *  _titleContent = [[UILabel alloc] init];
    _titleContent.textAlignment = NSTextAlignmentLeft;
    _titleContent.textColor = AdTitleColor3;
    _titleContent.text = @"登录后可提交干货";
    _titleContent.numberOfLines = 0;
    _titleContent.font = [UIFont systemFontOfSize:14];
    
    UIView *viewType = [[UIView alloc]init];
    UIView *flutter = [[UIView alloc]init];
    UIView *ios = [[UIView alloc]init];
    UIView *android = [[UIView alloc]init];
    UIView *wx = [[UIView alloc]init];
    UIView *line = [[UIView alloc]init];
    UIView *line2 = [[UIView alloc]init];
    UIView *line3 = [[UIView alloc]init];
    UIView *line4 = [[UIView alloc]init];
    UIView *line5 = [[UIView alloc]init];
    
    UILabel *  countFlutter = [[UILabel alloc] init];
    countFlutter.textAlignment = NSTextAlignmentLeft;
    countFlutter.textColor = AdTitleColor3;
    countFlutter.text = @"0";
    countFlutter.numberOfLines = 0;
    countFlutter.font = [UIFont systemFontOfSize:16];
    
    UILabel *  titleFlutter = [[UILabel alloc] init];
    titleFlutter.textAlignment = NSTextAlignmentLeft;
    titleFlutter.textColor = AdTitleColor3;
    titleFlutter.text = @"Flutter 版";
    titleFlutter.numberOfLines = 0;
    titleFlutter.font = [UIFont systemFontOfSize:14];
    
    UILabel *  countWX = [[UILabel alloc] init];
    countWX.textAlignment = NSTextAlignmentLeft;
    countWX.textColor = AdTitleColor3;
    countWX.text = @"17";
    countWX.numberOfLines = 0;
    countWX.font = [UIFont systemFontOfSize:16];
    
    UILabel *  titleWX = [[UILabel alloc] init];
    titleWX.textAlignment = NSTextAlignmentLeft;
    titleWX.textColor = AdTitleColor3;
    titleWX.text = @"小程序 版";
    titleWX.numberOfLines = 0;
    titleWX.font = [UIFont systemFontOfSize:14];
    
    UILabel *  countAndroid = [[UILabel alloc] init];
    countAndroid.textAlignment = NSTextAlignmentLeft;
    countAndroid.textColor = AdTitleColor3;
    countAndroid.text = @"218";
    countAndroid.numberOfLines = 0;
    countAndroid.font = [UIFont systemFontOfSize:16];
    
    UILabel *  titleAndroid = [[UILabel alloc] init];
    titleAndroid.textAlignment = NSTextAlignmentLeft;
    titleAndroid.textColor = AdTitleColor3;
    titleAndroid.text = @"android 版";
    titleAndroid.numberOfLines = 0;
    titleAndroid.font = [UIFont systemFontOfSize:14];
    
    UILabel *  countIos = [[UILabel alloc] init];
    countIos.textAlignment = NSTextAlignmentLeft;
    countIos.textColor = AdTitleColor3;
    countIos.text = @"33";
    countIos.numberOfLines = 0;
    countIos.font = [UIFont systemFontOfSize:16];
    
    UILabel *  titleIos = [[UILabel alloc] init];
    titleIos.textAlignment = NSTextAlignmentLeft;
    titleIos.textColor = AdTitleColor3;
    titleIos.text = @"iOS 版";
    titleIos.numberOfLines = 0;
    titleIos.font = [UIFont systemFontOfSize:14];
    
    line.backgroundColor = PullDownColor;
    line2.backgroundColor = PullDownColor;
    line3.backgroundColor = PullDownColor;
    line4.backgroundColor = PullDownColor;
    line5.backgroundColor = PullDownColor;
    
    /** 九宫格形式添加图片 */
    [self addPictures:scrollView marHeight:200 scHeight:70 scWidth:SCREEN_WIDTH/3 colCount:3 imageArray:_pictures titleArray:self.apps];
    
    [self addPictures:scrollView marHeight:450 scHeight:70 scWidth:SCREEN_WIDTH/4 colCount:4 imageArray:_titlePic titleArray:_ts];
    
    [titleV addSubview:_titleContent];
    [titleV addSubview:_titleLabel];
    [titleV addSubview:imgLogo];
    
    [viewType addSubview:line];
    [viewType addSubview:line2];
    [viewType addSubview:line3];
    
    [flutter addSubview:countFlutter];
    [flutter addSubview:titleFlutter];
    
    [wx addSubview:countWX];
    [wx addSubview:titleWX];
    
    [android addSubview:countAndroid];
    [android addSubview:titleAndroid];
    
    [ios addSubview:countIos];
    [ios addSubview:titleIos];
    
    [viewType addSubview:flutter];
    [viewType addSubview:android];
    [viewType addSubview:ios];
    [viewType addSubview:wx];
    
    [scrollView addSubview:titleV];
    [scrollView addSubview:viewType];
    [scrollView addSubview:line4];
    [scrollView addSubview:line5];

    [self.view addSubview:scrollView];
    
    
    [imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.updateExisting = YES;
        make.width.height.offset(50);
        make.left.equalTo(titleV).offset(40);
        make.centerY.equalTo(titleV.mas_centerY);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(titleV.mas_right);
        make.top.equalTo(titleV.mas_top).offset(15);
        make.left.equalTo(imgLogo.mas_right).offset(20);
    }];

    [_titleContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.equalTo(imgLogo.mas_right).offset(20);
    }];

    [viewType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleV.mas_bottom).offset(5);
        make.height.offset(80);
        make.width.offset(SCREEN_WIDTH);
    }];
    
    [flutter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH/4-1);
        make.height.offset(80);
        make.top.equalTo(viewType.mas_top);
    }];
    
    [countFlutter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(flutter);
        make.top.equalTo(flutter.mas_top).offset(15);
    }];

    [titleFlutter mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(flutter);
        make.top.equalTo(countFlutter.mas_bottom).offset(5);
    }];
    
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.height.offset(15);
        make.top.equalTo(titleV.mas_bottom).offset(45);
        make.left.equalTo(flutter.mas_right);
    }];
    
    [wx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH/4-2);
        make.height.offset(80);
        make.top.equalTo(titleV.mas_bottom).offset(5);
        make.left.equalTo(line.mas_right);
    }];
    
    [countWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wx);
        make.top.equalTo(wx.mas_top).offset(15);
    }];
    
    [titleWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wx);
        make.top.equalTo(countWX.mas_bottom).offset(5);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.height.offset(15);
        make.top.equalTo(titleV.mas_bottom).offset(45);
        make.left.equalTo(wx.mas_right);
    }];
    [android mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH/4-2);
        make.height.offset(80);
        make.top.equalTo(titleV.mas_bottom).offset(5);
        make.left.equalTo(line2.mas_right);
    }];
    
    [countAndroid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(android);
        make.top.equalTo(android.mas_top).offset(15);
    }];
    
    [titleAndroid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(android);
        make.top.equalTo(countAndroid.mas_bottom).offset(5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.height.offset(15);
        make.top.equalTo(titleV.mas_bottom).offset(45);
        make.left.equalTo(android.mas_right);
    }];
    [ios mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH/4-2);
        make.height.offset(80);
        make.top.equalTo(titleV.mas_bottom).offset(5);
        make.left.equalTo(line3.mas_right);
    }];
    
    [countIos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ios);
        make.top.equalTo(ios.mas_top).offset(15);
    }];
    
    [titleIos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ios);
        make.top.equalTo(countIos.mas_bottom).offset(5);
    }];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(10);
        make.top.equalTo(viewType.mas_bottom);
    }];
    
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(10);
        make.top.equalTo(viewType.mas_top).offset(330);
    }];
    
    flutter.mas_key = @"https://github.com/ZQ330093887/GankFlutter";
    [self initGesture:flutter action:@selector(startViewController:)];
    
    wx.mas_key = @"https://github.com/ZQ330093887/GankWX";
    [self initGesture:wx action:@selector(startViewController:)];
    
    android.mas_key = @"https://github.com/ZQ330093887/ConurbationsAndroid";
    [self initGesture:android action:@selector(startViewController:)];
    
    ios.mas_key = @"https://github.com/ZQ330093887/GankIOSProgect";
    [self initGesture:ios action:@selector(startViewController:)];
}

- (void)addPictures:(UIScrollView*) scrollView marHeight:(int) mh scHeight:(int) height scWidth:(int) width colCount:(int) cc imageArray:(NSArray*)imgArray
 titleArray:(NSArray*)titleArray{
    
//    CGFloat margin=(self.view.frame.size.width-COL_COUNT*PIC_HEIGHT)/(COL_COUNT+1);
    NSUInteger count= titleArray.count;
    for (int i=0; i<count; i++) {
        int row=i/cc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%cc;//列号
        // PointX
        CGFloat appviewx=(1+width)*loc;
        // PointY
        CGFloat appviewy=(5+height)*row;
        
        //创建uiview控件
        UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx, appviewy+mh, width, height)];
//        [appview setBackgroundColor:[UIColor purpleColor]];
//        appview.tag = i;
        [appview setMas_key:titleArray[i]];
        [scrollView addSubview:appview];
        
        
        //创建uiview控件中的子视图
        UIImageView *appimageview=[[UIImageView alloc]initWithFrame:CGRectMake(appview.frame.size.width/2-width/2, 0, width, 40)];
        UIImage *appimage=[UIImage imageNamed:imgArray[i]];
        appimageview.image=appimage;
        [appimageview setContentMode:UIViewContentModeScaleAspectFit];
        [appview addSubview:appimageview];
        
        //创建文本标签
        UILabel *applable=[[UILabel alloc]initWithFrame:CGRectMake(appview.frame.size.width/2-45, 45, 90, 20)];
        [applable setText:titleArray[i]];
        [applable setTextAlignment:NSTextAlignmentCenter];
        [applable setFont:[UIFont systemFontOfSize:14.0]];
        [appview addSubview:applable];
        
        [self initGesture:appview action:@selector(clickItem:)];
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItem:)];
//        [appview addGestureRecognizer:gesture];
    }
}

//头部点击事件方法
-(void)tapAction:(id)tap{
    [self startLoginVC];
}

-(CATransition *) getTranstion{
    CATransition *animation =[[CATransition alloc]init];
    animation.duration = 0.5;
    //animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    return animation;
}
//顶部导航栏添加按钮
-(void)selectRightAction:(id)sender{
    [self startLoginVC];
}

- (void) initGesture:(UIView*) v action:(nullable SEL)action{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [v addGestureRecognizer:gesture];
}

//启动loginvc
- (void)startLoginVC{
    LoginViewController *loginConteroller = [[LoginViewController alloc]init];
    [self.view.window.layer addAnimation:[self getTranstion] forKey:nil];
    [self presentViewController:loginConteroller animated:NO completion:nil];
}

-(void)clickItem:(UITapGestureRecognizer *) gesture{
    NSString * title = gesture.view.mas_key;
    NSLog(@"=======>%@",title);

    CategoryListViewController *cList = [[CategoryListViewController alloc] init];
    CategoryWelfareViewController *wList = [[CategoryWelfareViewController alloc]init];
    cList.mTitle = title;
    wList.mTitle  =title;
    if ([title isEqualToString:@"福利"]) {
        [self.navigationController pushViewController:wList animated:YES];
    } else if ([title isEqualToString:@"干货推荐"]){
        PushGankViewController *pg = [[PushGankViewController alloc]init];
        pg.mTitle = title;
        [self.navigationController pushViewController:pg animated:YES];
    }else if ([title isEqualToString:@"版本更新"]){
        BuildUpdateViewController *updateBd = [[BuildUpdateViewController alloc]init];
        updateBd.mTitle = title;
        [self.navigationController pushViewController:updateBd animated:YES];
    }else if([title isEqualToString:@"感谢编辑"]){
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"http://gank.io";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([title isEqualToString:@"关于作者"]){
        WYWebController *webVC = [WYWebController new];
        webVC.url = @"https://www.jianshu.com/u/9681f3bbb8c2";
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        [self.navigationController pushViewController:cList animated:YES];
    }
}

/**
 启动网页
 */
- (void) startViewController:(UITapGestureRecognizer *) gesture{
    NSString *url = gesture.view.mas_key;
    WYWebController *webVC = [WYWebController new];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
