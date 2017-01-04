//
//  List.h
//  MJExtension
//
//  Created by txx on 17/1/4.
//  Copyright © 2017年 txx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blog.h"
#import "AD.h"

@interface List : NSObject

/** 存放着一堆的微博数据（里面都是Status模型） */
@property (strong, nonatomic) NSMutableArray<Blog *> *blogs;
/** 存放着一堆的广告数据（里面都是Ad模型） */
@property (strong, nonatomic) NSArray <AD *>*ads;
@property (strong, nonatomic) NSNumber *totalNumber;

@end
