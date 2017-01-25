//
//  MXRProfilerStandstaillListViewController.m
//  easywayout
//
//  Created by Martin.Liu on 2017/1/25.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MXRProfilerStandstaillListViewController.h"
#import "MXRProfilerMacro.h"

@interface MXRProfilerStandstaillListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation MXRProfilerStandstaillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reload) name:MXRPROFILERNOTIFICATION_HAPPENSTANDSTILL object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:MXRPROFILERNOTIFICATION_HAPPENSTANDSTILL object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss sss";
    }
    return _dateFormatter;
}

#pragma mark - UITableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MXRPROFILERINFO.standstaillInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSInteger index = indexPath.row;
    MXRProfilerStandstillInfo *standstillInfo = nil;
    if (index < MXRPROFILERINFO.standstaillInfos.count) {
        standstillInfo = MXRPROFILERINFO.standstaillInfos[index];
    }
    cell.textLabel.text = standstillInfo.currentVCClassName;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:standstillInfo.happendTimeIntervalSince1970]];
    return cell;
}

#pragma mark MXRProfilerMovableViewController

- (void)containerWillMove:(UIViewController *)container
{
    // No extra behavior
}

- (BOOL)shouldStretchInMovableContainer
{
    return YES;
}

- (CGFloat)minimumHeightInMovableContainer
{
    return 200;
}


@end
