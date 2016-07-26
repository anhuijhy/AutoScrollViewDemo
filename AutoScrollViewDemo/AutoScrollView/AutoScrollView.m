//
//  AutoScroliew.m
//  AutoScrollView
//
//  Created by Jason on 15/11/20.
//  Copyright © 2015年 Happy. All rights reserved.
//

#import "AutoScrollView.h"

#define AUTOSCROLLTIME 5

@interface AutoScrollView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat width; /**< 宽度 */
@property (nonatomic, assign) CGFloat height; /**< 高度 */
@property (nonatomic, assign) NSUInteger currentIdx; /**< 当前显示的索引 */
@property (nonatomic, strong) NSMutableArray *containerArray; /**< view 容器 */
@property (nonatomic, strong) NSTimer *timer; /**< <#属性注释#> */

@end;

@implementation AutoScrollView
@synthesize autoSVDelegateAndDataSource,width,height;
@synthesize currentIdx;
@synthesize containerArray;
@synthesize enableAutoScorllWhenPageunder3;

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        
        width = CGRectGetWidth(frame);
        height = CGRectGetHeight(frame);
        containerArray = [NSMutableArray array];
    }
    
    return self;
}

- (id)init{
    
    self = [super init];
    
    if (self) {
        
        
    }
    
    return self;
}


- (void)startAutoScroll{
    
    if (_enableAutoScroll) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:AUTOSCROLLTIME target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        
    }

}

- (void)autoScroll{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.contentOffset = CGPointMake(self.contentOffset.x + width, 0);
    }];
    
    
    [self scrollViewDidEndDecelerating:self];
}

//防止数据没有ready造成的错误
- (void)reload{
    
    [self prepareInit];
    [self initContentView];
    [self startAutoScroll];

}
- (void)prepareInit{
    
    self.pagingEnabled = YES;
    
    if (enableAutoScorllWhenPageunder3) {
        
        self.contentSize = CGSizeMake(3*width, height);
        self.contentOffset = CGPointMake(width, 0);
        
    }else{
        
        if ([self numberOfView] == 2) {
            
            self.contentSize = CGSizeMake(2*width, height);
            
        }else if ([self numberOfView] == 1){
            
            self.contentSize = CGSizeMake(width, height);
            
        }else if ([self numberOfView] > 2){
            
            self.contentSize = CGSizeMake(3*width, height);
            self.contentOffset = CGPointMake(width, 0);
            
        }
    }
    
}


/**
 *  获取View
 */
- (void)initContentView{
    
    if (autoSVDelegateAndDataSource) {
        
        if ([self numberOfView] > 0) {
            
            if (enableAutoScorllWhenPageunder3) {
                
                [self initPage3View];
                
            }else{
                
                if ([self numberOfView] > 2) {
                    
                    [self initPage3View];
                    
                }else if ([self numberOfView] == 2){
                    
                    [self initPage2View];
                    
                }else if ([self numberOfView] == 1){
                    
                    [self initPage1View];
                    
                }else{
                    
                    
                }
                
            }
        }
        
    }
    
}



- (void)initPage3View{
    
    NSUInteger Ridx = 1;
    if ([self numberOfView] == 1) {
        Ridx = 0;
    }
    
    UIView *cView = [self autoScrollViewWithIdx:0];
    UIView *lView = [self autoScrollViewWithIdx:[self numberOfView] - 1];
    UIView *rView = [self autoScrollViewWithIdx:Ridx];
    
    cView.frame = CGRectMake(width, 0, width, height);
    lView.frame = CGRectMake(0, 0, width, height);
    rView.frame = CGRectMake(width*2, 0, width, height);
    
    [containerArray addObject:lView];
    [containerArray addObject:cView];
    [containerArray addObject:rView];
    
    [self addSubview:cView];
    [self addSubview:lView];
    [self addSubview:rView];
    
}


- (void)initPage2View{
    
    UIView *cView = [self autoScrollViewWithIdx:0];
    UIView *lView = [self autoScrollViewWithIdx:1];
    
    cView.frame = CGRectMake(0, 0, width, height);
    lView.frame = CGRectMake(width, 0, width, height);
    
    [containerArray addObject:lView];
    [containerArray addObject:cView];
    
    [self addSubview:cView];
    [self addSubview:lView];
    
}

