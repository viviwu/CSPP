//
//  CSSeniorUserViewController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/26.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSSeniorUserViewController.h"
#import "CSImgCollectCell.h"

@interface CSSeniorUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sectionHeader;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtr;

@end

@implementation CSSeniorUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
    
    // Do any additional setup after loading the view.
}
- (IBAction)cateChaned:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==3) {
        [self performSegueWithIdentifier:@"showStore" sender:sender];
    }else{
        [self.tableView reloadData];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_segCtr.selectedSegmentIndex ==0) {
        CSImgCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"opinion" forIndexPath:indexPath];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"basic" forIndexPath:indexPath];
        
        return cell;
    }
} 

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionHeader;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
