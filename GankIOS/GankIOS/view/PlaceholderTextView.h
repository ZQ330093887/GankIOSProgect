//
//  PlaceholderTextView.h
//  GankIOS
//
//  Created by 周琼 on 2018/11/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

- (void)textChanged:(NSNotification * )notification;
@end

NS_ASSUME_NONNULL_END
