//
//  ViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "MineViewController.h"
#import "HgMusicViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    /*************设置公共属性*************/
    //设置公共背景颜色
    self.view.backgroundColor = BackgroundColor;
    [super viewDidLoad];
    [self initMainController];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initMainController{
    /*************创建子控件*************/
    //首页
    HomeViewController *homeController = [[HomeViewController alloc]init];
    homeController.title = @"首页";
    [self setTabBarItem:homeController.tabBarItem
                  title:@"首页"
              titleSize:11.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"ic_nav_new_normal"
     selectedTitleColor:TintColor
            normalImage:@"ic_nav_new"
       normalTitleColor:[UIColor grayColor]];
    
    //分类
    CategoryViewController *categoryController=[[CategoryViewController alloc] init];
    categoryController.title = @"分类";
    [self setTabBarItem:categoryController.tabBarItem
                  title:@"分类"
              titleSize:11.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"ic_nav_category"
     selectedTitleColor:TintColor
            normalImage:@"ic_nav_category_normal"
       normalTitleColor:[UIColor grayColor]];
    
    //音乐
    HgMusicViewController *musicController=[[HgMusicViewController alloc] init];
    musicController.title = @"音乐";
    [self setTabBarItem:musicController.tabBarItem
                  title:@"音乐"
              titleSize:11.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"music_action"
     selectedTitleColor:TintColor
            normalImage:@"music_selected"
       normalTitleColor:[UIColor grayColor]];
    //我的
    
    MineViewController *mineConteroller = [[MineViewController alloc]init];
    mineConteroller.title = @"我的";
    [self setTabBarItem:mineConteroller.tabBarItem
                  title:@"我的"
              titleSize:11.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"ic_nav_mine"
     selectedTitleColor:TintColor
            normalImage:@"ic_nav_mine_normal"
       normalTitleColor:[UIColor grayColor]];
    
    /***********************创建Navigation******************/
    UINavigationController *homeNV = [[UINavigationController alloc] initWithRootViewController:homeController];
    UINavigationController *categoryNV = [[UINavigationController alloc] initWithRootViewController:categoryController];
    UINavigationController *musicNV = [[UINavigationController alloc] initWithRootViewController:musicController];
    UINavigationController *mineNV = [[UINavigationController alloc]initWithRootViewController:mineConteroller];
    // 把子控制器添加到UITabBarController
    self.viewControllers = @[homeNV, categoryNV, musicNV, mineNV];
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}
@end
