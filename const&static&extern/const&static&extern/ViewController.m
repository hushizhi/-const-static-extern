//
//  ViewController.m
//  const&static&extern
//
//  Created by 戚灼伟 on 2019/1/13.
//  Copyright © 2019 戚灼伟. All rights reserved.
//

#import "ViewController.h"

// 常见的常量，抽成宏
// 之前常用的字符串常量，一般是抽成宏，但是苹果不推荐我们抽成宏，推荐我们使用const常量
#define QZWAccount @"account"
#define QZWUserDefault [NSUserDefaults standardUserDefaults]

// 字符串常量+静态
static NSString * const account = @"account";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

/// 一、const与宏的区别
    NSString *str1 = QZWAccount;
    NSString *str2 = QZWAccount;
    NSLog(@"%p %p",str1,str2);
    // 打印结果：
    // 2019-01-13 11:21:06.967215+0800 const&static&extern[5490:5386930] 0x10ab1c068 0x10ab1c068
    // 分析：连续声明 编译器会做优化 所以你打印的是一样的地址。
    // @“account”无论你声明多少个，怎么声明，都会指向文字常量区那个地址
    
    [QZWUserDefault setValue:@"你好吗" forKey:QZWAccount];
    [[NSUserDefaults standardUserDefaults] setValue:@"你好吗" forKey:account];
    
/// 二、const作用：限制类型
    // 定义变量
    int a = 9;
    // 允许修改值
    a = 3;
    
    // const两种用法
    // const：修饰基本变量
    // 下面两种写法是一样的，const只修饰右边的基本变量a
    const int b = 20;  // b:只读变量 == 常量
//    int const b = 20;  // b:只读变量 == 常量
//    b = 3; //不允许修改值
    
    // const:修饰指针变量*p,带*的变量，就是指针变量
    // 定义一个指向int类型的指针变量，指向a的地址
    int *p = &a;
    
    int c = 10;
    p = &c;
    
    // 允许修改p指向的地址，
    // 允许修改p访问内存空间的值
    *p = 20;
    
    // const修饰指针变量访问的内存空间，修饰的是右边*p1
    // 两种方式一样
    const int *p1; // *p1:常量 p1:变量
//    int const *p1; // *p1:常量 p1:变量
    
    // const修饰指针变量p1
//    int * const p1; // *p1:常量 p1:常量
    
    // 第一个const修饰*p1,第二个const修饰p1
    // 两种方式一样
//    const int *const p1; // *p1:常量 p1:常量
//    int const *const p1; // *p1:常量 p1:常量
    
    static  NSString * const key = @"name";
//    key = @"";
    static  NSString const *key1 = @"name";
    NSLog(@"%p %@",key1,key1);
    key1 = @"+++";
    NSLog(@"%p %@",key1,key1);
    
/// 三、const开发中使用场景
    int k = 10;
    
    // 需求1:提供一个方法，这个方法的参数是地址，里面只能通过地址读取值,不能通过地址修改值。
    // 这时候就需要使用const，约束方法的参数只读.
    [self test:&k];
    
    // 需求2:提供一个方法，这个方法的参数是地址，里面不能修改参数的地址。
    [self test1:&k];
    

/// 四、static和extern简单使用
//   static作用
//    修饰局部变量：
//      1.延长局部变量的生命周期,程序结束才会销毁。
//      2.局部变量只会生成一份内存,只会初始化一次。???
//      3.不会改变局部变量的作用域。（修改为“不会改变”）
//    修饰全局变量
//      1.只能在本文件中访问,修改全局变量的作用域,生命周期不会改
//      2.避免重复定义全局变量
//   extern作用:
//    只是用来获取全局变量(包括全局静态变量)的值，不能用于定义变量
//   extern工作原理:
//    先在当前文件查找有没有全局变量，没有找到，才会去其他文件查找。

    
/// 五、static与const联合使用
//    static与const作用:声明一个只读的静态变量
//    开发使用场景:在一个文件中经常使用的字符串常量，可以使用static与const组合
    
    // 开发中经常拿到key修改值，因此用const修饰key,表示key只读，不允许修改。
    NSString *y = @"地址";
    static NSString * const key5 = @"name";
    // 报错：Cannot assign to variable 'key' with const-qualified type 'NSString *const __strong'
   key5 = @"---";
    // 报错：Assigning to 'NSString' from incompatible type 'NSString *'
   *key5 = @"---";
    // 报错：Assigning to 'NSString' from incompatible type 'NSString *__strong *'
   *key5 = &y;
    
    // 如果 const修饰 *key1,表示*key1只读，key1还是能改变。
    static  NSString const *key6 = @"name";
    // 报错：Read-only variable is not assignable
//    *key6 = @"+++";
    // 正常
    key6 = @"+++";
    
    
/// 六、extern与const联合使用
//    开发中使用场景:在多个文件中经常使用的同一个字符串常量，可以使用extern与const组合。
//    原因:
//        static与const组合：在每个文件都需要定义一份静态全局变量。
//        extern与const组合:只需要定义一份全局变量，多个文件共享。
//    全局常量正规写法:开发中便于管理所有的全局变量，通常搞一个GlobeConst.h和GlobeConst.m文件，里面专门定义全局变量，统一管理，要不然项目文件多不好找。
//  在A.h文件：
//    extern NSString * const nameKey
//  在A.m文件：
//    #import <Foundation/Foundation.h>
//    NSString * const nameKey = @"name";
    
}

// const放*前面约束参数，表示*a只读
// 只能修改地址a,不能通过a修改访问的内存空间(即*a指向的内存空间)
- (void)test:(const int * )a
{
    // 会报错 Read-only variable is not assignable
        *a = 20;
}

// const放*后面约束参数，表示a只读
// 不能修改a的地址，只能修改a访问的值
- (void)test1:(int * const)a
{
    int b;
    // 会报错 Cannot assign to variable 'a' with const-qualified type 'int *const'
//    a = &b;
    // 会报错 Cannot assign to variable 'a' with const-qualified type 'int *const'
    a = 30;
    
    *a = 2;
}


@end

// 一、const与宏的区别
// const简介:之前常用的字符串常量，一般是抽成宏，但是苹果不推荐我们抽成宏，推荐我们使用const常量。
//
// 编译时刻:宏是预编译（编译之前处理），const是编译阶段。
//
// 编译检查:宏不做检查，不会报编译错误，只是替换，const会编译检查，会报编译错误。
//
// 宏的好处:宏能定义一些函数，方法。 const不能。
//
// 宏的坏处:使用大量宏，容易造成编译时间久，每次都需要重新替换。
//
// 宏定义的是常量，常量都放在常量区，只会生成一份内存。


// 二、const作用：限制类型
// 1.const仅仅用来修饰右边的变量（基本数据变量p，指针变量*p）
//
// 2.被const修饰的变量是只读的。

