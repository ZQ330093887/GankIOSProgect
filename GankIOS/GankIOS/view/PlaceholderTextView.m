//
//  PlaceholderTextView.m
//  GankIOS
//
//  Created by 周琼 on 2018/11/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "PlaceholderTextView.h"

@implementation PlaceholderTextView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setPlaceholder:@""];
        
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
}

-(void)setPlaceholder:(NSString *)placeholder{
    
    if (_placeholder != placeholder) {
        
        _placeholder = placeholder;
        
        [self.placeHolderLabel removeFromSuperview];
        
        self.placeHolderLabel = nil;
        
        [self setNeedsDisplay];
        
        
    }
    
}

- (void)textChanged:(NSNotification *)notification{
    
    if ([[self placeholder] length] == 0) {
        return;
    }
    
    if ([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1.0];
    }
    
    else{
        
        [[self viewWithTag:999] setAlpha:0];
    }
    
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    if ([[self placeholder] length] > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if ([[self text] length] == 0 && [[self placeholder] length] >0) {
        [[self viewWithTag:999] setAlpha:1.0];
    }
    
}


@end