- (void)initPage1View{
    
    UIView *cView = [self autoScrollViewWithIdx:0];
    cView.frame = CGRectMake(0, 0, width, height);
    [containerArray addObject:cView];
    [self addSubview:cView];
    
}

#pragma marks
#pragma getter datasource
-(NSUInteger)numberOfView{
    
    if (autoSVDelegateAndDataSource) {
        
        return [autoSVDelegateAndDataSource numbersOfView];
        
    }
    
    return 0;
}

- (UIView *)autoScrollViewWithIdx:(NSUInteger)idx{
    
    UIView *View = [autoSVDelegateAndDataSource autoViewforIndex:self withIndex:idx];
    
    return View;
}

#pragma marks
#pragma setter dalegate
-(void)autoScrollViewIndex{
    
    if (autoSVDelegateAndDataSource) {
        
        [autoSVDelegateAndDataSource autoScrollViewScrolledIndex:self withIndex:currentIdx];
    }
}


#pragma marks
#pragma ScrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint offset = [scrollView contentOffset];
    
    if(enableAutoScorllWhenPageunder3){
        
        [self scrollToPoint:offset];
    
    }else{
        
        if ([self numberOfView] > 2) {
            
            [self scrollToPoint:offset];
            
            
        }else if([self numberOfView] == 2){
            
            //计算currentIdx
            
            currentIdx = ceil(offset.x - width/2)/width + 1;
            
        }else if ([self numberOfView] == 1){
            
            //计算currentIdx
            currentIdx = ceil(offset.x - width/2)/width + 1;
        }else{
            
        }
        
    }
    [self autoScrollViewIndex];
}


- (void)scrollToPoint:(CGPoint)offset{

    
    if (offset.x > width) {
        //向右
        //先计算是否过半个width否则应该停留在本页;
        currentIdx = (currentIdx + 1)%[self numberOfView];
        NSUInteger rightIdx = (currentIdx + 1)%[self numberOfView];
        
        //
        UIView *rView = [containerArray objectAtIndex:0];
        [rView removeFromSuperview];
        rView = nil;
        [containerArray removeObjectAtIndex:0];
        //
        
        UIView *rViewNewToL = [self autoScrollViewWithIdx:rightIdx];
        
        rViewNewToL.frame = CGRectMake(width*2, 0, width, height);
        [self addSubview:rViewNewToL];
        [containerArray insertObject:rViewNewToL atIndex:2];
        
        
        UIView *cViewFromL = [containerArray objectAtIndex:0];
        UIView *rViewNewFromC = [containerArray objectAtIndex:1];
        
        cViewFromL.frame = CGRectMake(0, 0, width, height);
        rViewNewFromC.frame = CGRectMake(width, 0, width, height);
        
        [self setContentOffset:CGPointMake(width, 0)];
        
    }else if(offset.x == width){
        
        //保持不变
        
    }else{
        //向左
        currentIdx = (currentIdx + [self numberOfView] - 1)%[self numberOfView];
        
        NSUInteger leftIdx = (currentIdx + [self numberOfView] - 1)%[self numberOfView];
        
        //
        UIView *rView = [containerArray objectAtIndex:2];
        [rView removeFromSuperview];
        rView = nil;
        [containerArray removeObjectAtIndex:2];
        //
        UIView *lViewNewToR = [self autoScrollViewWithIdx:leftIdx];
        lViewNewToR.frame = CGRectMake(0, 0, width, height);
        [self addSubview:lViewNewToR];
        [containerArray insertObject:lViewNewToR atIndex:0];
        
        
        UIView *cViewFromL = [containerArray objectAtIndex:1];
        UIView *rViewNewFromC = [containerArray objectAtIndex:2];
        
        cViewFromL.frame = CGRectMake(width, 0, width, height);
        rViewNewFromC.frame = CGRectMake(width*2, 0, width, height);
        
        [self setContentOffset:CGPointMake(width, 0)];
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
