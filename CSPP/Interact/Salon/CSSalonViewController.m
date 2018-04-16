//
//  CSSalonViewController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSSalonViewController.h"

@interface CSSalonViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property(nonatomic, strong)NSArray * sectionData;
@end

@implementation CSSalonViewController


#define kHeader @"kHeader"
#define kTitle @"kTitle"
#define kHolder @"kHolder"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = _footerView;
    NSArray * senior = @[@"一个账号报名次数", @"超过人数上限后允许排队", @"只有发起人和管理员可以分享活动", @"报名用户可以查看报名名单",  @"未报名用户也可以查看报名名单", @"使用签到功能"];
    _sectionData =
    @[ @{kHeader: @"活动标题", kTitle: @" ", kHolder: @"沙龙主题简短说明"}, @{kHeader: @"沙龙地址", kTitle: @" ", kHolder: @"请输入地址"},  @{kHeader: @"活动开始时间", kTitle: @"2018-3-25", kHolder: @" "},  @{kHeader: @"活动结束时间", kTitle: @"2018-3-30", kHolder: @" "},
       @{kHeader: @"活动内容说明", kTitle: @"  ", kHolder: @"请输入活动介绍等"}, @{kHeader: @"顶部横幅照片(选填)", kTitle: @" ", kHolder: @" "}, @{kHeader: @"相关照片(选填)", kTitle: @" ", kHolder: @" "}, @{kHeader: @"报名人数上限",  kTitle:@"报名人数上限"}, @{kHeader: @"高级设置",  kTitle:senior}];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * dic = _sectionData[section];
    id rows = dic[kHeader];
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4 || indexPath.section==5 || indexPath.section==6) {
        return 80.0;
    }else
        return 44.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSDictionary * dic = _sectionData[indexPath.section];
    id rows = dic[kTitle];
    
    UITableViewCell * cell = nil;
    switch (indexPath.section) {
        case 0:
        case 1:
        case 4:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"salon_text" forIndexPath:indexPath];
        }
            break;
            
        case 2:
        case 3: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"salon_label" forIndexPath:indexPath];
//                if ([rows isKindOfClass:[NSArray class]]) {
//                    NSString * row = rows[indexPath.row];
//                    cell.textLabel.text = row;
//                }
            }
            break;
            
        case 5:
        case 6:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"salon_image" forIndexPath:indexPath];
//            if ([rows isKindOfClass:[NSArray class]]) {
//                NSString * row = rows[indexPath.row];
//                cell.textLabel.text = row;
//            }
        }
            break;
            
        case 7:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"salon_input" forIndexPath:indexPath];
            if ([rows isKindOfClass:[NSArray class]]) {
                NSString * row = rows[indexPath.row];
                cell.textLabel.text = row;
            }
        }
            break;
        case 8:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"salon_switch" forIndexPath:indexPath];
            if ([rows isKindOfClass:[NSArray class]]) {
                NSString * row = rows[indexPath.row];
                cell.textLabel.text = row;
            }
        }
            break;
            
        default:{
            cell = [[UITableViewCell alloc]init];
        }
            break;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary * dic = _sectionData[section];
    id rows = dic[kTitle];
    if ([rows isKindOfClass:[NSArray class]]) {
        return ((NSArray *)rows).count;
    }else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionData.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
