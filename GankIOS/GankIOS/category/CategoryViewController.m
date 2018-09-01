//
//  CategoryViewController.m
//  分类界面
//
//  Created by 周琼 on 2018/5/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryListViewController.h"
#import "CategoryWelfareViewController.h"
#import "SearchController.h"
#import "JXCategoryTitleView.h"
#import "CategoryListViewController.h"
#import "JXCategoryLineStyleView.h"


@interface CategoryViewController ()
@property (nonatomic, strong) NSArray *titles;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
     _titles = @[@"福利",@"all", @"iOS", @"Android", @"前端", @"瞎推荐", @"拓展资源", @"App", @"休息视频"];
    [super viewDidLoad];
    [self initBarItem];
    [self addPictures];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

//顶部导航栏
-(void) initBarItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    //设置导航栏的背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

/** 设置导航栏 */
- (void)addPictures {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.categoryView.titles = self.titles;

    CGFloat naviHeight = 64;
    if (@available(iOS 11.0, *)) {
        if (WindowsSize.height == 812) {
            naviHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44;
        }
    }

    NSUInteger count = [self preferredListViewCount];
    CGFloat categoryViewHeight = [self preferredCategoryViewHeight];
    CGFloat width = WindowsSize.width;
    CGFloat height = WindowsSize.height - naviHeight - categoryViewHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryViewHeight, width, height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(width*count, height);
    [self.view addSubview:self.scrollView];

    for (int i = 0; i < count; i ++) {
        NSString * title = _titles[i];
        if ([title isEqualToString:@"福利"]) {
            CategoryWelfareViewController *welfateVC = [[CategoryWelfareViewController alloc] init];
             welfateVC.mTitle = title;
            [self addChildViewController: welfateVC];
             welfateVC.view.frame = CGRectMake(i*width, 0, width, height);
            [self.scrollView addSubview: welfateVC.view];
        }else{
            CategoryListViewController *listVC = [[CategoryListViewController alloc] init];
            listVC.mTitle = title;
            [self addChildViewController:listVC];
            listVC.view.frame = CGRectMake(i*width, 0, width, height);
            [self.scrollView addSubview:listVC.view];
        }
    }

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, WindowsSize.width, categoryViewHeight)];
    _categoryView.backgroundColor = PullDownColor;
    _categoryView.titleSelectedColor = TintColor;
    _categoryView.indicatorLineViewColor = TintColor;
    _categoryView.titles = _titles;
    _categoryView.contentScrollView = self.scrollView;
    
    _categoryView.indicatorLineViewShowEnabled = YES;
    _categoryView.indicatorLineWidth = 20;
    _categoryView.lineStyle = JXCategoryLineStyle_JD;


    [self.view addSubview:self.categoryView];

}

- (Class)preferredCategoryViewClass {
    return [JXCategoryTitleView class];
}

- (NSUInteger)preferredListViewCount {
    return self.titles.count;
}

- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*index, 0) animated:YES];
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

-(void)selectRightAction:(id)sender{
    SearchController * searchCtr = [[SearchController alloc]init];
    searchCtr.mTitle = @"搜索";
    [self.navigationController pushViewController:searchCtr animated:YES];
}
@end
