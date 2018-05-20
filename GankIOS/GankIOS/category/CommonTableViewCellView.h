//
//  CommonTableViewCellView.h
//  DrawTableViewCell https://github.com/Ericfengshi/FSTableViewCell
//
//  Created by fengs on 14-9-29.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>

// 传递参数自动布局UITableViewCell, 样式:  lable:Value 用法：参考viewController
@interface CommonTableViewCellView : UIView{
    UIColor *_cellViewColor;// cell颜色，保留项，需要时写个方法
    CGFloat _labelSpace;// lable宽度，保留项，需要时写个方法
    CGFloat _viewHeight;
}

@property (nonatomic,retain) UIColor *cellViewColor;
@property (nonatomic,assign) CGFloat labelSpace;
@property (nonatomic,assign) CGFloat viewHeight;

- (id)initWithFrame:(CGRect)frame keyArray:(NSArray*)keyArray;
- (void)removeUnderLine;
@end
