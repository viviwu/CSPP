//
//  CSAskViewController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSAskViewController.h"

@interface CSAskViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation CSAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.inputAccessoryView = self.toolBar;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18.0], NSParagraphStyleAttributeName:paragraphStyle };
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    
    // Do any additional setup after loading the view.
}
- (IBAction)cancelToDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)sendQuestion:(id)sender {
//    [UIViewController toastAlert:@"sendQuestion"];
}

- (IBAction)dismissKeyboard:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

- (IBAction)atSomeomeToAsk:(id)sender {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18.0], NSParagraphStyleAttributeName:paragraphStyle };
    
    NSString * str = [NSString stringWithFormat:@"%@ @vivi", self.textView.text];
    NSRange range = [str rangeOfString:@"@vivi"];
    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    // 添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor purpleColor]
                    range:range];
    
    self.textView.attributedText = attrStr;
    
}

- (IBAction)addImageToAsk:(UIBarButtonItem *)sender {
    [UIViewController toastAlert:@"addImageToAsk"  time:1.0];
}

- (IBAction)addVideoToAsk:(id)sender {
    [UIViewController toastAlert:@"addVideoToAsk"  time:1.0];
}

- (IBAction)setPermission:(id)sender {
    [UIViewController toastAlert:@"setPermission"  time:1.0];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    UITextRange *selectedRange = [textView markedTextRange];
    NSString * newText = [textView textInRange:selectedRange]; //获取高亮部分
    if(newText.length>0)
        return;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSParagraphStyleAttributeName: paragraphStyle};
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
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
