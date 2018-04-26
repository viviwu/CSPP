//
//  InteractHomeViewController.m
//  CSPP
//
//  Created by csco on 2018/4/20.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "InteractHomeViewController.h"
#import "XWSegmentedControl.h"
//#import "XWScrollBanner.h"
#import "PYSearch.h"

#define kSearchPlaceholder @"视频关键字"
@interface InteractHomeViewController ()

@property(nonatomic) XWSegmentedControl * segCtr;
@property(nonatomic, copy) NSArray<NSString*>* sectionTitles;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation InteractHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTitles = @[@"推荐", @"直播", @"问答", @"沙龙", @"观点"];
    _segCtr = [[XWSegmentedControl alloc]initWithSectionTitles:self.sectionTitles];
    _segCtr.frame = CGRectMake(0, 50.0, kSelfVB_W-100.0, 35.0);
    _segCtr.backgroundColor = [UIColor clearColor];
    _segCtr.indicatorLocation = XWSegIndicatorLocationDown;
    _segCtr.verticalDividerEnabled=YES;
    _segCtr.verticalDividerColor = UIColor.clearColor;
    _segCtr.indicatorColor = UIColor.orangeColor;
    _segCtr.indicatorHeight = 1.0;
    _segCtr.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor yellowColor]};
    [_segCtr addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segCtr.selectedIndex = 0;
    _segCtr.clipsToBounds = YES;
    _segCtr.layer.cornerRadius = 8.0;
    self.navigationItem.titleView = _segCtr;
    
    self.safeTop=64.0;
    if (kDevice_Is_iPhoneX) {
        self.safeTop=88.0;
    }
    
    //    [self.view addSubview:_segCtr];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.safeTop, kSelfVB_W, kSelfVB_H)];
    self.scrollView.contentSize = CGSizeMake(kScreenW*5, 0);
    [self.view addSubview:self.scrollView];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    [self addSubViewControllers];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [self segmentAction:_segCtr];
    [super viewDidAppear:animated];
}

- (void)segmentAction:(XWSegmentedControl *)sender
{
    NSInteger index = sender.selectedIndex;
    
    [self transChildViewControllerWith:index];
    [self.scrollView setContentOffset:CGPointMake(kScreenW*index, 0)];
    //    [self.scrollView scrollRectToVisible:CGRectMake(kScreenW*index, 0, kScreenW, kSelfVB_H) animated:YES];
}

- (void)addSubViewControllers{
    
//    CSMediaReaderTableController * items = [[CSMediaReaderTableController alloc]init];
//    CSFAQTableController * faq = [[CSFAQTableController alloc]init];
//    CSSalonTableController * salon = [[CSSalonTableController alloc]init];
    CSLiveChatsController * chatbar = [[CSLiveChatsController alloc]init];
    
    [items.view setFrame:CGRectMake(0, 0, kScreenW, kSelfVB_H)];
    [chatbar.view setFrame:CGRectMake(kScreenW, 0, kScreenW, kSelfVB_H)];
    [faq.view setFrame:CGRectMake(kScreenW, 2, kScreenW, kSelfVB_H)];
    [salon.view setFrame:CGRectMake(kScreenW*3, 0, kScreenW, kSelfVB_H)];
    
    [self addChildViewController:items];
    [self addChildViewController:chatbar];
    [self addChildViewController:faq];
    [self addChildViewController:salon];
    
    [self.scrollView addSubview:items.view];
    self.scrollView.delegate = (id)self;
}

- (void)transChildViewControllerWith:(NSInteger)index{
    id vc = self.childViewControllers[index];
    UIView * view = [vc valueForKey:@"view"];
    [self.scrollView addSubview: view];
}
#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segCtr setSelectedSegmentIndex:page animated:YES];
    [self transChildViewControllerWith:page];
}

#pragma mark--UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // 1. Create an Array of popular search
    NSArray * hotSeaches = @[@"路演", @"小薇直播", @"世纪理财"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"CSProductSearchPlaceholderText", @"查净值/产品/基金经理") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[CSSearchVideoTableController alloc] init] animated:YES];
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
    return NO;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES]; // 动画显示取消按钮
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

@end
