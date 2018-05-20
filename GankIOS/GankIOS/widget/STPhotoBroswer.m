//
//  ；
//  STPhotoBroeser
//
//  Created by StriEver on 16/3/16.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "STPhotoBroswer.h"
#import "STImageVIew.h"
#import "UIImageView+WebCache.h"

#define MAIN_BOUNDS   [UIScreen mainScreen].bounds
#define Screen_Width  [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
//图片距离左右 间距
#define SpaceWidth    10
@interface STPhotoBroswer ()<STImageViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * numberLabel;
@end
@implementation STPhotoBroswer
- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index{
    if (self == [super init]) {
        self.imageArray = imageArray;
        self.index = index;
        [self setUpView];
    }
    return self;
}
//--getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        //这里
        _scrollView.contentSize = CGSizeMake((Screen_Width + 2*SpaceWidth) * self.imageArray.count, Screen_Height);
        _scrollView.contentOffset = CGPointMake(Screen_Width * self.index, 0);
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        [self numberLabel];
    }
    return _scrollView;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Height-40, Screen_Width, 40)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.index +1,self.imageArray.count];
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}
- (void)setUpView{
    int index = 0;
    for (NSString *prcUrl in self.imageArray) {
        STImageVIew * imageView = [[STImageVIew alloc]init];
        imageView.delegate = self;
        [imageView sd_setImageWithURL:[NSURL URLWithString:prcUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        imageView.tag = index;
        [self.scrollView addSubview:imageView];
        index ++;
    }
}
#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/Screen_Width;
    self.index = index;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:@"STImageVIew"]) {
            STImageVIew * imageView = (STImageVIew *) obj;
            [imageView resetView];
        }
                }];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.imageArray.count];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //主要为了设置每个图片的间距，并且使 图片铺满整个屏幕，实际上就是scrollview每一页的宽度是 屏幕宽度+2*Space  居中。图片左边从每一页的 Space开始，达到间距且居中效果。
    _scrollView.bounds = CGRectMake(0, 0, Screen_Width + 2 * SpaceWidth,Screen_Height);
    _scrollView.contentOffset = CGPointMake((Screen_Width + 2*SpaceWidth) * self.index, 0);
    _scrollView.center = self.center;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(SpaceWidth + (Screen_Width+20) * idx, 0,Screen_Width,Screen_Height);
    }];
}
- (void)show{
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [window addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}
- (void)dismiss{
     self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0000000001, 0.00000001);
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
#pragma mark ---STImageViewDelegate
- (void)stImageVIewSingleClick:(STImageVIew *)imageView{
    [self dismiss];
}
@end
