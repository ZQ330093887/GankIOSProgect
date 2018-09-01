//
//  CategoryViewController.h
//  GankIOS
//
//  Created by 周琼 on 2018/5/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCategoryTitleView.h"

#define WindowsSize [UIScreen mainScreen].bounds.size
@interface CategoryViewController : BaseViewController

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end
