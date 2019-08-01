//
//  PGCustomBannerView.m
//  GankIOS
//
//  Created by 周琼 on 2019/8/1.
//  Copyright © 2019年 周琼. All rights reserved.
//

#import "PGCustomBannerView.h"

@interface PGCustomBannerView ()

@end

@implementation PGCustomBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.indexLabel];
    }
    
    return self;
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
    self.indexLabel.frame = CGRectMake(0, 10, superViewBounds.size.width, 20);
}

- (UILabel *)indexLabel {
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _indexLabel.font = [UIFont systemFontOfSize:16.0];
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}

@end
