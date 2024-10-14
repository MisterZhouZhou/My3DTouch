//
//  PeekAndPopViewController.m
//  My3DTouch
//
//  Created by on 2024/10/14.
//

#import "PeekAndPopViewController.h"
#import "DetailViewController.h"

@interface PeekAndPopViewController ()<UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger count;

@end

@implementation PeekAndPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 40)];
    // 开启用户交互
    self.label.userInteractionEnabled = YES;
    self.label.text = @"Peek & Pop";
    self.label.textColor = [UIColor blueColor];
    [self.view addSubview:self.label];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self registerForPreviewing];
}



#pragma mark - 注册peek and pop
- (void)registerForPreviewing {
    // iOS 9及以上且支持3D Touch
    if (@available(iOS 9.0, *)) {
        if ([self check3DTouch]) {
            // 注册代理，传入响应3D Touch的视图
            [self registerForPreviewingWithDelegate:self sourceView:self.label];
        }
    }
}

// 是否支持3D Touch
- (BOOL)check3DTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        return YES;
    }
    return NO;
}

#pragma mark - peek and pop Delegate
// pop 加重按压力度弹起的界面
- (void)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext commitViewController:(nonnull UIViewController *)viewControllerToCommit {
    // 将配置好的控制器推入导航栈
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

// peek 长按预览界面，其他区域则会变模糊
- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    self.count++;
    // 创建要返回的viewController
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.message = [NSString stringWithFormat:@"count: %ld", self.count];
    // 设置预览视图的大小
    detailVC.preferredContentSize = CGSizeMake(300, 500); // 根据需要调整大小
    // 启用其他UI元素模糊，该区域内不被虚化，通常为触摸控件的位置, 不设置，将使用系统提供的合适区域。
    previewingContext.sourceRect = self.label.frame;
    return detailVC;
}


@end
