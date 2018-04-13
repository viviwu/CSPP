//
//  CSVodPlayListController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "CSVodPlayListController.h"
#import "CSVodPlayController.h"
#import "PlayerViewModel.h"
#import "VideoModel.h"
#import "PlayerTableViewCell.h"
#import "AppDelegate.h"
#import "VodPlayOperationView.h"

@interface CSVodPlayListController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView              *videoTableView;

@end

@implementation CSVodPlayListController

- (CSVodPlayController *)playVC {
    if (!_playVC) {
        _playVC = [[CSVodPlayController alloc] initWithVideoModel:_playerViewModel.playingVideoModel];
        _playVC.playerViewModel = _playerViewModel;
    }
    return _playVC;
}

- (UITableView *)videoTableView {
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _videoTableView.dataSource = self;
        _videoTableView.delegate = self;
        _videoTableView.rowHeight = 88;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _videoTableView.backgroundColor = [UIColor blackColor];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PlayerTableViewCell" bundle:nil] forCellReuseIdentifier:kPlayerTableViewCellId];
    }
    return _videoTableView;
}

- (void)setPlayerViewModel:(PlayerViewModel *)playerViewModel
{
    _playerViewModel = playerViewModel;
    _playerViewModel.owner = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.videoTableView];
    [self.view addSubview:self.playVC.view];
    [self addChildViewController:self.playVC];
    //适配iphoneX
    [self.playVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([[KSYGetDeviceName getDeviceName] isEqual:@"iPhoneX"]) {
            make.leading.trailing.equalTo(self.view);
            make.top.equalTo(self.view).offset(SafeAreaStatusBarTopHeight);
            make.height.mas_equalTo(211);
        }
        else {
            make.leading.trailing.top.equalTo(self.view);
            make.height.mas_equalTo(211);
        }
    }];
    [self.videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(211+SafeAreaStatusBarTopHeight);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = YES;
}

- (void)dealloc {
    NSLog(@"VodListPlayController dealloced");
}


#pragma mark --
#pragma mark - table dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _playerViewModel.videoListViewModel.listViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayerTableViewCellId];
    if (indexPath.row < _playerViewModel.videoListViewModel.listViewDataSource.count) {
        [cell configeWithVideoModel:_playerViewModel.videoListViewModel.listViewDataSource[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.playerViewModel.currPlayingIndex == indexPath.row) {
        return;
    }
    if (indexPath.row < _playerViewModel.videoListViewModel.listViewDataSource.count) {
        VideoModel *videoModel = _playerViewModel.videoListViewModel.listViewDataSource[indexPath.row];
        [self.playVC reload:[NSURL URLWithString:videoModel.PlayURL.firstObject]];
        self.playerViewModel.playingVideoModel = videoModel;
        self.playerViewModel.currPlayingIndex = indexPath.row;
    }
}

#pragma mark -
#pragma mark - Notifications

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL fullScreen = (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft);
    [self.playerViewModel fullScreenButtonClickedHandlerForPlayController:self.playVC isFullScreen:fullScreen];
}


@end
