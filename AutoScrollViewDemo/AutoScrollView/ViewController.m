//
//  ViewController.m
//  AutoScrollView
//
//  Created by Jason on 15/11/20.
//  Copyright © 2015年 Happy. All rights reserved.
//

#import "ViewController.h"
#import "AutoScrollView.h"
@interface ViewController ()<AutoScrollViewDelegateAndDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AutoScrollView *autoSCView = [[AutoScrollView alloc] initWithFrame:self.view.bounds];
    autoSCView.autoSVDelegateAndDataSource = self;
    autoSCView.backgroundColor = [UIColor clearColor];
    autoSCView.enableAutoScorllWhenPageunder3 = YES;
    autoSCView.enableAutoScroll = YES;
    [autoSCView reload];
    [self.view addSubview:autoSCView];
}


-(NSUInteger)numbersOfView{
    
    return 2;
    
}

-(UIView *)autoViewforIndex:(AutoScrollView *)autoScrollView withIndex:(NSUInteger)index{
    
    NSLog(@"======%lu",(unsigned long)index);
    
//    if (index == 0) {
    
        UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
        v.backgroundColor = [UIColor grayColor];
        UILabel *l = [[UILabel alloc] initWithFrame:self.view.bounds];
        l.text = [NSString stringWithFormat:@"%lu",index];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:40];
        [v addSubview:l];
        return v;
//    }
//    
//    if (index == 1) {
//        
//        UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
//        v.backgroundColor = [UIColor blueColor];
//        UILabel *l = [[UILabel alloc] initWithFrame:self.view.bounds];
//        l.text = @"2";
//        l.textAlignment = NSTextAlignmentCenter;
//        l.font = [UIFont systemFontOfSize:40];
//        [v addSubview:l];
//        return v;
//    }
//    
//    
//    if (index == 2) {
//        
//        UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
//        v.backgroundColor = [UIColor redColor];
//        UILabel *l = [[UILabel alloc] initWithFrame:self.view.bounds];
//        l.text = @"3";
//        l.textAlignment = NSTextAlignmentCenter;
//        l.font = [UIFont systemFontOfSize:40];
//        [v addSubview:l];
//        return v;
//    }
    
    return nil;
}


- (void)autoScrollViewScrolledIndex:(AutoScrollView *)autoScrollView withIndex:(NSUInteger)index{
    
    NSLog(@"the current index %lu",(unsigned long)index);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
