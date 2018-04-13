//
//  PPRankViewController.m
//  CSPP
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "PPRankViewController.h"
#import "PPFundsRankTableController.h"

@interface PPRankViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtr;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PPFundsRankTableController *fundsRankTableController;

@end

@implementation PPRankViewController

- (id)PPRankStoryboardControllerWithID:(NSString*)stroyboardID{
    return [[UIStoryboard storyboardWithName:@"PPRank" bundle:nil] instantiateViewControllerWithIdentifier:stroyboardID];
}

- (PPFundsRankTableController *)fundsRankTableController{
    if(nil ==_fundsRankTableController){
        _fundsRankTableController = [self PPRankStoryboardControllerWithID:@"PPFundsRankTableController"];
    }
    return _fundsRankTableController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreenW, kScreenH)];
    [self.view addSubview:self.scrollView];
    self.scrollView.scrollsToTop = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenW * 3, 0);
    self.scrollView.pagingEnabled = YES;
    
    [self addChildViewController:self.fundsRankTableController];
//    NSLog(@"kScreenW==%f", kScreenW);
    
    [self.fundsRankTableController.view setFrame:CGRectMake(0, 0, kScreenW, kScreenH - 100.0)];
    [self.scrollView addSubview:self.fundsRankTableController.view];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"self.fundsRankTableController.view.frame.size.width==%f", self.fundsRankTableController.view.frame.size.width);
}

- (IBAction)categoryChanged:(UISegmentedControl *)sender {
    
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
