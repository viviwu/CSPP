//
//  PaidConsultViewController.m
//  Touhu
//
//  Created by csco on 2018/4/11.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PaidConsultViewController.h"

#import "ConsultMasterTableController.h"
#import "QuestionTableController.h"
#import "TopicAlbumTableController.h"
#import "UserConsultInfoTableController.h"

@interface PaidConsultViewController ()
{
    UIColor * _barColor;
}
@property (nonatomic, strong) ConsultMasterTableController * masterTVC;
@property (nonatomic, strong) QuestionTableController * answerTVC;
@property (nonatomic, strong) TopicAlbumTableController * topicTVC;
@property (nonatomic, strong) UserConsultInfoTableController * mineTVC;

@end

@implementation PaidConsultViewController

- (id)masterTVC{
    if (nil==_masterTVC) {
        _masterTVC=[self consultStoryboardControllerWithID:@"ConsultMasterTableController"];
    }
    return _masterTVC;
}

- (id)answerTVC{
    if (nil== _answerTVC) {
        _answerTVC = [self consultStoryboardControllerWithID:@"QuestionTableController"];
    }
    return _answerTVC;
}

- (id)topicTVC{
    if (nil == _topicTVC) {
        _topicTVC = [self consultStoryboardControllerWithID:@"TopicAlbumTableController"];
    }
    return _topicTVC;
}

- (id)mineTVC{
    if (nil== _mineTVC) {
        _mineTVC = [self consultStoryboardControllerWithID:@"UserConsultInfoTableController"];
    }
    return _mineTVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self addChildViewController:self.masterTVC];
    [self addChildViewController:self.answerTVC];
    [self addChildViewController:self.topicTVC];
    [self addChildViewController:self.mineTVC];
    
    [self.view addSubview:self.masterTVC.view];
    
    _barColor = ((UIBarButtonItem*)self.toolbarItems.firstObject).tintColor;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"navigationController.viewControllers.count==%lu", self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count == 2)
    {//关闭次级主界面的右滑返回
        return NO;
    }else
        return YES;
}

- (IBAction)counsltList:(UIBarButtonItem*)sender {
    [self setSeletedBarItem:sender];
//    for (id vc in self.childViewControllers) {
//        UIView * view = [vc valueForKey:@"view"];
//        [view removeFromSuperview];
//    }
    [self.view addSubview:self.masterTVC.view];
    [self.view bringSubviewToFront:self.masterTVC.view];
}

- (IBAction)answerAlbum:(id)sender {
    [self setSeletedBarItem:sender];
    [self.view addSubview:self.answerTVC.view];
    [self.view bringSubviewToFront:self.answerTVC.view];
}

- (IBAction)questionAlbum:(id)sender {
    [self setSeletedBarItem:sender];
    [self.view addSubview:self.topicTVC.view];
    [self.view bringSubviewToFront:self.topicTVC.view];
}

- (IBAction)mineAlbum:(id)sender {
    [self setSeletedBarItem:sender];
    [self.view addSubview:self.mineTVC.view];
    [self.view bringSubviewToFront:self.mineTVC.view];
}

- (void)setSeletedBarItem:(UIBarButtonItem*)sender
{
    [sender setTintColor:_barColor];
    for (UIBarButtonItem * item in self.toolbarItems) {
        if (item != sender) {
            [item setTintColor:[UIColor darkGrayColor]];
        }
    }
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
