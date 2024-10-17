//
//  LocalFielViewController.m
//  My3DTouch
//
//  Created by on 2024/10/15.
//

#import "LocalFielViewController.h"
//#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface LocalFielViewController ()

@property(nonatomic, strong) PHLivePhotoView *livePhotoView;

@end

@implementation LocalFielViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Local File";
    
    // 调整布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 图片选取
    UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 140, 30)];
    [pickerButton setTitle:@"Picker Live Photo" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pickerButton addTarget:self action:@selector(loadLocalFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
    
    // live photo
    UILabel *coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pickerButton.frame) + 10, 260, 30)];
    coverLabel.text = @"选取live photo后长按播放";
    coverLabel.textColor = [UIColor blackColor];
    [self.view addSubview:coverLabel];
    self.livePhotoView = [[PHLivePhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coverLabel.frame), CGRectGetWidth(self.view.frame), 400)];
    self.livePhotoView.hidden = YES;
    [self.view addSubview:self.livePhotoView];
}

- (void)loadLocalFile {
    NSString *imagePath = [self getFilePathWithKey:@"image.jpg"];
    NSString *movPath = [self getFilePathWithKey:@"mov.mov"];
    
    // 创建一个 NSURL 数组，包含 Live Photo 的静态图片和视频文件的 URL
    NSArray *resourceFileURLs = @[
        [NSURL fileURLWithPath:imagePath],
        [NSURL fileURLWithPath:movPath],
    ];

    // 创建一个占位图 UIImage 对象
    UIImage *placeholderImage = [UIImage imageNamed:@"IMG_1232.JPG"];

    // 请求一个 Live Photo 对象
    [PHLivePhoto requestLivePhotoWithResourceFileURLs:resourceFileURLs
                                   placeholderImage:placeholderImage
                                        targetSize:self.livePhotoView.bounds.size
                                       contentMode:PHImageContentModeAspectFill
                                       resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info) {
        if (livePhoto) {
            self.livePhotoView.hidden = NO;
            // 如果成功获取到 Live Photo 对象，则将其赋值给 PHLivePhotoView
            self.livePhotoView.livePhoto = livePhoto;
        }
        // 开始以全屏播放样式播放 Live Photo
        // [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
