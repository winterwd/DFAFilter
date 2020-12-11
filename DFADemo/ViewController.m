//
//  ViewController.m
//  DFADemo
//
//  Created by winter on 2020/11/18.
//  Copyright © 2020 winter. All rights reserved.
//

#import "ViewController.h"
#import <mach/mach_time.h>
#import "DFAFilter.h"
#import "TestViewController.h"

typedef void (^block)(void);
@interface ViewController ()
@property (nonatomic, strong) DFAFilter *dfaFilter;
@end

@implementation ViewController

//+ (CGFloat)runTimeBlock:(block)block
//{
//    mach_timebase_info_data_t info;
//    if (mach_timebase_info(&info) != KERN_SUCCESS) return - 1.0;
//
//    uint64_t start = mach_absolute_time ();
//    block ();
//    uint64_t end = mach_absolute_time ();
//    uint64_t elapsed = end - start;
//
//    uint64_t nanos = elapsed * info.numer / info.denom;
//    return (CGFloat)nanos / NSEC_PER_SEC;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"测试" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(100, 400, 60, 40);
    }
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    [button setTitle:@"过滤" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    button.backgroundColor = [UIColor redColor];
//    button.frame = CGRectMake(100, 100, 100, 100);
//
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        DFAFilter *dfaFilter = [[DFAFilter alloc] init];
//        [dfaFilter parseSensitiveWords:nil];
//        self.dfaFilter = dfaFilter;
//    });
}

//- (void)filter
//{
//    do {
//        NSLog(@"dfaFilter = %@", self.dfaFilter);
//    } while (!self.dfaFilter);
//
//    CGFloat time = [ViewController runTimeBlock:^{
//        NSString *message = @"小明骂小王是个王八蛋，小王骂小明是个王八羔子！操你妈，傻逼";
//        NSLog(@"message == %@",message);
//
//        NSString *result = [self.dfaFilter filterSensitiveWords:message replaceKey:nil];
//        NSLog(@"result == %@",result);
//     }];
//    NSLog(@"总共耗时: %f \n\n", time);
//}

- (void)present
{
    [self presentViewController:[TestViewController new] animated:YES completion:nil];
}
@end
