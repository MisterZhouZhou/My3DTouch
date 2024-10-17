//
//  JPEG.m
//  My3DTouch
//
//  Created by on 2024/10/14.
//

#import "JPEG.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>

@implementation JPEG
- (id)initWithPath:(NSString *)path {
    if (self = [super init]) {
        self.path = path;
    }
    return self;
}

- (id)initWithData:(NSData *)data {
    if (self = [super init]) {
        self.data = data;
    }
    return self;
}

- (NSString *)read {
    NSDictionary *met = [self metadata];
    if (!met) {
        return nil;
    }
    NSDictionary *dict = [met objectForKey:(__bridge NSString *)kCGImagePropertyMakerAppleDictionary];
    NSString *str = [dict objectForKey:kFigAppleMakerNote_AssetIdentifier];
    return str;
}

- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier {
    // creating image destinations
    // 通过路径生成CGImageDestination
    CGImageDestinationRef ret = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:dest], kUTTypeJPEG, 1, nil);
    if (!ret) {
        return;
    }
    CGImageSourceRef imageSource = [self imageSource];
    if (!imageSource) {
        return;
    }
    NSMutableDictionary *metadata = [[self metadata] mutableCopy];
    if (!metadata) {
        return;
    }
    // adding images
    NSMutableDictionary *makerNote = [NSMutableDictionary dictionary];
    [makerNote setObject:assetIdentifier forKey:kFigAppleMakerNote_AssetIdentifier];
    [metadata setObject:makerNote forKey:(__bridge NSString *)kCGImagePropertyMakerAppleDictionary];
    // 增加照片到指定位置，并设置相关属性
    CGImageDestinationAddImageFromSource(ret, imageSource, 0, (__bridge CFDictionaryRef)metadata);
    
    CFRelease(imageSource);
    
    CGImageDestinationFinalize(ret);
}

#pragma mark - 获取JPEG信息
- (NSDictionary *)metadata {
    CGImageSourceRef isrc = [self imageSource];
    NSDictionary *dict = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(isrc, 0, nil));
    CFRelease(isrc);
    return dict;
}

- (CGImageSourceRef)imageSource {
    if (self.data) {
        return CGImageSourceCreateWithData((__bridge CFDataRef)self.data, nil);
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.path]];
    return CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
}

//- (NSData *)data {
//    return [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.path]];
//}
@end
