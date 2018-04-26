//
//  PPFundPageViewController.m
//  CSPP
//
//  Created by vivi wu on 2018/4/15.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "PPFundPageViewController.h"

@interface PPFundPageViewController ()
{
    UIColor * navi_color;
}
@property (weak, nonatomic) IBOutlet UIView *header;

@end

@implementation PPFundPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XXX基金";
    self.tableView.tableHeaderView = self.header;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"已经关注" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    navi_color = self.navigationItem.rightBarButtonItem.tintColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_blue"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:25]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navi_color}];
    [self.navigationItem.rightBarButtonItem setTintColor:navi_color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section==5) {
        return 10;
    }else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @" ";
    if (indexPath.section==0) {
        reuseIdentifier = @"manager";
    }else if(indexPath.section==1){
        reuseIdentifier = @"grade";
    }else if(indexPath.section==2){
        reuseIdentifier = @"configuration";
    }else if(indexPath.section==3){
        reuseIdentifier = @"trend";
    }else if(indexPath.section==4){
        reuseIdentifier = @"seg";
    }else{
        reuseIdentifier = @"comment";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        return 30.0;
    }else if (indexPath.section==5) {
        return 44.0;
    }else if (indexPath.section==2) {
        return 300.0;
    } else{
        return 230.0;
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
