//
//  CSNavigationController.m
//  CSFinance
//
//  Created by vivi wu on 2018/2/22.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSNavigationController.h"

@interface CSNavigationController ()

@end

@implementation CSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
    //    UIImage * navBarBG=[UIImage imageNamed:@"nav_green"];// navigationbar
    //    [self.navigationBar setBackgroundImage:navBarBG forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary * attributes =[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:20.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,  nil];
    [self.navigationBar setTitleTextAttributes:attributes];
    // Do any additional setup after loading the view.
}

// 重写自定义的UINavigationController中的push方法
// 处理tabbar的显示隐藏
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }else{
        NSLog(@"Navi-children:%lu", (unsigned long)self.childViewControllers.count);
    }
        
    [super pushViewController:viewController animated:animated];
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
