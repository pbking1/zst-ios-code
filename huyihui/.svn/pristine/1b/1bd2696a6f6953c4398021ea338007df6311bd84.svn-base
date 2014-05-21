//
//  CarouselViewController.h
//  TestAll
//
//  Created by zjh on 14-2-19.
//  Copyright (c) 2014年 zjh. All rights reserved.
//

/*
    首页自动滚动展示栏
 */

#import <UIKit/UIKit.h>

@protocol CarouselViewDataSource;
@protocol CarouselViewDelegate;

@interface CarouselView : UIView<UIScrollViewDelegate>

@property (assign, nonatomic) NSTimeInterval interval;
@property (assign, nonatomic) IBOutlet id<CarouselViewDataSource> dataSource;
@property (assign, nonatomic) IBOutlet id<CarouselViewDelegate> delegate;
- (void)reloadData;

@end

//数据源
@protocol CarouselViewDataSource <NSObject>

@required
- (NSInteger)numOfItemsInCarouselView:(CarouselView*)carouselView;
//- (UIImage *)carouselView:(CarouselView *)carouselView imageForItemAtIndex:(NSInteger)index;
- (NSURL *)carouselView:(CarouselView *)carouselView imageUrlForItemAtIndex:(NSInteger)index;
                            
@end

//反馈
@protocol CarouselViewDelegate <NSObject>

@optional
- (void)carouselView:(CarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index;

@end