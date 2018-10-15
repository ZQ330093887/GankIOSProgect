//
//  BaseViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/29.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

// 屏幕宽
#define selfWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高
#define selfHeigh   [UIScreen mainScreen].bounds.size.height


@interface BaseViewController ()

//  加载  等待 动画
@property (nonatomic, strong)MBProgressHUD *HUD;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

//toast提示
-(void)showAllTextDialog:(NSString *)sender{
    _HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:_HUD];
    [_HUD setMode:MBProgressHUDModeText];
    _HUD.label.text = sender;
    _HUD.bezelView.color = [UIColor blackColor];
    _HUD.label.textColor = [UIColor whiteColor];
    _HUD.minSize = CGSizeMake(130, 20);
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(3);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        _HUD = nil;
    }];
}

//显示进度条
-(void)showTextDialog:(NSString *)sender{
    _HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:_HUD];
    _HUD.bezelView.color = [UIColor blackColor];
    _HUD.bezelView.color = [_HUD.bezelView.color colorWithAlphaComponent:1];
    //3,设置背景框的圆角值，默认是10
    _HUD.bezelView.layer.cornerRadius = 10.0;
    //6，设置菊花颜色  只能设置菊花的颜色
    _HUD.activityIndicatorColor = [UIColor whiteColor];
    _HUD.margin = 15;
    _HUD.label.text = sender;
    _HUD.label.textColor = [UIColor whiteColor];
    //11，背景框的最小大小
    _HUD.minSize = CGSizeMake(100, 100);
    //13,是否强制背景框宽高相等
    _HUD.square = YES;
    //14,设置显示和隐藏动画类型  有三种动画效果，如下
    _HUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退
    _HUD.removeFromSuperViewOnHide = NO;
    [_HUD showAnimated:YES];
}
//隐藏进度条
-(void) hideTextDialog{
    [_HUD hideAnimated:YES];
    [_HUD removeFromSuperview];
}

//创建刷新
-(void) createTableViewRefresh{
    //刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.loadingData(YES);
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //设置状态
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"数据加载中" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    self.mainTableView.mj_header = header;
    //加载
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.loadingData(NO);
    }];
}

//停止刷新
-(void)endTableViewRefresh{
  
    if (self.page ==1) {
        [self.mainTableView.mj_header endRefreshing];
    }
    [self.mainTableView.mj_footer endRefreshing];
    //隐藏dialog
    [self hideTextDialog];
}


-(void) createCollRefresh{
    //刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        self.loadingData(YES);
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //设置状态
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"数据加载中" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;

    //加载
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.loadingData(NO);
    }];
}

-(void) endCollRefresh{
    if (self.page ==1) {
        [self.collectionView.mj_header endRefreshing];
    }
    [self.collectionView.mj_footer endRefreshing];
    //隐藏dialog
    [self hideTextDialog];
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

- (void)showTabBar {
    if (self.tabBarController.tabBar.hidden == NO){
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]){
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    }
    self.tabBarController.tabBar.hidden = NO;
}

- (void) addLeftButton{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _mTitle;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
}

//返回按钮点击事件
- (void)selectRightAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//懒加载
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -90, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        [self.view addSubview:_mainTableView];
        
    }
    return _mainTableView;
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15.f;
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 15*3)/2, 210);
        
        //创建UICollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);

        _collectionView.scrollsToTop = NO;
        //开启分页
        _collectionView.pagingEnabled = YES;
        //不显示滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.alwaysBounceVertical = YES;
        //弹簧效果设置
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

//这里对网络请求做简单的封装，
-(void)GetRequsetDataUrlString:(NSString *)urlStr Parameters:(NSDictionary *)dic{
    __weak typeof(self) WeakSelf = self;
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前进去");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功数据=%@",responseObject);
        
        WeakSelf.GetSuccess(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了=%@",error);
        //[self.HUD hideAnimated:YES];
        [self showAllTextDialog:@"数据加载失败"];
        [self endCollRefresh];
        [self endTableViewRefresh];
    }];
}

/******************缓存读写***********************************/


// 写缓存
- (void)writeLocalCacheData:(NSData *)data withKey:(NSString *)key {
    // 设置存储路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    NSLog(@"存储路径%@",cachesPath);
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {//存在
        // 删除旧的缓存数据
        NSLog(@"缓存数据存在");
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
        //写入缓存数据
        [data writeToFile:cachesPath atomically:YES];
    }else{//不存在的情况下创建，返回值为是否创建成功
        BOOL res=[[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {//创建成功之后写入缓存
            NSLog(@"创建成功");
            //写入缓存数据
            [data writeToFile:cachesPath atomically:YES];
        }
    }
    NSLog(@"缓存数据完成");
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 删除旧的缓存数据
        NSLog(@"缓存成功");
    }
}

// 读缓存
- (NSData *)readLocalCacheDataWithKey:(NSString *)key {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 读取缓存数据
        return [NSData dataWithContentsOfFile:cachesPath];
    }
    return nil;
}

// 删缓存
- (void)deleteLocalCacheDataWithKey:(NSString *)key {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 删除缓存数据
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
