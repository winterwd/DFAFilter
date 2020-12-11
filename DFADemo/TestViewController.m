//
//  TestViewController.m
//  DFADemo
//
//  Created by winter on 2020/11/18.
//  Copyright © 2020 winter. All rights reserved.
//

#import "TestViewController.h"
#import <mach/mach_time.h>
#import "DFAFilter.h"

typedef void (^block)(void);
@interface TestViewController ()
@property (nonatomic, strong) DFAFilter *dfaFilter;
@end

@implementation TestViewController

+ (CGFloat)runTimeBlock:(block)block
{
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return - 1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"过滤" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 100, 100, 100);
}

{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 400, 60, 40);
}
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DFAFilter *dfaFilter = [[DFAFilter alloc] init];
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"sensitive_wordss" ofType:@"txt"];
        [dfaFilter parseSensitiveWords:path];
        self.dfaFilter = dfaFilter;
//    });
}

- (void)filter
{
    do {
        NSLog(@"dfaFilter = %@", self.dfaFilter);
    } while (!self.dfaFilter);
    
    CGFloat time1 = [TestViewController runTimeBlock:^{
//        NSString *message = @"沙雕！小王骂小明是个王*&八^羔(子！";
//        NSString *message = @"小王骂小明沙雕";
//        NSString *message = @"傻& 0️⃣逼是 操 &你*妈啊";
        NSString *message = @"傻& 0️⃣逼是 操 &你*妈啊";
        NSLog(@"message == %@",message);

        NSString *result = [self.dfaFilter replaceSensitiveWord:message replaceChar:nil];
        NSLog(@"result1 == %@",result);
     }];
    NSLog(@"总共耗时: %f \n\n", time1);
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

