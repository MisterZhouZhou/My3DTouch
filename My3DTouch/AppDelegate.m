//
//  AppDelegate.m
//  My3DTouch
//
//  Created by on 2024/9/26.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建 3D Touch 配置菜单
    [self createShortcuts];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - ShortcutItem Click Delegate
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    if ([shortcutItem.type isEqualToString:@"com.touch.home"]) { // 首页
        NSLog(@"首页");
        return;
    }
    if ([shortcutItem.type isEqualToString:@"com.touch.qiche"]) { // 车辆
        NSLog(@"车辆");
        return;
    }
    if ([shortcutItem.type isEqualToString:@"com.touch.faxian"]) { // 发现
        NSLog(@"发现");
        return;
    }
    if ([shortcutItem.type isEqualToString:@"com.touch.wode"]) { // 我的
        NSLog(@"我的");
        return;
    }
}


- (void)createShortcuts {
    if (@available(ios 9.1, *)) {
        // 首页
        UIApplicationShortcutItem *homeShoreItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.touch.home" localizedTitle:@"首页" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName: @"tab_shouye_normal"] userInfo:nil];
        // 我的
        UIApplicationShortcutItem *carShoreItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.touch.qiche" localizedTitle:@"车辆" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithTemplateImageName: @"tab_che_normal"] userInfo:nil];
        // 发现
        UIApplicationShortcutItem *disShoreItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.touch.faxian" localizedTitle:@"发现" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName: @"tab_discover_normal"] userInfo:nil];
        // 我的
        UIApplicationShortcutItem *myShoreItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.touch.wode" localizedTitle:@"我的" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithTemplateImageName: @"tab_wode_normal"] userInfo:nil];
        // 赋值给Application的shortcutItems
        [UIApplication sharedApplication].shortcutItems = @[homeShoreItem, carShoreItem, disShoreItem, myShoreItem];
    }
}

@end
