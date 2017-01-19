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
#import "MXRProfilerMacro.h"
@interface MXRProfilerSimpleInfoViewController ()
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSByteCountFormatter *byteFormatter;

@property (nonatomic, assign) CGFloat cpuUsed;
@property (nonatomic, assign) NSInteger fpsRate;
@property (nonatomic, assign) CGFloat memoryUsed;

@end

@implementation MXRProfilerSimpleInfoViewController
{
    MXRFPSObserver *_fpsObserver;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.tapButton];
    self.view.backgroundColor = RGBAHEX(0x000000, 0.6);
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.timer fire];
    
    _fpsObserver = [[MXRFPSObserver alloc] init];
    [_fpsObserver addObserver:self forKeyPath:@"fpsRate" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mxr_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mxr_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    [self.view removeObserver:self forKeyPath:@"frame"];
    [_fpsObserver removeObserver:self forKeyPath:@"fpsRate"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)mxr_applicationWillResignActive:(NSNotification *)noti
{
    [_timer invalidate];
}

- (void)mxr_applicationDidBecomeActive:(NSNotification *)noti
{
    [self.timer fire];
}

- (NSTimer *)timer
{
    if (!_timer || ![_timer isValid]) {
        _timer = nil;
        _timer = [NSTimer timerWithTimeInterval:1.f target:[MXRWeakProxy proxyWithTarget:self] selector:@selector(_updateInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
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
        _infoLabel.font = [UIFont systemFontOfSize:12];
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

- (void)setFpsRate:(NSInteger)fpsRate
{
    _fpsRate = fpsRate;
    [self setDisplayImediately];
}

- (void)setCpuUsed:(CGFloat)cpuUsed
{
    _cpuUsed = cpuUsed;
    [self setDisplayImediately];
}

- (void)setMemoryUsed:(CGFloat)memoryUsed
{
    _memoryUsed = memoryUsed;
    [self setDisplayImediately];
}

- (void)setDisplayImediately
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async_on_main_queue(^{
        [weakSelf _updateDisplayInfo];
    });
}

- (void)_updateDisplayInfo
{
    NSMutableString *mutableString = [NSMutableString string];
//    [mutableString appendFormat:@"mem:%@", [self.byteFormatter stringFromByteCount:MXRProfilerResidentMemoryInBytes()]];
    [mutableString appendFormat:@"cpu:%.f%%", self.cpuUsed * 100];
    [mutableString appendFormat:@"\nfps:%ld", self.fpsRate];
    [mutableString appendFormat:@"\nmem:%.f%%", self.memoryUsed * 100];
    self.infoLabel.text = mutableString;
}

- (void)_updateInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.cpuUsed = MXRProfiler_CpuUsedPercent();
        self.memoryUsed = MXRProfiler_MemoryUsedPercent();
    });
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
    else if ([keyPath isEqualToString:@"fpsRate"]) {
        NSInteger fpsRate = [change[NSKeyValueChangeNewKey] integerValue];
        self.fpsRate = fpsRate;
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
