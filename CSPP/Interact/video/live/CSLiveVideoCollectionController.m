//
//  CSLiveVideoCollectionController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSLiveVideoCollectionController.h"
#import "CSReusePicHeader.h"
#import "CSPicLabCell.h"

#import "VideoListViewModel.h"
#import "VideoModel.h"
#import "PlayerViewModel.h"

#import "UIView+Toast.h"
#import "CSLivePlayViewController.h"
 
@interface CSLiveVideoCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) VideoListViewModel  *videoListViewModel;

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

@end

@implementation CSLiveVideoCollectionController

static NSString * const reuseIdentifier = @"FaceTime";
static NSString * const reuseId = @"facetime";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchDatasource];
 
    // Do any additional setup after loading the view.
}

// 检测stringQR是否是合法的点播地址，根据视频地址的命名规则自行修改
- (BOOL)legalUrl:(NSString *)rul {
    __block BOOL legal = NO;
    NSArray<NSString*> *legals = @[@".flv", @".m3u8", @".mov", @".mp4", @".avi", @".rmvb", @".mkv"];
    [legals enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([rul containsString:obj]) {
            legal = YES;
            *stop = YES;
        }
    }];
    return legal;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)fetchDatasource {
    NSString *urlString = [NSString stringWithFormat:@"https://appdemo.download.ks-cdn.com:8682/api/GetLiveUrl/2017-01-01?Option=1"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                strongSelf.videoListViewModel = [[VideoListViewModel alloc] initWithJsonResponseData:data];
                [strongSelf.collectionView reloadData];
                [strongSelf.view hideToastActivity];
            } else {
                NSLog(@"Fetch video data error----- : %@",error);
            }
        });
    }];
    [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * indexPath = self.collectionView.indexPathsForSelectedItems.lastObject;
    NSInteger selectedIndex = indexPath.row;
    
    if (indexPath.row < self.videoListViewModel.listViewDataSource.count && [segue.identifier isEqualToString:@"livePlay"]) {
        VideoModel * videoModel = self.videoListViewModel.listViewDataSource[selectedIndex];
        if (videoModel) {
            PlayerViewModel *playerViewModel = [[PlayerViewModel alloc] initWithPlayingVideoModel:videoModel videoListViewModel:_videoListViewModel selectedIndex:selectedIndex];
            
            CSLivePlayViewController *livePlayVC = segue.destinationViewController;
            livePlayVC.playerViewModel = playerViewModel;
            [livePlayVC reloadPushFromSuspendHandler];
        }
    }
}

- (void)dealloc
{
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n %s \n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n", __func__);
    NSLog(@"_videoListViewModel == %@", _videoListViewModel);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return self.videoListViewModel.listViewDataSource.count;
}

- (CSPicLabCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSPicLabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (indexPath.row < self.videoListViewModel.listViewDataSource.count) {
        VideoModel * video = self.videoListViewModel.listViewDataSource[indexPath.row];
        if (!video) {
            NSLog(@"!video------------!!!!!!!!!!!!!");
        }
        [cell configeWithVideoModel:video];
    }
    return cell;
}


#pragma mark <UICollectionViewDelegate>
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CSReusePicHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId forIndexPath:indexPath];
    
    [header configeVideoModel:self.videoListViewModel.listViewDataSource.firstObject];
    return header;
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
