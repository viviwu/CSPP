//
//  PPTableViewController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/20.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSInteractViewController.h"
#import "CSSearchViewController.h"
#import "CSTableMenuHeader.h"
#import "CSTableFeedCell.h"
#import "CSMenuCell.h"

#import "CSNewsBoardController.h"

#import "PYSearch.h"
#import "SZCalendarPicker.h"

#import "XWScrollBanner.h"
#import "DVVMovingTextView.h"

#import "LiveSpeechTableController.h"

@interface CSInteractViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet XWScrollBanner *newsBoard;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CSTableMenuHeader *menuHeader;
@property (weak, nonatomic) IBOutlet UIView *tableFooter;
@property (nonatomic, strong) UIView * mediaToolbar;

@property (nonatomic, strong) DVVMovingTextView *movingTextView;
@property (nonatomic, strong) CSNewsBoardController *newsBoardController;
@property(nonatomic, copy)NSArray * medias;
//@property(nonatomic, copy) NSDictionary * channels;
@property(nonatomic, copy) NSArray<NSString*>* sectionTitles;
@property(nonatomic, copy) NSArray<NSString*>* sectionImages;

@end

@implementation CSInteractViewController

- (UIView*)mediaToolbar
{
    if (!_mediaToolbar) {
        CGFloat toolbarH = 44.0, buttom = 49.0+toolbarH;
        if (kDevice_Is_iPhoneX) {
            buttom += 34.0;
        }
        _mediaToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-buttom, kScreenW, toolbarH)];
        _mediaToolbar.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_mediaToolbar];
    }
    return _mediaToolbar;
}

- (CSNewsBoardController*)newsBoardController{
    if (nil== _newsBoardController) {
        _newsBoardController = [[CSNewsBoardController alloc]initWithViewFrame:self.newsBoard.bounds];
        [self.newsBoard addSubview:_newsBoardController.view];
    }
    return _newsBoardController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionTitles = @[@"路演", @"聊吧", @"问答", @"沙龙", @"观点", @"Live"/*, @"FM资讯", @"私募学院"*/];
    self.sectionImages = @[@"camcorder_pro", @"webcam", @"faq", @"invite", @"idea", @"lightning" /*, @"voice_presentation", @"customer_support", @"graduation_cap"*/];
//    [self.view bringSubviewToFront:self.mediaToolbar];
    
    NSArray * models = [self fakeModels];
    NSMutableArray * sources = [NSMutableArray array];
    for (int i=0; i<models.count; i++) {
        NSDictionary * model = models[i];
        XWBannerModel *bannerModel = [[XWBannerModel alloc]init];
        bannerModel.title = model[@"rank"];
        bannerModel.imgURL = [NSURL URLWithString:model[@"image"]];
        bannerModel.link = model[@"url"];
        [sources addObject:bannerModel];
    }
    _newsBoard.dataSource = sources;
    _newsBoard.bannerClickHandle = ^(NSInteger currentPage, XWBannerModel * model){
        NSLog(@"currentPage is: %ld", currentPage);
    };
    self.tableView.tableHeaderView = _newsBoard;
    
    //如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
#ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparence"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [_newsBoard stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY==%f", offsetY);
    if (offsetY >= self.newsBoard.bounds.size.height - SafeAreaTopHeight) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparence"] forBarMetrics:UIBarMetricsDefault];
    }
     */
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.newsBoard setMedia:[CSNewsBoard demoTextNews]];
    if (_medias.count<1) {
        [self requestMediasData];
    }
    [self.menuHeader setMovingText];
    
}

- (IBAction)datePickerAction:(UIButton *)sender {
    NSLog(@"B:%s", __func__);
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, self.safeTop, kSelfVB_W, 352.0);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString * dateStr =[NSString stringWithFormat:@"%li/%li",(long)month,(long)day];
        //            NSLog(@"dateStr:%@", dateStr);
        [sender setTitle:dateStr forState:UIControlStateNormal];
    };
}

#define hotSeaches  @[@"私募基金", @"阳光私募", @"私募股权", @"私募经理", @"私募机构", @"私募", @"公募基金"]
- (IBAction)searchAll:(id)sender {
    // 1. Create an Array of popular search
    //    hotSeaches
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入关键字/时间" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        CSSearchViewController * vc = [[CSSearchViewController alloc]init];
        vc.title = searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    // 4. Set delegate
    searchViewController.delegate = (id)self;
    // 5. Present a navigation controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- PYSearchViewControllerDelegate

- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"%@ Search suggestion %d", searchText, i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    id vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"search_all"]) {
   
    }else{
        
    }
     */
}

