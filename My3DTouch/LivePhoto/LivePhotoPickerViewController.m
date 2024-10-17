//
//  LivePhotoPickerViewController.m
//  My3DTouch
//
//  Created by on 2024/10/15.
//  相册选取live photo

#import "LivePhotoPickerViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface LivePhotoPickerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) PHLivePhotoView *livePhotoView;

@end

@implementation LivePhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Live Photo Picker";
    
    // 调整布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 图片选取
    UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 140, 30)];
    [pickerButton setTitle:@"Picker Live Photo" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pickerButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];

    // live photo
    UILabel *coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pickerButton.frame) + 10, 260, 30)];
    coverLabel.text = @"选取live photo后长按播放";
    coverLabel.textColor = [UIColor blackColor];
    [self.view addSubview:coverLabel];
    self.livePhotoView = [[PHLivePhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coverLabel.frame), CGRectGetWidth(self.view.frame), 400)];
    self.livePhotoView.hidden = YES;
    [self.view addSubview:self.livePhotoView];
    
    // 按钮操作
    CGFloat marginY = CGRectGetMaxY(self.livePhotoView.frame) + 20;
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(50, marginY, 140, 30)];
    [playButton setTitle:@"Play Live Photo" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playButton.frame) + 10, marginY, 140, 30)];
    [topButton setTitle:@"Stop Live Photo" forState:UIControlStateNormal];
    [topButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(stopButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
}

#pragma mark - actions
- (void)playButtonClick {
    [self.livePhotoView startPlaybackWithStyle: PHLivePhotoViewPlaybackStyleFull];
}

- (void)stopButtonClick {
    [self.livePhotoView stopPlayback];
}

- (void)buttonClick {
    PHAuthorizationStatus authstatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            //允许使用相册
            dispatch_async(dispatch_get_main_queue(), ^{
                [self chooseMovFromLibrary];
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

- (void)chooseMovFromLibrary {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 选取live photo
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeLivePhoto];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 从选择器返回的信息中获取 Live Photo 对象
    PHLivePhoto *photo = [info objectForKey:UIImagePickerControllerLivePhoto];
    // dismiss 图片选择器界面
    [picker dismissViewControllerAnimated:YES completion:^{
        if (photo) {
            self.livePhotoView.hidden = NO;
            // 将 Live Photo 对象赋值给 PHLivePhotoView 对象，以便显示
             self.livePhotoView.livePhoto = photo;
            // 开始以全屏播放样式播放 Live Photo
            //[self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
        }
    }];
}

@end
