//
//  QuickTimeMov.h
//  My3DTouch
//
//  Created by cheyipai on 2024/10/14.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QuickTimeMov : NSObject

- (id)initWithPath:(NSString *)path;
- (NSString *)readAssetIdentifier;
- (NSNumber *)readStillImageTime;
- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier;

@end
