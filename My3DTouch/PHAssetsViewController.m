//
//  PHAssetsViewController.m
//  My3DTouch
//
//  Created by on 2024/10/15.
//

#import "PHAssetsViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface PHAssetsViewController ()

@property(nonatomic, strong) PHLivePhotoView *livePhotoView;

@end

@implementation PHAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PHAsset to Live Photo";
    
    // 调整布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 图片选取
    UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 140, 30)];
    [pickerButton setTitle:@"Picker PHAsset" forState:UIControlStateNormal];
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
}

#pragma mark - 获取相册第一张 Live Photo
- (void)buttonClick {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    // 按创建日期降序排列
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    // 获取资产（照片或视频）列表
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    // 查找一张live photo
    __block PHAsset *asset;
    [assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass: [PHAsset class]]) {
            PHAsset *tmpAsset = (PHAsset*)obj;
            if (tmpAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                asset = tmpAsset;
                *stop = YES;
            }
        }
        NSLog(@"%@", obj);
    }];
    if (asset) {
        // PHAsset 转 live photo
        [[PHImageManager defaultManager] requestLivePhotoForAsset:asset
           targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)
           contentMode:PHImageContentModeAspectFit
           options:nil
           resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            if (livePhoto) {
                self.livePhotoView.hidden = NO;
                // 将获取到的 Live Photo 设置给 PHLivePhotoView
                self.livePhotoView.livePhoto = livePhoto;
            }
        }];
    }
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
