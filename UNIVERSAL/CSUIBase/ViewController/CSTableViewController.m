//
//  CSTableViewController.m
//  CSFinance
//
//  Created by vivi wu on 2018/2/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSTableViewController.h"

@interface CSTableViewController ()

@end

@implementation CSTableViewController
- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionFooterHeight = 0;
        self.tableView.sectionHeaderHeight = 15.0;
 
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)computeSafeArea{
    UIEdgeInsets safeArea = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        safeArea = self.view.safeAreaInsets;
    } else {
        // Fallback on earlier versions
    }
#endif
    _safeTop = safeArea.top;
    _safeFrame = CGRectMake(safeArea.left, safeArea.top, self.view.frame.size.width-safeArea.left-safeArea.right, self.view.frame.size.height-safeArea.bottom);
}

-(id)readJsonFile:(NSString*)fileName{
    
    NSString * founds_path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    if (founds_path) {
        NSError * error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfFile:founds_path];
        //        json = [jsonStr  stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
        id jsonid = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            NSLog(@"error==%@", error);
        }
//        [NSDictionary changeType:jsonid];
        return jsonid;
    }else{
        NSLog(@"%@-->founds_path = %@", fileName, founds_path);
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
