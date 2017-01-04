//
//  List.m
//  MJExtension
//
//  Created by txx on 17/1/4.
//  Copyright © 2017年 txx. All rights reserved.
//

#import "List.h"
#import "MJExtension.h"

@implementation List

/**
 模型中有个数组属性，数组里面又要装着其它模型,告诉MJExtension框架blogs和ads数组里面装的是什么模型

 @return 数组中对应的模型类型
 */
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"blogs":@"Blog",
             @"ads"  :@"AD"
             };
}

@end
