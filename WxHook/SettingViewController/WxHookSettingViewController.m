//
//  WxHookSettingViewController.m
//  WxHook
//
//  Created by AQY on 2018/3/29.
//

#import "WxHookApplication.h"

#import "WxHookSettingViewController.h"
#import "WxHookSettingTableViewCell.h"

#import "WxHookSimulateLocationViewController.h"

@interface WxHookSettingViewController ()
<UITableViewDelegate, UITableViewDataSource, WxHookSettingTableViewCellDelegate>

@property (nonatomic, strong) NSArray <NSArray <WxHookSettingModel *> *> * models;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation WxHookSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Hook 设置";
    self.view.backgroundColor = [UIColor colorWithRed:0.926 green:0.926 blue:0.926 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exitSettingViewController:)];

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    WxHookSettingModel * model = [[WxHookSettingModel alloc] init];
    model.modelType = WxHookSettingModelTypeNormal;
    model.title = @"模拟定位";
    
    WxHookSettingModel * model1 = [[WxHookSettingModel alloc] init];
    model1.modelType = WxHookSettingModelTypeSwitch;
    model1.title = @"自动领取红包";
    [model1 setResetCellWidgetProperty:^(WxHookSettingTableViewCell *cell) {
        [cell.onSwitch setOn:[WxHookApplication sharedInstance].autoOpenRedPacket animated:YES];
    }];
    model1.desc = [NSString stringWithFormat:@"已经领取了 %d 个红包", [WxHookApplication sharedInstance].receiveRedPacketCount];
    
    self.models = @[@[model, model1]];
}

- (void)exitSettingViewController:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - WxHookSettingTableViewCellDelegate
- (void)wxHookSettingTableViewCell:(WxHookSettingTableViewCell *)cell onSwitchChanged:(BOOL)isOn {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [WxHookApplication sharedInstance].autoOpenRedPacket = isOn;
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.models objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WxHookSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[WxHookSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.model = [[self.models objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSArray <WxHookSettingModel *> * arr = [self.models objectAtIndex:section];
    return [arr objectAtIndex:arr.count - 1].desc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        WxHookSimulateLocationViewController * vc = [[WxHookSimulateLocationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

+ (UINavigationController *)settingNavigationController {
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:[WxHookSettingViewController new]];
    return navigationController;
}

@end
