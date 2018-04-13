//
//  CSBizNewsTableController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSBizNewsTableController.h"

@interface CSBizNewsTableController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayCtr;

@end

@implementation CSBizNewsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView  =_searchBar;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.searchDisplayCtr.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchResultsTableView"];
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
    if (tableView == self.tableView) {
        return 1;
    }else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (tableView == self.tableView) {
        return 20;
    }else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BizNews" forIndexPath:indexPath];
        
        cell.textLabel.text = @"【盘前必读】离岸人民币暴力大涨，升破6.24关口";
        cell.detailTextLabel.text = @"要闻汇总 1、离岸人民币暴力大涨，升破6.24关口 离岸人民币暴力大涨，升破6.24关口，再创811汇改之后的新高。 2、乐视内部人士：乐视可以破产重整或卖资产抵债 一位乐视内部人士表示：“目前无论是破产重整，还是卖资产抵债，这些方案公司都是接受的。”";
        // Configure the cell...
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"searchResultsTableView" forIndexPath:indexPath];
        return cell;
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
