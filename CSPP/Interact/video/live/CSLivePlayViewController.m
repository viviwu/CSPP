//
//  CSLivePlayViewController.m
//  CSPP
//
//  Created by csco on 2018/3/27.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSLivePlayViewController.h"
#import "RecordeViewController.h"
#import "LivePlayOperationView.h"
#import "KSYUIVC.h"
#import "AppDelegate.h"
#import "PlayerViewModel.h"
#import "VideoModel.h"

@interface CSLivePlayViewController ()

@property (nonatomic, strong) RecordeViewController     *recordeController;
@property (nonatomic, strong) LivePlayOperationView     *playOperationView;
@property (nonatomic, assign) NSInteger                  rotateIndex;

@end

@implementation CSLivePlayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rotateIndex = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self setupUI];
    [self setupOperationBlock];
}


#pragma mark ------ reloadPushFromSuspendHandler

- (void)reloadPushFromSuspendHandler {
    
    [self.view insertSubview:self.player.view atIndex:0];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSInteger definitationIndex = self.currentVideoModel.definitation.integerValue;
    NSString *urlStr = nil;
    if (definitationIndex >= self.currentVideoModel.PlayURL.count) {
        return;
    }
    
    urlStr = self.currentVideoModel.PlayURL[definitationIndex];
    [self.player reset:NO];
    [self.player setUrl:[NSURL URLWithString:urlStr]];
    [self.player prepareToPlay];
    [self.playOperationView configeWithVideoModel:self.currentVideoModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
#pragma mark --播放直播视频时 禁止滑动返回手势！！！
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#pragma mark-- 直接停止播放吧！
    [self.player stop];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL fullScreen = (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft);
    if (fullScreen) {
        [self.playerViewModel fullScreenHandlerForLivePlayController:self isFullScreen:!fullScreen];
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
 
    //允许手势
    if ([self.navigationController respondsToSelector: @selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)dealloc {
    NSLog(@"CSLivePlayViewController dealloced");
}

- (void)setFullScreen:(BOOL)fullScreen {
    self.playOperationView.fullScreen = fullScreen;
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL fullScreen = (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft);
    [self.playerViewModel fullScreenHandlerForLivePlayController:self isFullScreen:fullScreen];
}

- (void)setupUI {
    [self.view addSubview:self.playOperationView];
    [self.playOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        if ([[KSYGetDeviceName getDeviceName] isEqual:@"iPhoneX"]) {
            if (@available(iOS 11.0, *)) {
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44.0);//
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            make.edges.equalTo(self.view);
        }
    }];
}

- (LivePlayOperationView *)playOperationView {
    if (!_playOperationView) {
        __weak typeof(self) weakSelf = self;
        _playOperationView = [[LivePlayOperationView alloc] initWithVideoModel:self.currentVideoModel FullScreenBlock:^(BOOL isFullScreen) {
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.playerViewModel fullScreenHandlerForLivePlayController:self isFullScreen:isFullScreen];
        }];
        
    }
    return _playOperationView;
}

- (void)setupOperationBlock  {
    
    __weak typeof(self) weakSelf = self;
    
    self.recordeController = [[RecordeViewController alloc] initWithPlayer:self.player screenRecordeFinishedBlock:^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view sendSubviewToBack:strongSelf.playOperationView];
        [strongSelf.view sendSubviewToBack:strongSelf.player.view];
    }];
    
    self.playOperationView.playStateBlock = ^(VCPlayHandlerState state) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (state == VCPlayHandlerStatePause) {
            [strongSelf.player pause];
        } else if (state == VCPlayHandlerStatePlay) {
            [strongSelf.player play];
        }
    };
    self.playOperationView.screenShotBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        UIImage *thumbnailImage = strongSelf.player.thumbnailImageAtCurrentTime;
        [KSYUIVC saveImageToPhotosAlbum:thumbnailImage];
    };
    self.playOperationView.screenRecordeBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view addSubview:strongSelf.recordeController.view];
        [strongSelf addChildViewController:strongSelf.recordeController];
        [strongSelf.recordeController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(strongSelf.view);
        }];
        [strongSelf.recordeController startRecorde];
    };
    // 镜像block
    self.playOperationView.mirrorBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.player.mirror = !strongSelf.player.mirror;
    };
    // 画面旋转block
    self.playOperationView.pictureRotateBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        NSArray *rotates = @[@0, @90, @180, @270];
        if (strongSelf.rotateIndex < rotates.count) {
            strongSelf.player.rotateDegress = [rotates[strongSelf.rotateIndex] intValue];
            strongSelf.rotateIndex += 1;
        } else {
            strongSelf.rotateIndex = 0;
            strongSelf.player.rotateDegress = [rotates[strongSelf.rotateIndex] intValue];
            strongSelf.rotateIndex += 1;
        }
    };
}

- (void)setPlayerViewModel:(PlayerViewModel *)playerViewModel {
    _playerViewModel = playerViewModel;
    [self configeVideoModel:_playerViewModel.playingVideoModel];
}

#pragma mark --
#pragma mark - notification handler

-(void)handlePlayerNotify:(NSNotification*)notify {
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
        if(((self.player.naturalRotate / 90) % 2  == 0 && self.player.naturalSize.width > self.player.naturalSize.height) ||
           ((self.player.naturalRotate / 90) % 2 != 0 && self.player.naturalSize.width < self.player.naturalSize.height))
        {
            //如果想要在宽大于高的时候横屏播放，你可以在这里旋转
            UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
            orientation = UIInterfaceOrientationLandscapeRight;
            [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
        }
    }
    [self notifyHandler:notify];
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
