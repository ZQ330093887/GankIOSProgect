//
//  CommonTableViewCellView.m
//  DrawTableViewCell https://github.com/Ericfengshi/FSTableViewCell
//
//  Created by fengs on 14-9-29.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "CommonTableViewCellView.h"

@implementation CommonTableViewCellView


-(void)dealloc{
    
    self.cellViewColor = nil;
}

/*
 * init
 * @param UITableViewCell frame
 * @param keyArray : labelArray
 * @param valueArray : contentArray
 * @return id
 */
- (id)initWithFrame:(CGRect)frame keyArray:(NSArray*)keyArray;
{
    self = [super initWithFrame:frame];
    if (self) {

      
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, 300)];
    }
    return self;
}
@end
