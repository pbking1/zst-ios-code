//
//  HorizontalScrollImageShow.h
//  huyihui
//
//  Created by pengzhizhong on 14-4-30.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollImageShowDataSource;
@protocol HorizontalScrollImageShowDelegate;

@interface HorizontalScrollImageShow : UIView<UIScrollViewDelegate>

@property (assign, nonatomic) NSTimeInterval interval;
@property (assign, nonatomic) IBOutlet id<HorizontalScrollImageShowDataSource> dataSource;
@property (assign, nonatomic) IBOutlet id<HorizontalScrollImageShowDelegate> delegate;
- (void)reloadData;

@end

//数据源
@protocol HorizontalScrollImageShowDataSource <NSObject>

@required
- (NSInteger)numOfItemsInShowView:(HorizontalScrollImageShow*)showlView;
- (NSURL *)HorizontalScrollImageShow:(HorizontalScrollImageShow *)showView imageUrlForItemAtIndex:(NSInteger)index;

@end

//反馈
@protocol HorizontalScrollImageShowDelegate <NSObject>

@optional
- (void)HorizontalScrollImageShow:(HorizontalScrollImageShow *)showView didSelectItemAtIndex:(NSInteger)index;

@end
