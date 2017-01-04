# MJExtension
基于runtime实现字典(JSON)与模型互转的强大工具-- MJExtension
 

MJExtension

 

世界上转换速度最快、使用最简单方便的字典转模型框架
能做什么？
MJExtension是一套字典和模型之间互相转换的超轻量级框架
MJExtension能完成的功能
字典（JSON） --> 模型（Model）、CoreData模型（Core Data Model）
JSON字符串 --> 模型（Model）、CoreData模型（Core Data Model）
模型（Model）、CoreData模型（Core Data Model） --> 字典（JSON）
字典数组（JSON Array） --> 模型数组（Model Array）、Core Data模型数组（Core Data Model Array）
JSON字符串 --> 模型数组（Model Array）、Core Data模型数组（Core Data Model Array）
模型数组（Model Array）、Core Data模型数组（Core Data Model Array） --> 字典数组（JSON Array）
只需要一行代码，就能实现模型的所有属性进行Coding（归档和解档）
详尽用法主要参考 main.m中的各个函数 以及 NSObject+MJKeyValue.h
MJExtension和JSONModel、Mantle等框架的区别
转换速率：
最近一次测试表明：MJExtension > JSONModel > Mantle
各位开发者也可以自行测试
具体用法：
JSONModel：要求所有模型类必须继承自JSONModel基类
Mantle：要求所有模型类必须继承自MTModel基类
MJExtension：不需要你的模型类继承任何特殊基类，也不需要修改任何模型代码，毫无污染，毫无侵入性
如何使用MJExtension
cocoapods导入：pod 'MJExtension'
手动导入：
将MJExtensionExample/MJExtensionExample/MJExtension文件夹中的所有源代码拽入项目中
导入主头文件：#import "MJExtension.h"
MJExtension.h
MJConst.h               MJConst.m
MJFoundation.h          MJFoundation.m
MJIvar.h                MJIvar.m
MJType.h                MJType.m
NSObject+MJCoding.h     NSObject+MJCoding.m
NSObject+MJIvar.h       NSObject+MJIvar.m
NSObject+MJKeyValue.h   NSObject+MJKeyValue.m
最简单的字典转模型
typedef enum {
    SexMale,
    SexFemale
} Sex;

@interface User : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) int age;
@property (assign, nonatomic) double height;
@property (strong, nonatomic) NSNumber *money;
@property (assign, nonatomic) Sex sex;
@end

/***********************************************/

NSDictionary *dict = @{
               @"name" : @"Jack",
               @"icon" : @"lufy.png",
               @"age" : @20,
               @"height" : @"1.55",
               @"money" : @100.9,
               @"sex" : @(SexFemale)
            };

// 将字典转为User模型
User *user = [User objectWithKeyValues:dict];

NSLog(@"name=%@, icon=%@, age=%d, height=%@, money=%@, sex=%d", 
    user.name, user.icon, user.age, user.height, user.money, user.sex);
// name=Jack, icon=lufy.png, age=20, height=1.550000, money=100.9, sex=1
核心代码

[User objectWithKeyValues:dict]
JSON字符串转模型
// 1.定义一个JSON字符串
NSString *jsonString = @"{\"name\":\"Jack\", \"icon\":\"lufy.png\", \"age\":20}";

// 2.将JSON字符串转为User模型
User *user = [User objectWithKeyValues:jsonString];

// 3.打印User模型的属性
NSLog(@"name=%@, icon=%@, age=%d", user.name, user.icon, user.age);
// name=Jack, icon=lufy.png, age=20
核心代码

[User objectWithKeyValues:dict]
模型中嵌套模型
@interface Status : NSObject
/** 微博文本内容 */
@property (copy, nonatomic) NSString *text;
/** 微博作者 */
@property (strong, nonatomic) User *user;
/** 转发的微博 */
@property (strong, nonatomic) Status *retweetedStatus;
@end

/***********************************************/

NSDictionary *dict = @{
               @"text" : @"是啊，今天天气确实不错！",
               @"user" : @{
                   @"name" : @"Jack",
                   @"icon" : @"lufy.png"
                },
               @"retweetedStatus" : @{
                   @"text" : @"今天天气真不错！",
                   @"user" : @{
                       @"name" : @"Rose",
                       @"icon" : @"nami.png"
                    }
                }
            };

// 将字典转为Status模型
Status *status = [Status objectWithKeyValues:dict];

