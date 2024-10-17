//
//  HomeViewController.m
//  My3DTouch
//
//  Created by on 2024/10/17.
//

#import "HomeViewController.h"
#import "LocalFielViewController.h"
#import "LivePhotoPickerViewController.h"
#import "PHAssetsViewController.h"
#import "PeekAndPopViewController.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *data; // 分组数据
@property (nonatomic, strong) NSArray *sectionTitles; // 分组标题

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    
    // 初始化数据
    self.data = @{
        @"PeekAndPop": @[
            @{
                @"title": @"PeekAndPop",
                @"vc": @"PeekAndPopViewController"
            },
        ],
        @"LivePhoto": @[
            @{
                @"title": @"Local File",
                @"vc": @"LocalFielViewController"
            },
            @{
                @"title": @"Picker Image",
                @"vc": @"LivePhotoPickerViewController"
            },
            @{
                @"title": @"Assets Image",
                @"vc": @"PHAssetsViewController"
            },
            @{
                @"title": @"Custom Live Photo",
                @"vc": @"CustomViewController"
            },
        ]
    };
   
    // 初始化分组标题
    self.sectionTitles = [self.data allKeys];

    // 初始化 UITableView 并设置为 Grouped 样式
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
   
    // 设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   
    // 将 UITableView 添加到视图
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
// 返回分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

// 返回每个分组中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = self.sectionTitles[section];
    NSArray *sectionData = self.data[sectionTitle];
    return sectionData.count;
}

// 配置每个单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    // 获取当前分组的标题和数据
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    NSArray *sectionData = self.data[sectionTitle];
    NSDictionary *sectionDict = sectionData[indexPath.row];
    
    // 设置单元格的文本
    cell.textLabel.text = [sectionDict valueForKey:@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
// 返回每个分组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

// 处理单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    NSArray *sectionData = self.data[sectionTitle];
    NSDictionary *sectionDict = sectionData[indexPath.row];
    
    NSLog(@"Selected Item: %@", sectionDict);
    NSString *vcStr = [sectionDict valueForKey:@"vc"];
    UIViewController *vc = [NSClassFromString(vcStr) new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
