//
//  BaseVO.h
//  GankIOS
//
//  Created by 周琼 on 2018/5/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseVO : NSObject
@property (assign, nonatomic) unsigned int count;
@property (assign, nonatomic) unsigned int error;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *updateInfo;
@end
