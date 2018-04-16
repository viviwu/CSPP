//
//  ViewController.m
//  XWReaderPlayer
//
//  Created by csco on 2018/3/29.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "CSTxtReadPlayerController.h"
#import <CoreText/CoreText.h>
#import "CSMutiMediaPlayer.h"

@interface CSTxtReadPlayerController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger index;
    NSString * originalString;
    NSString * targetString;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, assign) TTSStatus playStatus;

@end

@implementation CSTxtReadPlayerController

- (TTSStatus)playStatus
{
    _playStatus = [CSMutiMediaPlayer instancePlayer].ttsStatus;
    return _playStatus;
}

- (NSArray * )parserTextWithFileName:(NSString *)fileName
{
    // 根据文件名称获取文件地址
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    // 根据文件地址获取转化后的总体的字符串
    originalString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20.0, self.view.bounds.size.height-20.0)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text  = originalString;
    targetString = originalString;
    
    return [self getLinesArrayOfStringInLabel:label];
}

- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"外媒：亚马逊股价大跌是买入良机";
    self.playStatus = TTSNotStart;
    index = 0;
    targetString = @"hello";
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    [[CSMutiMediaPlayer instancePlayer] initTTSSynthesizer];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataSource = [self parserTextWithFileName:@"news.txt"];
    [self.tableView reloadData];
    
    [[CSMutiMediaPlayer instancePlayer] cancelSynTTS];
    self.playStatus = TTSNotStart;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [[CSMutiMediaPlayer instancePlayer] stopTTS];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"label_cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CSMutiMediaPlayer instancePlayer] cancelSynTTS];
    index = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    NSString * text = _dataSource[indexPath.row];
    
    NSRange range = [originalString rangeOfString:text];
    targetString = [originalString substringFromIndex:range.location];
    
    [[CSMutiMediaPlayer instancePlayer] startSynTTS:targetString];
    [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}

- (IBAction)playOrPause:(UIButton *)sender {
    
    if (TTSPlaying == self.playStatus) {
        [[CSMutiMediaPlayer instancePlayer] pauseSynTTS];
        
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
    }else{
        if(TTSPaused==self.playStatus){
            [[CSMutiMediaPlayer instancePlayer] resumeSynTTS];
        }else if(TTSPlaying==self.playStatus){
            //TTSPlaying do nothing
        }else{
            [[CSMutiMediaPlayer instancePlayer] startSynTTS:targetString];
        }
        
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateHighlighted];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        NSString * text = _dataSource[indexPath.row];
//        NSRange range = [targetString rangeOfString:text];
//        targetString = [targetString substringFromIndex:range.location];
    }
    
}

- (void)startTimer{
    if (!timer) {
        timer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(runAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)runAction:(NSTimer *)sender {
    
    if (_dataSource.count-1 < index){
        index = 0;
        targetString = originalString;
       [[CSMutiMediaPlayer instancePlayer] startSynTTS:targetString];
    }
    if (TTSPlaying == self.playStatus) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        //    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        NSLog(@"NSTimer index: %ld",(long)index);
        index++;
    }else{
        //
    }
}


/**
 
 NSString *string = @"Lorem    ipsum dolar  sit  amet.";
 
 string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
 
 NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
 
 components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
 
 string = [components componentsJoinedByString:@" "];
 
 
 */

@end
