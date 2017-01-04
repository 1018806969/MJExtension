//
//  ViewController.m
//  MJExtension
//
//  Created by txx on 17/1/4.
//  Copyright © 2017年 txx. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "User.h"
#import "Blog.h"
#import "List.h"

#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.最简单的字典转模型
    [self simpleUse_transportDictionaryToModel];
    
    //2.模型中嵌套模型
    [self handleModelHaveChildModel];
    
    //3.模型中有个数组属性，数组里面又要装着其它模型,需要在模型中告诉MJExtension框架blogs和ads数组里面装的是什么模型
    [self modelHaveArrayPropertyWithModel];
    
    //4.模型中的属性名和字典中的key不相同(或者需要多级映射),需要在模型中告诉MJExtension框架模型中的属性名对应着字典的哪个key
    [self modelPropertyNameDifferentToDictionaryKey];
    
    //5.将一个模型转成字典
    [self transportModelToDictionary];
}
-(void)simpleUse_transportDictionaryToModel
{
    NSArray *users = @[@{
                            @"name" : @"Jane",
                            @"icon" : @"jane.png",
                            @"age" : @20,
                            @"height" : @"1.65",
                            @"money" : @1000.9,
                            @"sex" : @(USexFemale)
                        },
                        @{
                            @"name" : @"Jack",
                            @"icon" : @"jack.png",
                            @"age" : @20,
                            @"height" : @"1.80",
                            @"money" : @1000000.9,
                            @"sex" : @(USexMale)
                        }];
    //方法1
    NSMutableArray *userModels = [NSMutableArray arrayWithCapacity:users.count];
    for (NSDictionary *userDictionary in users) {
        //最简单的字典转模型
        User *userModel = [User mj_objectWithKeyValues:userDictionary];
        [userModels addObject:userModel];
        NSLog(@"method1\n--func=%s--name=%@,icon=%@,sex=%ld",__func__,userModel.name,userModel.icon,(long)userModel.sex);
    }
    //方法2
    NSMutableArray *userModels1 = [User mj_objectArrayWithKeyValuesArray:users];
    for (User *userModel1 in userModels1) {
        NSLog(@"mothod2\n--func=%s--name=%@,icon=%@,sex=%ld",__func__,userModel1.name,userModel1.icon,(long)userModel1.sex);
    }
}
-(void)handleModelHaveChildModel
{
    NSArray *blogs = @[@{
                           @"text" : @"是啊，今天天气确实不错！",
                           @"user" : @{
                                          @"name" : @"Jack",
                                          @"icon" : @"lufy.png"
                                      },
                           @"forwardBlog" : @{
                                                 @"text" : @"今天天气真不错！",
                                                 @"user" : @{
                                                                 @"name" : @"Rose",
                                                                 @"icon" : @"nami.png"
                                                            }
                                             }
                         },
                        @{
                           @"text" : @"你是个好人",
                           @"user" : @{
                                           @"name" : @"mali",
                                           @"icon" : @"mali.png"
                                      },
                           @"forwardBlog" : @{
                                                   @"text" : @"今天救了个人",
                                                   @"user" : @{
                                                                   @"name" : @"tang",
                                                                   @"icon" : @"tang.png"
                                                              }
                                             }
                           }];
    
    NSMutableArray *blogModels = [NSMutableArray arrayWithCapacity:blogs.count];
    for (NSDictionary *blogDictionary in blogs) {
        //模型中嵌套模型
        Blog *blogModel = [Blog mj_objectWithKeyValues:blogDictionary];
        [blogModels addObject:blogModel];
        NSLog(@"\n--func=%s,\ntext=%@,user.name=%@,forward text=%@,forward user name=%@",__func__,blogModel.text,blogModel.user.name,blogModel.forwardBlog.text,blogModel.forwardBlog.user.name);
    }
}
-(void)modelHaveArrayPropertyWithModel
{
    NSDictionary *list = @{
                           @"blogs" : @[
                                   @{
                                       @"text" : @"今天天气真不错！",
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"明天去旅游了",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               }
                                       }
                                   
                                   ],
                           @"ads" :@[
                                   @{
                                       @"image" : @"ad01.png",
                                       @"url" : @"http://www.ad01.com"                                                          
                                       }, 
                                   
                                   @{                               
                                       @"image" : @"ad02.png",                                   
                                       @"url" : @"http://www.ad02.com"                           
                                       }                       
                                   ],                       
                           @"totalNumber" : @"2017"                    
                           };

    List *model = [List mj_objectWithKeyValues:list];
    NSLog(@"\nfunc=%s,model.number=%@,model.ads=%@,model.blog=%@",__func__,model.totalNumber,model.ads,model.blogs);
    
    
}
-(void)modelPropertyNameDifferentToDictionaryKey
{
    NSDictionary *info = @{
                           @"id" : @"20",
                           @"desc" : @"孩子",
                           @"name" : @{
                                   @"newName" : @"lufy",
                                   @"oldName" : @"kitty",
                                   @"info" : @{
                                           @"nameChangedTime" : @"2013-08"
                                           }
                                   },
                           @"other" : @{
                                   @"bag" : @{
                                           @"name" : @"小书包",
                                           @"price" : @100.7
                                           }
                                   }
                           };
    Student *student = [Student mj_objectWithKeyValues:info];
    NSLog(@"\nfunc=%s,student.desc=%@,student.oldName=%@,student.bag.price=%f",__func__,student.desc,student.oldName,student.bag.price);
}
-(void)transportModelToDictionary
{
    //普通转换
    User *user = [User new];
    user.name = @"mozixi";
    user.icon = @"mozixi.png";
    
    Blog *blog = [Blog new];
    blog.text = @"今天天气不错";
    blog.user = user ;
    
    NSDictionary *info = blog.mj_keyValues;
    NSLog(@"func=%s,info=%@",__func__,info);
    
    //多级映射，需要在模型中告诉MJExtension框架模型中的属性名对应着字典的哪个key
    Bag *bag = [[Bag alloc] init];
    bag.name = @"小书包";
    bag.price = 205;
    
    Student *stu = [[Student alloc] init];
    stu.ID = @"123";
    stu.oldName = @"rose";
    stu.nowName = @"jack";
    stu.desc = @"handsome";
    stu.nameChangedTime = @"2018-09-08";
    stu.bag = bag;
    NSDictionary *stuInfo = stu.mj_keyValues;
    NSLog(@"func=%s,info=%@",__func__,stuInfo);
    
    //模型数组转化为字典数组
    User *user1 = [[User alloc] init];
    user1.name = @"Jack";
    user1.icon = @"lufy.png";
    
    User *user2 = [[User alloc] init];
    user2.name = @"Rose";
    user2.icon = @"nami.png";
    
    NSArray *users = @[user1, user2];
    //方法1
    NSMutableArray *dics = [NSMutableArray array];
    for (User *user in users) {
        NSDictionary *dic = user.mj_keyValues;
        [dics addObject:dic];
        
    }
    NSLog(@"method1%s,dics=%@",__func__,dics);
    
    //方法2
    NSMutableArray *dics1 = [User mj_keyValuesArrayWithObjectArray:users];
    NSLog(@"method2%s,dics=%@",__func__,dics1);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
