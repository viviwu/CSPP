//
//  SalonCenterViewController.m
//  CSPP
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "SalonCenterViewController.h"
#import "SalonChoicenessTableController.h"

@interface SalonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIView *segView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtr;
@property (weak, nonatomic) SalonChoicenessTableController * salon;
@end

@implementation SalonCenterViewController

- (SalonChoicenessTableController *)salon{
    if (nil==_salon) {
        _salon = [self salonStoryboardControllerWithID:@"SalonChoicenessTableController"];
        [self addChildViewController:_salon];
    }
    return _salon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.salon];
    //self.segView.bottom
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect rect = self.salon.view.frame;
    rect.origin.y = self.segView.frame.origin.y + self.segView.frame.size.height+28.0;
    self.salon.view.frame = rect;
    [self.view addSubview: self.salon.view];
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
