//
//  HorizontalScrollImageShow.m
//  huyihui
//
//  Created by pengzhizhong on 14-4-30.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "HorizontalScrollImageShow.h"
@interface HorizontalScrollImageShow ()
@property (retain, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) CGFloat itemHeight;


@property (retain, nonatomic) NSMutableDictionary *imageCache;

//@property (retain, nonatomic) NSTimer *timer;

@property (assign) BOOL isUserDragging;

//@property (nonatomic,assign) dispatch_queue_t timerQueue;
//@property (nonatomic,assign) dispatch_source_t timerSource;

@property (assign) NSInteger itemCount;
@end

@implementation HorizontalScrollImageShow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    
    self.dataSource = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)baseInit
{
    self.imageCache = [NSMutableDictionary dictionary];
    CGRect frame = self.frame;
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
    self.scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.interval = 2.0;
    self.itemWidth = frame.size.width;
    self.itemHeight = frame.size.height;
}
//主动调用方法//
- (void)reloadData
{
    //先清除其下级视图子view
    for(UIView *v in [self.scrollView subviews]){
        [v removeFromSuperview];
    }
    //有多少待显图片（图片张数）
    self.itemCount = [self.dataSource numOfItemsInShowView:self];//delegate方法
    //图片view的填充进去
    __block CGFloat length = 0.0f;
    dispatch_queue_t queue_pengzz=  dispatch_queue_create("pengzz", DISPATCH_QUEUE_SERIAL);
    for(int i=0;i<self.itemCount;i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(length, 0, self.itemWidth, self.itemHeight)];
        btn.tag = i;
        [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        //length += self.itemWidth;
        [btn release];
        @synchronized(self){
            NSURL *url = [self.dataSource HorizontalScrollImageShow:self imageUrlForItemAtIndex:i];//delegate方法
            if(_imageCache[url.absoluteString] == nil){
                dispatch_async(
                               //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                               queue_pengzz
                               , ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image0 = [UIImage imageWithData:imageData scale:1.0];
                    UIImage *image= [UIImage imageWithData:imageData scale:image0.size.height/_scrollView.frame.size.height];//原到现200的除缩放
                    if(image){
                        [_imageCache setObject:image forKey:url.absoluteString];
                        [btn setFrame:CGRectMake(length, 0, image.size.width, image.size.height)];//pzz 修改..
                        length += image.size.width;
                        _scrollView.contentSize = CGSizeMake(length, _scrollView.frame.size.height);
                        //_block length;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [btn setBackgroundImage:image forState:UIControlStateNormal];
                            [btn setBackgroundImage:image forState:UIControlStateHighlighted];
                        });
                    }
                });
            }else{
                UIImage *image = _imageCache[url.absoluteString];
                [btn setFrame:CGRectMake(length, 0, image.size.width, image.size.height)];//pzz 修改..
                length += image.size.width;
                _scrollView.contentSize = CGSizeMake(length, _scrollView.frame.size.height);
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            }
        }
    }
    //
    //[_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
    //_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.itemCount, _scrollView.frame.size.height);
}
- (void)setDataSource:(id<HorizontalScrollImageShowDataSource>)dataSource
{
    if(_dataSource != dataSource){
        _dataSource = dataSource;
        [self reloadData];
    }
}
- (void)itemClicked:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if([self.delegate respondsToSelector:@selector(HorizontalScrollImageShow:didSelectItemAtIndex:)]){
        [self.delegate HorizontalScrollImageShow:self didSelectItemAtIndex:index];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
