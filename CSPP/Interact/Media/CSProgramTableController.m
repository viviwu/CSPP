//
//  CSProgramTableController.m
//  CSInvest
//
//  Created by vivi wu on 2018/3/19.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSProgramTableController.h"
#import "CSProgramTableCell.h"
#import "CSSearchProgramTableController.h"
#import "PYSearch.h"
#import "CSArticleFMViewController.h"

#define reuseID @"CSProgramTable"

@interface CSProgramTableController ()
@property(nonatomic, copy)NSArray * medias;
@end

@implementation CSProgramTableController
- (id)init{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionFooterHeight = 0;
        self.tableView.sectionHeaderHeight = 15.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"节目";
    
    self.view.backgroundColor = UIColor.whiteColor;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[CSProgramTableCell class] forCellReuseIdentifier:reuseID];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(openSearchBoard:)];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestMediasData];
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
            media.mediaType  =self.programType;
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
        });
    });
}

#define hotSeaches  @[@"私募基金", @"阳光私募", @"私募股权", @"私募经理", @"私募机构", @"私募", @"公募基金"]

- (void)openSearchBoard:(id)sender{
    // 1. Create an Array of popular search
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入关键字/时间" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[CSSearchProgramTableController alloc] init] animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    // 4. Set delegate
    searchViewController.delegate = (id)self;
    // 5. Present a navigation controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
    //    NSLog(@"%s", __func__);
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
    return _medias.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSProgramTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    // Configure the cell...
    CSMedia * media = _medias[indexPath.row];
    [cell refreshWithData:media];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMedia * media = _medias[indexPath.row];
    if (0 == media.mediaType || 2==media.mediaType) {
        return 150.0;
    }else
        return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMedia * media = _medias[indexPath.row];
    if (CSMediaTypeLive == media.mediaType || CSMediaTypeAudio ==media.mediaType) {
        CSArticleFMViewController * fm = [[CSArticleFMViewController alloc]init];
        [self.navigationController pushViewController:fm animated:YES];
    }
    
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

@end
