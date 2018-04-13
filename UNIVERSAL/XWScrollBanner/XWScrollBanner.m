//
//  XWScrollBanner.m
//  XWScrollBanner
//
//  Created by vivi wu on 2014/11/4.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWScrollBanner.h"
#import "XWBanner.h"

@interface XWScrollBanner ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger _index;
    NSTimer * _timer;
}
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIPageControl * pageConrol;

@end

@implementation XWScrollBanner

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray*)dataSource{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        _dataSource = dataSource;
        [self.collectionView reloadData];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (UIPageControl*)pageConrol{
    if (nil == _pageConrol) {
        _pageConrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-25.0, self.bounds.size.width, 25.0)];
        _pageConrol.pageIndicatorTintColor = [UIColor whiteColor];
        _pageConrol.currentPageIndicatorTintColor = [UIColor yellowColor];
    }
    return _pageConrol;
}

- (UICollectionView *)collectionView{
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    CGFloat itemWidth = self.frame.size.width;
    CGFloat itemHeight = self.frame.size.height;
    if (nil == _layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return _layout;
}
- (void)setUp{
    _index = 0;
    _scrollInterval = 2.0;
    self.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[XWBanner class] forCellWithReuseIdentifier:@"banner"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addSubview:self.pageConrol];
    self.pageConrol.numberOfPages = self.dataSource.count;
    self.pageConrol.currentPage = 0;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView setFrame:self.bounds];
    [self.collectionView setCollectionViewLayout:self.layout];
    [self.collectionView reloadData];
    
    self.pageConrol.numberOfPages = self.dataSource.count;
    self.pageConrol.currentPage = 0;
    
    if (self.dataSource.count) {
        [self startTimer];
    }
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:_scrollInterval target:self selector:@selector(scrollPage:) userInfo:nil repeats:YES];
    }
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)scrollPage:(NSTimer*)timer{
    if (scrollRepeat *_dataSource.count-1 < _index){
        _index = 0;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    NSLog(@"_index==%ld", (long)_index);
    _index++;
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger currentPage = indexPath.row % (self.dataSource.count);
    self.pageConrol.currentPage =currentPage;
    
    XWBannerModel *model = self.dataSource[currentPage];
    XWBanner * banner = [collectionView dequeueReusableCellWithReuseIdentifier:@"banner" forIndexPath:indexPath];
    [banner setModel:model];
    return banner;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count * scrollRepeat;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentPage = indexPath.row % (self.dataSource.count);
    
    XWBannerModel *model = self.dataSource[currentPage];
    self.bannerClickHandle(currentPage, model);
}

@end
