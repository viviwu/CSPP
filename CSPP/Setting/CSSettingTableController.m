//
//  CSSettingTableController.m
//  CSInvest
//
//  Created by vivi wu on 2018/3/8.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSSettingTableController.h"
#import "VENTouchLock.h"

@interface CSSettingTableController ()

@property(nonatomic, copy)NSArray * tableList;

@property (strong, nonatomic) UISwitch *touchIDSwitch;

@end

@implementation CSSettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableList = @[@[@"设置应用密码", @"显示应用密码", @"清除应用密码"], @[@"使用TouchID访问应用"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Setting"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureTouchIDToggle];
}

- (void)configureTouchIDToggle
{
    self.touchIDSwitch.enabled = [[VENTouchLock sharedInstance] isPasscodeSet] && [VENTouchLock canUseTouchID];
    self.touchIDSwitch.on = [VENTouchLock shouldUseTouchID];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * rows = _tableList[section];
    return rows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting" forIndexPath:indexPath];
    
    NSArray * rows = _tableList[indexPath.section];
    cell.textLabel.text = rows[indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    
    if (1 == indexPath.section && 0 == indexPath.row) {
        self.touchIDSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kSelfVB_W-100.0, 5.0, 50.0, 30.0)];
        [self.touchIDSwitch addTarget:self action:@selector(userTappedSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:self.touchIDSwitch];
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            [self userTappedSetPasscode];
        }else if(1 == indexPath.row){
            [self userTappedShowPasscode];
        }else if(2 == indexPath.row){
            [self userTappedDeletePasscode];
        }
    }
}


- (void)userTappedSetPasscode
{
    if ([[VENTouchLock sharedInstance] isPasscodeSet]) {
        [[[UIAlertView alloc] initWithTitle:@"Passcode already exists" message:@"To set a new one, first delete the existing one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else {
        VENTouchLockCreatePasscodeViewController *createPasscodeVC = [[VENTouchLockCreatePasscodeViewController alloc] init];
        [self presentViewController:[createPasscodeVC embeddedInNavigationController] animated:YES completion:nil];
    }
}

- (void)userTappedShowPasscode
{
    if ([[VENTouchLock sharedInstance] isPasscodeSet]) {
        VENTouchLockEnterPasscodeViewController *showPasscodeVC = [[VENTouchLockEnterPasscodeViewController alloc] init];
        [self presentViewController:[showPasscodeVC embeddedInNavigationController] animated:YES completion:nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"No passcode" message:@"Please set a passcode first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)userTappedDeletePasscode
{
    if ([[VENTouchLock sharedInstance] isPasscodeSet]) {
        [[VENTouchLock sharedInstance] deletePasscode];
        [self configureTouchIDToggle];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"No passcode" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)userTappedSwitch:(UISwitch *)toggle
{
    //    NSLog(@"%s--->%@", __func__, _touchIDSwitch);
    [VENTouchLock setShouldUseTouchID:toggle.on];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
