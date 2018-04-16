//
//  PPManagersRankTableController.m
//  CSPP
//
//  Created by vivi wu on 2018/4/15.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "PPManagersRankTableController.h"
#import "XWScrollBanner.h"
#import "XWFilterView.h"

@interface PPManagersRankTableController ()
@property (weak, nonatomic) IBOutlet UIView *headerBoard;
@property (strong, nonatomic) XWFilterView * filterView;
@property (weak, nonatomic) IBOutlet XWScrollBanner *scrollBanner;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *sectionHeader;

@end

@implementation PPManagersRankTableController

- (XWFilterView *)filterView{
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    CGFloat startY = 230.0-self.tableView.contentOffset.y;
    
    if (nil ==_filterView) {
        NSMutableArray * dataSource = [NSMutableArray array];
        for (int i=0; i<7; i++) {
            NSMutableArray * sectionSource = [NSMutableArray array];
            for (int k=0; k<arc4random()%4+3; k++) {
                XWFilter * filter = [[XWFilter alloc]init];
                filter.title = [NSString stringWithFormat:@"(%d,%d)", i, k];
                filter.sectionTitle = [NSString stringWithFormat:@"Section-%d", i];
                [sectionSource addObject:filter];
            }
            [dataSource addObject:sectionSource];
        }
        _filterView =[[XWFilterView alloc]initWithFrame:CGRectMake(0, startY, self.view.frame.size.width, self.view.frame.size.height - startY- safeBottom) dataSource:dataSource];
    }
    return _filterView;
}

- (void)xxx{
    //        NSArray * arr = @[@[@"按区间收益", @"按夏普比率"], @[@"不限", @"自主发行", @"公墓专户", @"券商资管", @"期货资管"], @[@"不限", @"自主发行", @"公墓专户", @"券商资管", @"期货资管"]];
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
        NSLog(@"safeBottom==%f", safeBottom);
        NSLog(@"%f", self.view.safeAreaInsets.left + self.view.safeAreaInsets.right);
    } else {
        // Fallback on earlier versions
    }
    NSLog(@"self.tableView.contentOffset.y==%f", self.tableView.contentOffset.y);
    CGFloat startY = 180.0-self.tableView.contentOffset.y;
    self.filterView.selectHandle = ^(NSIndexPath * indexPath, NSString  * title){
        NSLog(@"%@",title);
    };
    self.filterView.multiResulter = ^(NSArray * results){
        for (XWFilter * model in results) {
            NSLog(@"results:%@", model.title);
        }
    };
    
    [self.filterView setFrame:CGRectMake(0, startY, self.view.frame.size.width, self.view.frame.size.height - startY- safeBottom)];
    [self.view addSubview:self.filterView];
    //    [self.view bringSubviewToFront:self.filterView];
}
- (IBAction)stockStrategy:(id)sender {
    [self xxx];
}

- (IBAction)regionSelected:(id)sender {
    [self xxx];
}

- (IBAction)typeFilter:(id)sender {
    [self xxx];
}

- (IBAction)investDirection:(id)sender {
    [self xxx];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _scrollBanner.dataSource = sources;
    _scrollBanner.bannerClickHandle = ^(NSInteger currentPage, XWBannerModel * model){
        NSLog(@"currentPage is: %ld", currentPage);
    };
    
    _menuView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _menuView.layer.borderWidth = 0.25;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fund" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionHeader;
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