#pragma mark-- UICollectionView DataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CSMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
    NSString * title = self.sectionTitles[indexPath.row];
    NSString * image = self.sectionImages[indexPath.row];
    [cell refreshData:@[title, image]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sectionTitles.count;
}

#pragma mark--UICollection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    NSString * identifier = nil;
    switch (indexPath.row) {
        case 0:
            identifier = kSegue_roadShow;
            break;
        case 1:
            identifier = kSegue_faceTime;
            break;
        case 2:
            identifier = kSegue_faq;     //;
            //            identifier = kSegue_consult;     //;
            break;
        case 3:
            identifier = kSegue_salon;
            break;
        case 4:
            //            identifier = kSegue_opinion;     //;
            break;
        case 5:{
//            identifier = kSegue_liveclass;     //kSegue_faq;
            LiveSpeechTableController * live =[self liveStoryboardControllerWithID:@"LiveSpeechTableController"];
            [self.navigationController pushViewController:live animated:YES];
        }
            break;
        case 6:
            
            break;
        case 7:
//            identifier = kSegue_newsFM;
            break;
        case 8:
//            identifier = kSegue_ppAcademy;
            break;
        default:
            break;
    }
    if (identifier) {
        [self performSegueWithIdentifier:identifier sender:nil];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _medias.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CSTableFeedCell * cell =[tableView dequeueReusableCellWithIdentifier:@"feed" forIndexPath:indexPath];
    
    CSMedia * media = _medias[indexPath.row];
    [cell refreshWithData:media];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _menuHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}

#pragma mark--UITable View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    CSMedia * media = _medias[indexPath.row];
    [self.newsBoardController setMedia:media];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestMediasData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        //把逻辑计算等需要消耗长时间的任务，放在此处的全局共享的并发队列执行；
        NSDictionary * data = [self readJsonFile:@"hotShow"][@"data"];
        NSArray * finished_list = data[@"finished_dic"][@"list"];
        NSArray * unfinish_list = data[@"unfinish_list"];;
        NSMutableArray * media_list = [NSMutableArray array];
        [media_list addObjectsFromArray:finished_list];
        [media_list addObjectsFromArray:unfinish_list];
        [media_list addObjectsFromArray:[media_list mutableCopy]];
        
        NSMutableArray * list = [NSMutableArray array];
        for (int i=0 ; i<media_list.count; i++) {
            NSDictionary * theme = media_list[i];
            //        NSLog(@"theme=%@", theme);
            CSMedia * media = [[CSMedia alloc]init];
            media.title = theme[@"room_title"];
            media.mediaType  =arc4random()%3;
            media.author = theme[@"room_host_title"]?:@"嘉宾：QWERTY";
            media.date = [[NSDate date]dateByAddingTimeInterval:1800*(i-8)];
            if (i<5) {
                media.heat = arc4random()%1346+786;
                media.published=YES;
            }else{
                media.published=NO;
                media.heat = 0;
            }
            
            [list addObject:media];
        }
        _medias = [list copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程更新UI界面；
            [self.tableView reloadData];
//            [self.newsBoardController setMedia:list.firstObject];
        });
    });
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSArray*)fakeModels{
    return @[
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/1049db96aaf99f3f92fc225c006648a6.jpg",
                 @"url" : @"https://h5.jinfuzi.com/app/community/communityDetail?articleId=6816",
                 @"rank" : @"202"
                 },
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/f601d614da6a1a56f30da4fe5fd5e501.jpg",
                 @"url" : @"https://h5.jinfuzi.com/topic/pevc/tg-34",
                 @"rank" : @"201"
                 },
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/e0ffc289900db4adb9060df0cedf056b.jpg",
                 @"url" : @"https://h5.jinfuzi.com/vueApp/community/communityDetail/5650",
                 @"rank" : @"200"
                 },
             @{
                 @"image" : @"https://jfz-static2.oss-cn-hangzhou.aliyuncs.com/main/img/92a7d6f5a9d2996342becbaaf6391fde.jpg",
                 @"url" : @"https://h5.jinfuzi.com/topic/pof/tg-135",
                 @"rank" : @"194"
                 },
             @{
                 @"image" : @"https://oss-cn-hangzhou.aliyuncs.com/jfzapp-static2/ad/89f6c1a5a9ebf5e15277087502388800.jpg",
                 @"url" : @"https://h5.jinfuzi.com/activity/other/tg20",
                 @"rank" : @"190"
                 },
             @{
                 @"image" : @"https://jfz-static2.oss-cn-hangzhou.aliyuncs.com/main/img/96de6f1a5cb64f9f99ace06b8e04bffe.jpg",
                 @"url" : @"https://h5.jinfuzi.com/topic/pevc/tg-30",
                 @"rank" : @"162"
                 }
             ];
}


@end

