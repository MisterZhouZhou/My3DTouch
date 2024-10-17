//
//  JPEG.h
//  My3DTouch
//
//  Created by on 2024/10/14.
//

#import <Foundation/Foundation.h>

static NSString    *const  kFigAppleMakerNote_AssetIdentifier = @"17";

@interface JPEG : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSData *data;

- (id)initWithPath:(NSString *)path;
- (id)initWithData:(NSData *)data;

- (NSString *)read;
- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier;
@end