NSString *text = status.text;
NSString *name = status.user.name;
NSString *icon = status.user.icon;
NSLog(@"text=%@, name=%@, icon=%@", text, name, icon);
// text=是啊，今天天气确实不错！, name=Jack, icon=lufy.png

NSString *text2 = status.retweetedStatus.text;
NSString *name2 = status.retweetedStatus.user.name;
NSString *icon2 = status.retweetedStatus.user.icon;
NSLog(@"text2=%@, name2=%@, icon2=%@", text2, name2, icon2);
// text2=今天天气真不错！, name2=Rose, icon2=nami.png
核心代码

[Status objectWithKeyValues:dict]
模型中有个数组属性，数组里面又要装着其他模型
@interface Ad : NSObject
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *url;
@end

@interface StatusResult : NSObject
/** 存放着一堆的微博数据（里面都是Status模型） */
@property (strong, nonatomic) NSMutableArray *statuses;
/** 存放着一堆的广告数据（里面都是Ad模型） */
@property (strong, nonatomic) NSArray *ads;
@property (strong, nonatomic) NSNumber *totalNumber;
@end

/***********************************************/

// StatusResult类中的statuses数组中存放的是Status模型
// StatusResult类中的ads数组中存放的是Ad模型
[StatusResult setupObjectClassInArray:^NSDictionary *{
    return @{
             @"statuses" : @"Status",
             @"ads" : @"Ad"
             };
}];
// 相当于在StatusResult.m中实现了+objectClassInArray方法

NSDictionary *dict = @{
                       @"statuses" : @[
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
                       @"ads" : @[
                           @{
                               @"image" : @"ad01.png",
                               @"url" : @"http://www.ad01.com"
                           },
                           @{
                               @"image" : @"ad02.png",
                               @"url" : @"http://www.ad02.com"
                           }
                       ],
                       @"totalNumber" : @"2014"
                    };

// 将字典转为StatusResult模型
StatusResult *result = [StatusResult objectWithKeyValues:dict];

NSLog(@"totalNumber=%@", result.totalNumber);
// totalNumber=2014

// 打印statuses数组中的模型属性
for (Status *status in result.statuses) {
    NSString *text = status.text;
    NSString *name = status.user.name;
    NSString *icon = status.user.icon;
    NSLog(@"text=%@, name=%@, icon=%@", text, name, icon);
}
// text=今天天气真不错！, name=Rose, icon=nami.png
// text=明天去旅游了, name=Jack, icon=lufy.png

// 打印ads数组中的模型属性
for (Ad *ad in result.ads) {
    NSLog(@"image=%@, url=%@", ad.image, ad.url);
}
// image=ad01.png, url=http://www.ad01.com
// image=ad02.png, url=http://www.ad02.com
核心代码

调用+ (void)setupObjectClassInArray:方法
[StatusResult objectWithKeyValues:dict]
提醒一句：如果NSArray\NSMutableArray属性中存放的不希望是模型，而是NSNumber、NSString等基本数据，那么就不需要调用+ (void)setupObjectClassInArray:方法
模型中的属性名和字典中的key不相同(或者需要多级映射)
@interface Bag : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) double price;
@end

@interface Student : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *nowName;
@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *nameChangedTime;
@property (strong, nonatomic) Bag *bag;
@end

/***********************************************/

// Student中的ID属性对应着字典中的id
// ....
[Student setupReplacedKeyFromPropertyName:^NSDictionary *{
    return @{@"ID" : @"id",
             @"desc" : @"desciption",
             @"oldName" : @"name.oldName",
             @"nowName" : @"name.newName",
             @"nameChangedTime" : @"name.info.nameChangedTime",
             @"bag" : @"other.bag"
             };
}];
// 相当于在Student.m中实现了+replacedKeyFromPropertyName方法

