//
//  PPRankViewController.m
//  CSPP
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "PPRankViewController.h"

@interface PPRankViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PPRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(kScreenW * 3, kScreenH);
    
    // Do any additional setup after loading the view.
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
