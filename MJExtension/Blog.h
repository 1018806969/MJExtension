//
//  Blog.h
//  MJExtension
//
//  Created by txx on 17/1/4.
//  Copyright © 2017年 txx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Blog : NSObject
/** 微博文本内容 */
@property (copy, nonatomic) NSString *text;
/** 微博作者 */
@property (strong, nonatomic) User *user;
/** 转发的微博 */
@property (strong, nonatomic) Blog *forwardBlog;

@end
