//
//  AutoScroliew.h
//  AutoScrollView
//
//  Created by Jason on 15/11/20.
//  Copyright © 2015年 Happy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoScrollView;

@protocol AutoScrollViewDelegateAndDataSource <NSObject>
@required
- (NSUInteger)numbersOfView;
- (UIView *)autoViewforIndex:(AutoScrollView *)autoScrollView withIndex:(NSUInteger)index;
@optional
- (void)autoScrollViewScrolledIndex:(AutoScrollView *)autoScrollView withIndex:(NSUInteger)index;
@end

@interface AutoScrollView : UIScrollView

@property (nonatomic, weak) id  <AutoScrollViewDelegateAndDataSource> autoSVDelegateAndDataSource; /**< 代理数据源 */
@property (nonatomic, assign) BOOL enableAutoScorllWhenPageunder3; /**< 当page小于3的时候 时候依然循环显示 默认NO */
@property (nonatomic, assign) BOOL enableAutoScroll; /**< 自动轮播 */
- (void)reload;

@end
