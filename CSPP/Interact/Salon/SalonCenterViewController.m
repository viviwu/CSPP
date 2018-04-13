//
//  SalonCenterViewController.m
//  CSPP
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "SalonCenterViewController.h"
#import "CSSalonTableController.h"

@interface SalonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIView *segView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtr;

@end

@implementation SalonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CSSalonTableController * salon = [self salonStoryboardControllerWithID:@"CSSalonTableController"];
    [self addChildViewController:salon];
    [self.view addSubview:salon.view];
    CGRect rect = salon.view.frame;
    rect.origin.y = self.segView.frame.origin.y + self.segView.frame.size.height;
    salon.view.frame = rect;
    //self.segView.bottom
    // Do any additional setup after loading the view.
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
