//
//  HomeBase.h
//  GankIOS
//
//  Created by 周琼 on 2018/5/19.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeVO;
@class BuildInfoVO;

@interface HomeBase : NSObject
@property (assign, nonatomic) unsigned int error;
@property (strong, nonatomic) NSMutableArray *category;
@property (strong, nonatomic) HomeVO *results;
@end
