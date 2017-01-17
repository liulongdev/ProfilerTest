//
//  MXRProfilerSimpleInfoViewController.m
//  easywayout
//
//  Created by Martin.Liu on 2017/1/17.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MXRProfilerSimpleInfoViewController.h"
#import "MXRProfilerUtils.h"
#import "MXRWeakProxy.h"
#import "MXRFPSObserver.h"
@interface MXRProfilerSimpleInfoViewController ()
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSByteCountFormatter *byteFormatter;
@end

@implementation MXRProfilerSimpleInfoViewController
{
    MXRFPSObserver *_fpsObserver;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.tapButton];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    
    _fpsObserver = [[MXRFPSObserver alloc] init];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    [self.view removeObserver:self forKeyPath:@"frame"];
}

- (NSTimer *)timer
{
    if (!_timer || ![_timer isValid]) {
        _timer = nil;
        _timer = [NSTimer timerWithTimeInterval:1.f target:[MXRWeakProxy proxyWithTarget:self] selector:@selector(_updateInfo) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)tapButton
{
    if (!_tapButton) {
        _tapButton = [[UIButton alloc] init];
        [_tapButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapButton;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _infoLabel.textColor = [UIColor whiteColor];
        [_infoLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _infoLabel;
}

- (NSByteCountFormatter *)byteFormatter
{
    if (!_byteFormatter) {
        _byteFormatter = [[NSByteCountFormatter alloc] init];
    }
    return _byteFormatter;
}

- (void)_updateInfo
{
    NSMutableString *mutableString = [NSMutableString string];
    [mutableString appendFormat:@"mem:%@", [self.byteFormatter stringFromByteCount:MXRProfilerResidentMemoryInBytes()]];
    [mutableString appendFormat:@"cpu:%.2f%%", MXRProfiler_CpuUsedPercent()];
    [mutableString appendFormat:@"\nfps:%ld", _fpsObserver.fpsRate];
    [mutableString appendFormat:@"\nmem:%.f%%", MXRProfiler_MemoryUsedPercent() * 100];
    self.infoLabel.text = mutableString;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect frame = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect newFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _infoLabel.frame = newFrame;
        _tapButton.frame = newFrame;
    }
}

- (void)buttonTap:(id)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    return 0;
}


@end
