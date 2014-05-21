//
//  Util.h
//  ccydpro
//
//  Created by hiway on 13-2-19.
//  Copyright (c) 2013年 hiway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)createUUID;

+ (NSString *)writeImageToFileSystem:(UIImage*)img;

+ (BOOL)writeArray:(NSArray *)array toFilePath:(NSString *)path;

+ (NSArray *)readArrayFromFile:(NSString *)filePath;

+ (BOOL)writeDictionary:(NSDictionary *)dict toFilePath:(NSString *)path;

+ (NSDictionary *)readDictionaryFromFile:(NSString *)filePath;

+(NSString *)writeVideoToFileSystem:(NSURL *)videoURL;

+(BOOL)isValidateEmail:(NSString *)email;

+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL) isValidateNormPwd:(NSString *)password;

+(BOOL) validateCarNo:(NSString*) carNo;

//+ (NSCachedURLResponse *) getCachedResponseFromURL:(NSURL *)url;
//+ (void) removeAllCachedResponse;

+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text;

+ (UIColor *)rgbColor:(char*)color;

+ (NSString *)dictToJson:(NSMutableDictionary *)dict;

+ (NSDictionary *)jsonToDict:(NSString *)jsonStr;

+ (NSString *)arrToJson:(NSArray *)arr;

+ (NSArray *)jsonToArr:(NSString *)jsonStr;

+ (long)stringDateConvToLongDate:(NSString *)DateStr;
/*该方法将*/
+ (NSString *)timestampStringForRFC3339DateTimeString:(NSString *)time;

+(void)UIImageFromURL:(NSURL*)URL  withImageBlock:(void(^)(UIImage * image))imageBlock errorBlock:(void(^)())errorBlock;

+(void)UIImageFromURLStr:(NSString*)imgUrlStr  withImageBlock:(void(^)(UIImage * image))imageBlock /*errorBlock:(void(^)())errorBlock*/ defaultImageName:(NSString*)defaultImgName;

//播放震动与声音
+ (void)playShake;
+ (void)playSound;

//缩放图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaleToSize:(CGSize)newSize;

//+ (UIColor *)colorFromRGB:(char *)str;

//判断网络状态
+ (int)checkNetType;
+ (void)checkNetType:(void(^)(int status))block;

@end