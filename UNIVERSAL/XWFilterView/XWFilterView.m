//
//  XWFilterView.m
//  XWScrollBanner
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWFilterView.h"
#import "XWFilterCell.h"

@interface XWFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * resetBtn;
@property (nonatomic, strong) UIButton * confirmBtn;
@end

@implementation XWFilterView

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


- (UICollectionView *)collectionView{
    if (nil == _collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40.0) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.allowsMultipleSelection = YES; //多选
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    CGFloat itemWidth = self.frame.size.width/4;
    CGFloat itemHeight = 25.0;
    if (nil == _layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    _layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 10;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.headerReferenceSize =CGSizeMake(itemWidth*2, itemHeight+5.0);
    return _layout;
}

- (void)setUp{
    self.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[XWFilterCell class] forCellWithReuseIdentifier:@"filter"];
    [self.collectionView registerClass:[XWFilterSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UIView * controBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40.0, self.bounds.size.width, 40.0)];
    controBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:controBar];
    [self bringSubviewToFront:controBar];
    
    [self.resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchDown];
    [controBar addSubview:self.resetBtn];
    
    [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchDown];
    [controBar addSubview:self.confirmBtn];
}

- (UIButton*)resetBtn{
    if (nil==_resetBtn) {
        _resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, 40.0)];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _resetBtn;
}

- (UIButton*)confirmBtn{
    if (nil==_confirmBtn) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, 40.0)];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor redColor]];
    }
    return _confirmBtn;
}

- (void)reset{
    
}
- (void)confirm{
    [self removeFromSuperview];
    NSMutableArray * results = [NSMutableArray array];
    for (id obj in self.dataSource) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray * arr = obj;
            NSAssert([arr[0] isKindOfClass:[XWFilter class]], @"obj isNotKindOfClass XWFilter!!!");
            for (XWFilter * model in arr) {
                if (model.selected) {
                    [results addObject:model];
                }
            }
        }else if([obj isKindOfClass:[XWFilter class]]){
            XWFilter * model = obj;
            if (model.selected) {
                [results addObject:model];
            }
        }else{
            //
        }
    }
    if (self.multiResulter) {
        self.multiResulter(results);
    } 
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40.0)];
    [self.collectionView setCollectionViewLayout:self.layout];
    [self.collectionView reloadData];
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
    NSArray * rowdata = self.dataSource[indexPath.section];
    XWFilter *model = rowdata[indexPath.row];
    BOOL slected = NO;
    for (XWFilter * model in rowdata) {
        if (model.selected) {
            slected = model.selected;
        }
    }
    if (indexPath.row==0 && slected==NO) {
        model.selected = YES;
    }
    XWFilterCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filter" forIndexPath:indexPath];
    [cell refreshModel:model];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray * rowdata = self.dataSource[section];
    return rowdata.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * rowdata = self.dataSource[indexPath.section];
    for (XWFilter * model in rowdata) {
        model.selected = NO;
    }
    XWFilter *model = rowdata[indexPath.row];
    model.selected = !model.selected;
    
    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    if (nil != self.selectHandle) {
        self.selectHandle(indexPath, model.title);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSArray * rowdata = self.dataSource[indexPath.section];
    XWFilter *model = rowdata[indexPath.row];
    
    XWFilterSectionHeader * header =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    [header refreshModel:model];
    
    return header;
}


@end
