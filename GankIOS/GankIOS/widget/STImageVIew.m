//
//  STImageVIew.m
//  STPhotoBroeser
//
//  Created by StriEver on 16/3/15.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "STImageVIew.h"
#import "UIView+Extension.h"
@interface STImageVIew()<UIGestureRecognizerDelegate>{
    CGFloat _lastScale;//记录最后一次的图片放大倍数
}
/**手机屏幕高度不够用的时候 用于显示完整图片*/
@property (nonatomic, strong) UIScrollView * scrollView;
/**完整图片*/
@property (nonatomic, strong) UIImageView * scrollImgV;
/**用于放大 缩小 图片的scrollview*/
@property (nonatomic, strong) UIScrollView * scaleScrollView;
/**用于显示 放大缩小的 图片*/
@property (nonatomic, strong) UIImageView * scaleImgV;
@property (nonatomic, assign) BOOL doubleAction;
@end
@implementation STImageVIew
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIPinchGestureRecognizer * ges = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageViewAction:)];
        ges.delegate = self;
        _lastScale = 1.f;
        [self addGestureRecognizer:ges];
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClick:)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}
//getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIImageView *)scrollImgV{
    if (!_scrollImgV) {
        _scrollImgV = [[UIImageView alloc]init];
        _scrollImgV.image = self.image;
        [self.scrollView addSubview:_scrollImgV];
    }
    return _scrollImgV;
}
- (UIScrollView *)scaleScrollView{
    if (!_scaleScrollView) {
        _scaleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scaleScrollView.bounces = NO;
        _scaleScrollView.backgroundColor = [UIColor blackColor];
        _scaleScrollView.contentSize =  self.bounds.size;
        [self addSubview:_scaleScrollView];
    }
    return _scaleScrollView;
}
- (UIImageView *)scaleImgV{
    if (!_scaleImgV) {
        _scaleImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scaleImgV.image = self.image;
        [self.scaleScrollView addSubview:_scaleImgV];
    }
    return _scaleImgV;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize imageSize = self.image.size;
    //图片高度大于屏幕高度
    if (self.width * (imageSize.height / imageSize.width) > self.height) {
        [self scrollView];
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.width * (imageSize.height / imageSize.width));
        self.scrollImgV.center = self.scrollView.center;
        self.scrollImgV.bounds = CGRectMake(0, 0, imageSize.width, self.width * (imageSize.height / imageSize.width));
    }else{
        if (_scrollView)[_scrollView removeFromSuperview];
    }
    
}
#pragma mark ---action
-(void)scaleImageViewAction:(UIPinchGestureRecognizer*)sender {
    
    CGFloat scale = sender.scale;//得到的是当前手势放大倍数
    NSLog(@"--------%f",scale);
    CGFloat shouldScale = _lastScale + (scale - 1);//我们需要知道的是当前手势相收缩率对于刚才手势的相对收缩 scale - 1，然后加上最后一次收缩率，为当前要展示的收缩率
    [self setScaleImageWithScale:shouldScale];
    sender.scale = 1.0;//图片大小改变后设置手势scale为1
}
- (void)setScaleImageWithScale:(CGFloat)scale{
    //最大2倍最小.5
    if (scale >=2) {
        scale = 2;
    }else if(scale <=.5){
        scale = .5;
    }
    _lastScale = scale;
    self.scaleImgV.transform = CGAffineTransformMakeScale(scale, scale);
    if (scale > 1) {
        CGFloat imageWidth = self.scaleImgV.width;
        CGFloat imageHeight =  MAX(self.scaleImgV.height, self.frame.size.height);
        [self bringSubviewToFront:self.scaleScrollView];
        self.scaleImgV.center = CGPointMake(imageWidth * 0.5, imageHeight * 0.5);
        self.scaleScrollView.contentSize = CGSizeMake(imageWidth, imageHeight);
        CGPoint offset = self.scaleScrollView.contentOffset;
        offset.x = (imageWidth - self.width)/2.0;
        offset.y = (imageHeight - self.height)/2.0;
        self.scaleScrollView.contentOffset = offset;
    }else{
        self.scaleImgV.center = self.scaleScrollView.center;
        self.scaleScrollView.contentSize = CGSizeZero;
        
    }
}
- (void)singleClick:(UITapGestureRecognizer *)tap{
    if (_delegate &&[_delegate respondsToSelector:@selector(stImageVIewSingleClick:)]) {
        [_delegate stImageVIewSingleClick:self];
    }
}

- (void)doubleClick:(UITapGestureRecognizer *)tap{
    if (_lastScale > 1) {
        _lastScale = 1;
        
    }else{
        _lastScale = 2;
    }
    [UIView animateWithDuration:.5 animations:^{
         [self setScaleImageWithScale:_lastScale];
        
    }completion:^(BOOL finished) {
        if (_lastScale == 1) {
            [self resetView];
        }
    }];
   
}
//当达到原图大小 清除 放大的图片 和scrollview
- (void)resetView{
    if (!self.scaleScrollView) {
        return;
    }
    self.scaleScrollView.hidden = YES;
    [self.scaleScrollView removeFromSuperview];
    self.scaleScrollView = nil;
    self.scaleImgV = nil;
}
@end
