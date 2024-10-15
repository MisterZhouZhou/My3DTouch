//
//  ViewController.m
//  My3DTouch
//
//  Created by on 2024/9/26.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "JPEG.h"
#import "QuickTimeMov.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong) UIImageView *coverImage;
@property(nonatomic, strong) NSString *videoUrl;
@property(nonatomic, strong) PHLivePhotoView *livePhotoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手写Live Photo实现";
    
    UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 140, 30)];
    [pickerButton setTitle:@"Picker video" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pickerButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pickerButton.frame) + 10, 100, 180, 30)];
    [saveButton setTitle:@"Save Live Photo" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    // 首帧图
    UILabel *coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pickerButton.frame) + 10, 120, 30)];
    coverLabel.text = @"首帧图";
    coverLabel.textColor = [UIColor blackColor];
    [self.view addSubview:coverLabel];
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coverLabel.frame), CGRectGetWidth(self.view.frame), 300)];
    [self.view addSubview:self.coverImage];
    
    // live photo
    UILabel *livePhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.coverImage.frame) + 10, 220, 30)];
    livePhotoLabel.text = @"Live Photo(长按即可播放)";
    livePhotoLabel.textColor = [UIColor blackColor];
    [self.view addSubview:livePhotoLabel];
    PHLivePhotoView * livePhotoView = [[PHLivePhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(livePhotoLabel.frame), CGRectGetWidth(self.view.frame), 300)];
    livePhotoView.hidden = YES;
    [self.view addSubview:livePhotoView];
    self.livePhotoView = livePhotoView;
    
}


- (void)buttonClick {
    PHAuthorizationStatus authstatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            //允许使用相册
            dispatch_async(dispatch_get_main_queue(), ^{
                [self chooseVideoFromLibrary];
            });
        }else if(authstatus != PHAuthorizationStatusNotDetermined) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"开启权限。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL * URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
                    }
                }];
                [alertCon addAction:cancel];
                [alertCon addAction:action];
                [self.navigationController presentViewController:alertCon animated:YES completion:nil];
            });
        }
    }];
}

#pragma mark - 保存live photo
- (void)saveButtonClick {
    NSString * assetIdentifier = [[NSUUID UUID] UUIDString];
    NSString *imagePath = [self getFilePathWithKey:@"image.jpg"];
    NSString *movPath = [self getFilePathWithKey:@"mov.mov"];
    
    // 当前首帧图
    NSData *imageData = UIImageJPEGRepresentation(self.coverImage.image, 1.0);

    // 移除旧临时文件
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:movPath error:nil];

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globle = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //任务一 写入 图片
    dispatch_group_async(group, globle, ^{
        JPEG *jpeg = [[JPEG alloc] initWithData:imageData];
        [jpeg write:imagePath assetIdentifier:assetIdentifier];
    });
    //任务二 写入 视频
    dispatch_group_async(group, globle, ^{
        QuickTimeMov *quickMov = [[QuickTimeMov alloc] initWithPath:self.videoUrl];
        [quickMov write:movPath assetIdentifier:assetIdentifier];
    });
    
    __weak typeof (self)ws = self;
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 展示出 live photo
        ws.livePhotoView.hidden = NO;
        [PHLivePhoto requestLivePhotoWithResourceFileURLs:@[[NSURL fileURLWithPath:movPath], [NSURL fileURLWithPath:imagePath]] placeholderImage:self.coverImage.image targetSize:self.coverImage.image.size contentMode:PHImageContentModeAspectFit resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info) {
            if (livePhoto) {
                ws.livePhotoView.livePhoto = livePhoto;
            }
        }];
        
        // 写入相册
        PHAuthorizationStatus authstatus = [PHPhotoLibrary authorizationStatus];
        if (authstatus == PHAuthorizationStatusAuthorized) { //已经授权
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
               PHAssetCreationRequest * request = [PHAssetCreationRequest creationRequestForAsset];
               [request addResourceWithType:PHAssetResourceTypePhoto fileURL:[NSURL URLWithString:imagePath] options:nil];
               [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:[NSURL URLWithString:movPath] options:nil];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
               if (success) {
                   NSLog(@"保存成功");
               }
            }];
        }
    });
}

- (void)chooseVideoFromLibrary {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.mediaTypes = @[@"public.movie"];//只获取视频数据
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (UIImage *)getVideoImageWithTime:(Float64)currentTime videoPath:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;// 精确提取某一帧,需要这样处理
    gen.requestedTimeToleranceBefore = kCMTimeZero;// 精确提取某一帧,需要这样处理

    CMTime time = CMTimeMakeWithSeconds(currentTime, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CMTimeShow(actualTime);
    CGImageRelease(image);
    return img;
}

/**
 获取沙盒路径

 @param key eg. im.jpg vo.mov
 @return 返回路径
 */
- (NSString *)getFilePathWithKey:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths.firstObject;
    return [documentDirectory stringByAppendingPathComponent:key];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *videoUrlPath = info[UIImagePickerControllerMediaURL];
    if (videoUrlPath) {
        // 获取视频文件名称并将视频文件移动到document目录下
        NSString * lastPading = [[[videoUrlPath absoluteString] componentsSeparatedByString:@"/"] lastObject];
        NSString * originPath = [self getFilePathWithKey:lastPading];
        self.videoUrl = originPath;
        [[NSFileManager defaultManager] copyItemAtURL:videoUrlPath toURL:[NSURL fileURLWithPath:originPath] error:nil];
        
        // 截图首帧图片
        self.coverImage.image = [self getVideoImageWithTime:0.0 videoPath:videoUrlPath];
    }
}

@end