NSDictionary *dict = @{
                       @"id" : @"20",
                       @"desciption" : @"孩子",
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

// 将字典转为Student模型
Student *stu = [Student objectWithKeyValues:dict];

// 打印Student模型的属性
NSLog(@"ID=%@, desc=%@, oldName=%@, nowName=%@, nameChangedTime=%@",
          stu.ID, stu.desc, stu.oldName, stu.nowName, stu.nameChangedTime);
// ID=20, desc=孩子, oldName=kitty, nowName=lufy, nameChangedTime=2013-08
NSLog(@"bagName=%@, bagPrice=%f", stu.bag.name, stu.bag.price);
// bagName=小书包, bagPrice=100.700000
核心代码

调用+ (void)setupReplacedKeyFromPropertyName:方法
[Student objectWithKeyValues:dict]
将一个字典数组转成模型数组
NSArray *dictArray = @[
                       @{
                           @"name" : @"Jack",
                           @"icon" : @"lufy.png",
                        },
                       @{
                           @"name" : @"Rose",
                           @"icon" : @"nami.png",
                        }
                    ];

// 将字典数组转为User模型数组
NSArray *userArray = [User objectArrayWithKeyValuesArray:dictArray];

// 打印userArray数组中的User模型属性
for (User *user in userArray) {
    NSLog(@"name=%@, icon=%@", user.name, user.icon);
}
// name=Jack, icon=lufy.png
// name=Rose, icon=nami.png
核心代码

[User objectArrayWithKeyValuesArray:dictArray]
将一个模型转成字典
// 新建模型
User *user = [[User alloc] init];
user.name = @"Jack";
user.icon = @"lufy.png";

Status *status = [[Status alloc] init];
status.user = user;
status.text = @"今天的心情不错！";

// 将模型转为字典
NSDictionary *statusDict = status.keyValues;
NSLog(@"%@", statusDict);
/*
{
    text = "今天的心情不错！";
    user =     {
        icon = "lufy.png";
        name = Jack;
    };
}
*/

// 多级映射的模型
Student *stu = [[Student alloc] init];
stu.ID = @"123";
stu.oldName = @"rose";
stu.nowName = @"jack";
stu.desc = @"handsome";
stu.nameChangedTime = @"2018-09-08";

Bag *bag = [[Bag alloc] init];
bag.name = @"小书包";
bag.price = 205;
stu.bag = bag;

NSDictionary *stuDict = stu.keyValues;
NSLog(@"%@", stuDict);
/*
{
    desciption = handsome;
    id = 123;
    name =     {
        info =         {
            nameChangedTime = "2018-09-08";
        };
        newName = jack;
        oldName = rose;
    };
    other =     {
        bag =         {
            name = "小书包";
            price = 205;
        };
    };
}
*/
核心代码

status.keyValues、stu.keyValues
将一个模型数组转成字典数组
// 新建模型数组
User *user1 = [[User alloc] init];
user1.name = @"Jack";
user1.icon = @"lufy.png";

User *user2 = [[User alloc] init];
user2.name = @"Rose";
user2.icon = @"nami.png";

NSArray *userArray = @[user1, user2];

// 将模型数组转为字典数组
NSArray *dictArray = [User keyValuesArrayWithObjectArray:userArray];
NSLog(@"%@", dictArray);
/*
(
    {
        icon = "lufy.png";
        name = Jack;
    },
    {
        icon = "nami.png";
        name = Rose;
    }
)
*/
核心代码

[User keyValuesArrayWithObjectArray:userArray]
Core Data
NSDictionary *dict = @{
                       @"name" : @"Jack",
                       @"icon" : @"lufy.png",
                       @"age" : @20,
                       @"height" : @1.55,
                       @"money" : @"100.9",
                       @"sex" : @(SexFemale),
                       @"gay" : @"true"
                       };

// 这个Demo仅仅提供思路，具体的方法参数需要自己创建
NSManagedObjectContext *context = nil;
User *user = [User objectWithKeyValues:dict context:context];

// 利用CoreData保存模型
[context save:nil];
Core code

[User objectWithKeyValues:dict context:context]
Coding
#import "MJExtension.h"

@implementation User
// NSCoding实现
MJCodingImplementation
@end

/***********************************************/

// Bag类中的name属性不参与归档
[Bag setupIgnoredCodingPropertyNames:^NSArray *{
    return @[@"name"];
}];
// 相当于在Bag.m中实现了+ignoredCodingPropertyNames方法

// 创建模型
Bag *bag = [[Bag alloc] init];
bag.name = @"Red bag";
bag.price = 200.8;

NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop/bag.data"];
// 归档
[NSKeyedArchiver archiveRootObject:bag toFile:file];

// 解档
Bag *decodedBag = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
NSLog(@"name=%@, price=%f", decodedBag.name, decodedBag.price);
// name=(null), price=200.800000
Core code

MJCodingImplementation
调用+ (void)setupIgnoredCodingPropertyNames方法（如果全部属性都要归档、解档，那就不需要调用这个方法）
