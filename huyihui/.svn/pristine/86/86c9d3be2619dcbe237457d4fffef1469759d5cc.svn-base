//
//  ZacCache.m
//  huyihui
//
//  Created by zaczh on 14-4-24.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ZacCache.h"


#define ON_DISK_CACHE_SIZE 1024*1024*400 /*400M*/
#define IN_MEMORY_CACHE_SIZE 1024*1024*40 /*40M*/

@implementation ZacCache

+ (CGFloat)getCurrentCacheFileSize{
    if([NSURLCache sharedURLCache] == nil)
    {
        return .0f;
    }
    
    return [[NSURLCache sharedURLCache] currentDiskUsage]/(1024*1024);
}

+ (NSCachedURLResponse *) getCachedResponseFromURL:(NSURL *)url
{
    if([NSURLCache sharedURLCache] == nil)
    {
        //set cache
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:IN_MEMORY_CACHE_SIZE diskCapacity:ON_DISK_CACHE_SIZE diskPath:@"ZacCache"];
        [NSURLCache setSharedURLCache:cache];
        [cache release];
    }
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:url] autorelease];
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    if(cachedResponse == nil)
    {
        NSURLResponse *response = [[[NSURLResponse alloc] init] autorelease];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if(data)
        {
            cachedResponse = [[[NSCachedURLResponse alloc] initWithResponse:response data:data] autorelease];
            [[NSURLCache sharedURLCache] storeCachedResponse: cachedResponse forRequest:request];
        }
    }
    return cachedResponse;
}

+ (void)removeAllCachedResponses
{
    if([NSURLCache sharedURLCache] == nil)
    {
        NSLog(@"No sharedURLCache set!");
        return;
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

+ (void)clear{
    [[self class] removeAllCachedResponses];
}
@end
