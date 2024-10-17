//
//  DetailViewController.m
//  My3DTouch
//
//  Created by on 2024/10/14.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调整布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.imageView];
    self.label.text = self.message;
    [self.view addSubview:self.label];
}

#pragma mark - previewActionItems Delegate
//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
//    UIPreviewAction *noReadAction = [UIPreviewAction actionWithTitle:@"标为未读" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"标为未读");
//        NSLog(@"%@", self.label.text);
//    }];
//    
//    UIPreviewAction *stickAction = [UIPreviewAction actionWithTitle:@"置顶" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"置顶");
//    }];
//
//    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"删除");
//    }];
//    
//    return @[noReadAction, stickAction, deleteAction];
//}

//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
//    UIPreviewAction *noReadAction = [UIPreviewAction actionWithTitle:@"标为未读" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"标为未读");
//    }];
//    
//    UIPreviewAction *stickAction = [UIPreviewAction actionWithTitle:@"置顶" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"置顶");
//    }];
//
//    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"删除");
//    }];
//    
//    UIPreviewActionGroup *group = [UIPreviewActionGroup actionGroupWithTitle:@"group" style:UIPreviewActionStyleDefault actions:@[noReadAction,stickAction]];
//        
//    return @[group, deleteAction];
//}

#pragma mark - getters
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(150, 200, 150, 40)];
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _imageView.image = [UIImage imageNamed:@"girl"];
    }
    return _imageView;
}

@end
