//
//  CSViewController.m
//  CSFinance
//
//  Created by vivi wu on 2018/2/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSViewController.h"
#import "AppDelegate.h"

@interface CSViewController ()
//@property (nonatomic, assign) CGRect safeFrame;
//@property (nonatomic, assign) CGFloat safeTop;
//@property (nonatomic, assign) CGFloat safeBottom;
@end

@implementation CSViewController
/*
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self computeSafeArea];
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self computeSafeArea];
    }
    return self;
}
 
 
 - (void)computeSafeArea{
 
 UIEdgeInsets safeArea = UIEdgeInsetsZero;
 #ifdef __IPHONE_11_0
 if (@available(iOS 11.0, *)) {
 safeArea = self.view.safeAreaInsets;
 _safeFrame = self.view.safeAreaLayoutGuide.layoutFrame;
 _safeTop = safeArea.top;
 _safeBottom = safeArea.bottom;
 _safeTop=64.0;
 if (kDevice_Is_iPhoneX) {
 _safeTop =88.0;
 }
 } else {
 // Fallback on earlier versions
 }
 #endif
 }
 
*/

- (CGFloat)safeTop{
    CGFloat top = 20.0 + 44.0;
#ifdef __IPHONE_11_0
    if (kDevice_Is_iPhoneX) {
        top =88.0;
    }
#endif
    return top;
}

- (CGFloat)safeBottom{
    CGFloat bottom = 49.0;
#ifdef __IPHONE_11_0
    if (kDevice_Is_iPhoneX) {
        bottom =83.0;
    }
#endif
    return bottom;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
    
    //    self.view.backgroundColor = [UIColor lightGrayColor]; 
    // Do any additional setup after loading the view.
}

/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self printViewHierarchy:self.tabBarController.view];
}
 
- (void)printViewHierarchy:(UIView *)superView
{
    static uint level = 0;
    for(uint i = 0; i < level; i++){
        printf("\t");
    }
    
    const char *className = NSStringFromClass([superView class]).UTF8String;
    const char *frame = NSStringFromCGRect(superView.frame).UTF8String;
    printf("%s:%s\n", className, frame);
    
    ++level;
    for(UIView *view in superView.subviews){
        [self printViewHierarchy:view];
    }
    --level;
}

//TODO get height

- (void)viewDidLayoutSubviews
{
    //    [self computeSafeArea];
    //    NSLog(@"_safeFrame==%@", NSStringFromCGRect(_safeFrame));
    [super viewDidLayoutSubviews];
}

 //44
 NSLog(@"navigationBar=%@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
 //49
 NSLog(@"toolbar->%@", NSStringFromCGRect(self.navigationController.toolbar.frame));
 //{{0, 88}, {375, 641}}
 NSLog(@"layoutFrame=%@", NSStringFromCGRect(self.view.safeAreaLayoutGuide.layoutFrame));
 //88=44+44
 NSLog(@"safeAreaInsets:top=%f", self.view.safeAreaInsets.top);
 //83=49+34
 NSLog(@"safeAreaInsets:bottom=%f", self.view.safeAreaInsets.bottom);
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor*)randomColor{
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return KSYRGB(R, G, B);
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
        [NSDictionary changeType:jsonid];
        return jsonid;
    }else{
        NSLog(@"%@-->founds_path = %@", fileName, founds_path);
    }
    return nil;
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
