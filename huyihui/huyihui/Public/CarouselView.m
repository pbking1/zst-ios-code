//
//  CarouselViewController.m
//  TestAll
//
//  Created by zjh on 14-2-19.
//  Copyright (c) 2014年 zjh. All rights reserved.
//

#import "CarouselView.h"

@interface CarouselView ()
@property (retain, nonatomic) NSMutableDictionary *imageCache;

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) CGFloat itemHeight;

@property (retain, nonatomic) NSTimer *timer;

@property (assign) BOOL isUserDragging;

@property (nonatomic,assign) dispatch_queue_t timerQueue;
@property (nonatomic,assign) dispatch_source_t timerSource;

@property (assign) NSInteger itemCount;

@end

@implementation CarouselView

- (void)baseInit
{
    self.imageCache = [NSMutableDictionary dictionary];
    CGRect frame = self.frame;
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 10)] autorelease];
    [self addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints:@[
                          [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0f],
                          [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:.0f],
                          [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0f]
                          ]];
    
    
    self.interval = 2.0;
    self.itemWidth = frame.size.width;
    self.itemHeight = frame.size.height;
    
    _timerQueue = nil;
    _timerSource = nil;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self baseInit];
    }
    return self;
}

- (void)dealloc
{
    [_imageCache release];
    
    if(_timerQueue != nil){
        dispatch_release(_timerQueue);
        _timerQueue = nil;
    }
    
    if(_timerSource != nil){
        dispatch_suspend(_timerSource);
        dispatch_release(_timerSource);
        _timerSource = nil;
    }
    self.timer = nil;
    self.dataSource = nil;
    self.delegate = nil;
    [super dealloc];
}

//- (void)drawRect:(CGRect)rect
//{
//
//}

- (void)reloadData
{
    for(UIView *v in [self.scrollView subviews]){
        [v removeFromSuperview];
    }
    
    self.itemCount = [self.dataSource numOfItemsInCarouselView:self];
    self.pageControl.numberOfPages = self.itemCount;
    
    CGFloat length = 0.0f;
    for(int i=0;i<self.itemCount;i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(length, 0, self.itemWidth, self.itemHeight)];
        btn.tag = i;
        [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        length += self.itemWidth;
        [btn release];
        @synchronized(self){
            NSURL *url = [self.dataSource carouselView:self imageUrlForItemAtIndex:i];
            if(_imageCache[url.absoluteString] == nil){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:imageData];
                    if(image){
                        [_imageCache setObject:image forKey:url.absoluteString];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [btn setBackgroundImage:image forState:UIControlStateNormal];
                            [btn setBackgroundImage:image forState:UIControlStateHighlighted];
                        });
                    }
                });
            }else{
                UIImage *image = _imageCache[url.absoluteString];
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            }
        }
    }
    self.scrollView.contentSize = CGSizeMake(length, self.itemHeight);
    
    if(self.itemCount >1){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _timerQueue = dispatch_queue_create("HuEasyTimerQueue", NULL);
            _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                  0,
                                                  0,
                                                  _timerQueue);
            NSAssert(_timerSource != NULL, @"set timer source failed.");
            dispatch_source_set_timer(_timerSource,
                                      dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * self.interval),
                                      NSEC_PER_SEC * self.interval,
                                      NSEC_PER_SEC * self.interval/2);
            
            dispatch_source_set_event_handler(_timerSource, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self scroll];
                });
            });
            dispatch_resume(_timerSource);
        });
    }
}

- (void)setDataSource:(id<CarouselViewDataSource>)dataSource
{
    if(_dataSource != dataSource){
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)scroll
{
//    CGPoint position = self.scrollView.contentOffset;

    if( self.pageControl.currentPage == self.itemCount - 1){//the last one scroll
        self.pageControl.currentPage = 0;
        UIView * firstView = [[self.scrollView subviews] firstObject];
        CGRect frame = firstView.frame;
        firstView.frame = CGRectMake(self.itemWidth, 0, self.itemWidth, self.itemHeight);
        [self addSubview:firstView];
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(self.itemCount * self.itemWidth, 0)];
            firstView.frame = CGRectMake(0, 0, self.itemWidth, self.itemHeight);
        } completion:^(BOOL finished) {
            firstView.frame = frame;
            [self.scrollView insertSubview:firstView atIndex:0];
            [self.scrollView setContentOffset:CGPointZero];
        }];
    }else{
        self.pageControl.currentPage += 1;
        CGPoint target = CGPointMake(self.pageControl.currentPage * self.itemWidth,0);
        [self.scrollView setContentOffset:target animated:YES];
    }
}

- (void)itemClicked:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)]){
        [self.delegate carouselView:self didSelectItemAtIndex:index];
    }
}

//- (void)updatePageControlByOffSet:(CGFloat)offset
//{
//    NSInteger pos = offset/self.itemWidth;
//    self.pageControl.currentPage = pos;
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dispatch_suspend(_timerSource);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger pos = (*targetContentOffset).x/self.itemWidth;
    self.pageControl.currentPage = pos;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_resume(_timerSource);
});
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    dispatch_resume(_timerSource);
//    [self updatePageControlByOffSet:scrollView.contentOffset.x];
//}

@end