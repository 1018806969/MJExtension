//
//  Student.m
//  MJExtension
//
//  Created by txx on 17/1/4.
//  Copyright © 2017年 txx. All rights reserved.
//

#import "Student.h"
#import "MjExtension.h"

@implementation Student

/**
实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
                相同的不需要写，如果字典中的key为多级可以使用“.”来实现多级映射
*/
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
                @"ID" : @"id",
                @"oldName" : @"name.oldName",
                @"nowName" : @"name.newName",
                @"nameChangedTime" : @"name.info.nameChangedTime",
                @"bag" : @"other.bag"
            };
}

@end
