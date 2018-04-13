//
//  XWSegmentedControl.m
//  XWSegmentedControl
//
//  Created by vivi wu on 23/12/12.
//  Copyright (c) 2014-2015 vivi wu. All rights reserved.
//

#import "XWSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface XWScrollView : UIScrollView
@end

@interface XWSegmentedControl ()

@property (nonatomic, strong) CALayer *indicatorStripLayer;
@property (nonatomic, strong) CALayer *indicatorBoxLayer;
@property (nonatomic, strong) CALayer *indicatorArrowLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, readwrite) NSArray<NSNumber *> *segmentWidthsArray;
@property (nonatomic, strong) XWScrollView *scrollView;

@end

@implementation XWScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@implementation XWSegmentedControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray<NSString *> *)sectiontitles {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.sectionTitles = sectiontitles;
        self.type = XWSegTypeText;
    }
    
    return self;
}

- (id)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
        self.type = XWSegTypeImages;
    }
    
    return self;
}

- (instancetype)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages titlesForSections:(NSArray<NSString *> *)sectiontitles {
	self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
		
		if (sectionImages.count != sectiontitles.count) {
			[NSException raise:NSRangeException format:@"***%s: Images bounds (%ld) Don't match Title bounds (%ld)", sel_getName(_cmd), (unsigned long)sectionImages.count, (unsigned long)sectiontitles.count];
        }
		
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
		self.sectionTitles = sectiontitles;
        self.type = XWSegTypeTextImages;
    }
    
    return self;
}

- (void)awakeFromNib {
//    [self commonInit];
    self.segmentWidth = 0.0f; 
    [super awakeFromNib];
}

- (void)commonInit {
    self.scrollView = [[XWScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    _backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    _indicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    _indicatorBoxColor = _indicatorColor;

    self.selectedIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.indicatorHeight = 5.0f;
    self.indicatorEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.selectionStyle = XWSegSelectionStyleTextWidthStripe;
    self.indicatorLocation = XWSegIndicatorLocationDown;
    self.segmentWidthStyle = XWSegStyleFixed;
    self.userDraggable = YES;
    self.touchEnabled = YES;
    self.verticalDividerEnabled = NO;
    self.type = XWSegTypeText;
    self.verticalDividerWidth = 1.0f;
    _verticalDividerColor = [UIColor blackColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 1.0f;
    
    self.shouldAnimateUserSelection = YES;
    
    self.indicatorArrowLayer = [CALayer layer];
    self.indicatorStripLayer = [CALayer layer];
    self.indicatorBoxLayer = [CALayer layer];
    self.indicatorBoxLayer.opacity = self.indicatorBoxOpacity;
    self.indicatorBoxLayer.borderWidth = 1.0f;
    self.indicatorBoxOpacity = 0.2;
    
    self.contentMode = UIViewContentModeRedraw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentsRects];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateSegmentsRects];
}

- (void)setSectionTitles:(NSArray<NSString *> *)sectionTitles {
    _sectionTitles = sectionTitles;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSectionImages:(NSArray<UIImage *> *)sectionImages {
    _sectionImages = sectionImages;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setIndicatorLocation:(XWSegIndicatorLocation)indicatorLocation {
	_indicatorLocation = indicatorLocation;
	
	if (indicatorLocation == XWSegIndicatorLocationNone) {
		self.indicatorHeight = 0.0f;
	}
}

- (void)setIndicatorBoxOpacity:(CGFloat)indicatorBoxOpacity {
    _indicatorBoxOpacity = indicatorBoxOpacity;
    
    self.indicatorBoxLayer.opacity = _indicatorBoxOpacity;
}

- (void)setSegmentWidthStyle:(XWSegStyle)segmentWidthStyle {
    // Force XWSegStyleFixed when type is XWSegTypeImages.
    if (self.type == XWSegTypeImages) {
        _segmentWidthStyle = XWSegStyleFixed;
    } else {
        _segmentWidthStyle = segmentWidthStyle;
    }
}

- (void)setBorderType:(XWSegBorderType)borderType {
    _borderType = borderType;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (CGSize)measureTitleAtIndex:(NSUInteger)index {
    if (index >= self.sectionTitles.count) {
        return CGSizeZero;
    }
    
    id title = self.sectionTitles[index];
    CGSize size = CGSizeZero;
    BOOL selected = (index == self.selectedIndex) ? YES : NO;
    if ([title isKindOfClass:[NSString class]] && !self.titleFormatter) {
        NSDictionary *titleAttrs = selected ? [self resultingSelectedTitleTextAttributes] : [self resultingTitleTextAttributes];
        size = [(NSString *)title sizeWithAttributes:titleAttrs];
    } else if ([title isKindOfClass:[NSString class]] && self.titleFormatter) {
        size = [self.titleFormatter(self, title, index, selected) size];
    } else if ([title isKindOfClass:[NSAttributedString class]]) {
        size = [(NSAttributedString *)title size];
    } else {
        NSAssert(title == nil, @"Unexpected type of segment title: %@", [title class]);
        size = CGSizeZero;
    }
    return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

- (NSAttributedString *)attributedTitleAtIndex:(NSUInteger)index {
    id title = self.sectionTitles[index];
    BOOL selected = (index == self.selectedIndex) ? YES : NO;
    
    if ([title isKindOfClass:[NSAttributedString class]]) {
        return (NSAttributedString *)title;
    } else if (!self.titleFormatter) {
        NSDictionary *titleAttrs = selected ? [self resultingSelectedTitleTextAttributes] : [self resultingTitleTextAttributes];
        
        // the color should be cast to CGColor in order to avoid invalid context on iOS7
        UIColor *titleColor = titleAttrs[NSForegroundColorAttributeName];
        
        if (titleColor) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:titleAttrs];
            
            dict[NSForegroundColorAttributeName] = (id)titleColor.CGColor;
            
            titleAttrs = [NSDictionary dictionaryWithDictionary:dict];
        }
        
        return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:titleAttrs];
    } else {
        return self.titleFormatter(self, title, index, selected);
    }
}

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    self.indicatorArrowLayer.backgroundColor = self.indicatorColor.CGColor;
    
    self.indicatorStripLayer.backgroundColor = self.indicatorColor.CGColor;
    
    self.indicatorBoxLayer.backgroundColor = self.indicatorBoxColor.CGColor;
    self.indicatorBoxLayer.borderColor = self.indicatorBoxColor.CGColor;
    
    // Remove all sublayers to avoid drawing images over existing ones
    self.scrollView.layer.sublayers = nil;
    
    CGRect oldRect = rect;
    
    if (self.type == XWSegTypeText) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {

            CGFloat stringWidth = 0;
            CGFloat stringHeight = 0;
            CGSize size = [self measureTitleAtIndex:idx];
            stringWidth = size.width;
            stringHeight = size.height;
            CGRect rectDiv = CGRectZero;
            CGRect fullRect = CGRectZero;
            
            // Text inside the CATextLayer will appear blurry unless the rect values are rounded
            BOOL locationUp = (self.indicatorLocation == XWSegIndicatorLocationUp);
            BOOL selectionStyleNotBox = (self.selectionStyle != XWSegSelectionStyleBox);

            CGFloat y = roundf((CGRectGetHeight(self.frame) - selectionStyleNotBox * self.indicatorHeight) / 2 - stringHeight / 2 + self.indicatorHeight * locationUp);
            CGRect rect;
            if (self.segmentWidthStyle == XWSegStyleFixed) {
                rect = CGRectMake((self.segmentWidth * idx) + (self.segmentWidth - stringWidth) / 2, y, stringWidth, stringHeight);
                rectDiv = CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.indicatorHeight * 2, self.verticalDividerWidth, self.frame.size.height - (self.indicatorHeight * 4));
                fullRect = CGRectMake(self.segmentWidth * idx, 0, self.segmentWidth, oldRect.size.height);
            } else {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                CGFloat xOffset = 0;
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i)
                        break;
                    xOffset = xOffset + [width floatValue];
                    i++;
                }
                
                CGFloat widthForIndex = [[self.segmentWidthsArray objectAtIndex:idx] floatValue];
                rect = CGRectMake(xOffset, y, widthForIndex, stringHeight);
                fullRect = CGRectMake(self.segmentWidth * idx, 0, widthForIndex, oldRect.size.height);
                rectDiv = CGRectMake(xOffset - (self.verticalDividerWidth / 2), self.indicatorHeight * 2, self.verticalDividerWidth, self.frame.size.height - (self.indicatorHeight * 4));
            }
            
            // Fix rect position/size to avoid blurry labels
            rect = CGRectMake(ceilf(rect.origin.x), ceilf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height));
            
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = rect;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
                titleLayer.truncationMode = kCATruncationEnd;
            }
            titleLayer.string = [self attributedTitleAtIndex:idx];
            titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            
            [self.scrollView.layer addSublayer:titleLayer];
            
            // Vertical Divider
            if (self.isVerticalDividerEnabled && idx > 0) {
                CALayer *verticalDividerLayer = [CALayer layer];
                verticalDividerLayer.frame = rectDiv;
                verticalDividerLayer.backgroundColor = self.verticalDividerColor.CGColor;
                
                [self.scrollView.layer addSublayer:verticalDividerLayer];
            }
        
            [self addBackgroundAndBorderLayerWithRect:fullRect];
        }];
    } else if (self.type == XWSegTypeImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
            CGFloat y = roundf(CGRectGetHeight(self.frame) - self.indicatorHeight) / 2 - imageHeight / 2 + ((self.indicatorLocation == XWSegIndicatorLocationUp) ? self.indicatorHeight : 0);
            CGFloat x = self.segmentWidth * idx + (self.segmentWidth - imageWidth)/2.0f;
            CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = rect;
            
            if (self.selectedIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
            // Vertical Divider
            if (self.isVerticalDividerEnabled && idx>0) {
                CALayer *verticalDividerLayer = [CALayer layer];
                verticalDividerLayer.frame = CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.indicatorHeight * 2, self.verticalDividerWidth, self.frame.size.height-(self.indicatorHeight * 4));
                verticalDividerLayer.backgroundColor = self.verticalDividerColor.CGColor;
                
                [self.scrollView.layer addSublayer:verticalDividerLayer];
            }
            
            [self addBackgroundAndBorderLayerWithRect:rect];
        }];
    } else if (self.type == XWSegTypeTextImages){
		[self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
			
            CGSize stringSize = [self measureTitleAtIndex:idx];
            CGFloat stringHeight = stringSize.height;
            CGFloat stringWidth = stringSize.width;
            
            CGFloat imageXOffset = self.segmentWidth * idx; // Start with edge inset
            CGFloat textXOffset  = self.segmentWidth * idx;
            CGFloat imageYOffset = ceilf((self.frame.size.height - imageHeight) / 2.0); // Start in center
            CGFloat textYOffset  = ceilf((self.frame.size.height - stringHeight) / 2.0);
            
            
            if (self.segmentWidthStyle == XWSegStyleFixed) {
                BOOL isImageInLineWidthText = self.imagePosition == XWSegImagePositionLeftOfText || self.imagePosition == XWSegImagePositionRightOfText;
                if (isImageInLineWidthText) {
                    CGFloat whitespace = self.segmentWidth - stringSize.width - imageWidth - self.textImageSpacing;
                    if (self.imagePosition == XWSegImagePositionLeftOfText) {
                        imageXOffset += whitespace / 2.0;
                        textXOffset = imageXOffset + imageWidth + self.textImageSpacing;
                    } else {
                        textXOffset += whitespace / 2.0;
                        imageXOffset = textXOffset + stringWidth + self.textImageSpacing;
                    }
                } else {
                    imageXOffset = self.segmentWidth * idx + (self.segmentWidth - imageWidth) / 2.0f; // Start with edge inset
                    textXOffset  = self.segmentWidth * idx + (self.segmentWidth - stringWidth) / 2.0f;
                    
                    CGFloat whitespace = CGRectGetHeight(self.frame) - imageHeight - stringHeight - self.textImageSpacing;
                    if (self.imagePosition == XWSegImagePositionAboveText) {
                        imageYOffset = ceilf(whitespace / 2.0);
                        textYOffset = imageYOffset + imageHeight + self.textImageSpacing;
                    } else if (self.imagePosition == XWSegImagePositionBelowText) {
                        textYOffset = ceilf(whitespace / 2.0);
                        imageYOffset = textYOffset + stringHeight + self.textImageSpacing;
                    }
                }
            } else if (self.segmentWidthStyle == XWSegStyleDynamic) {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                CGFloat xOffset = 0;
                NSInteger i = 0;
                
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i) {
                        break;
                    }
                    
                    xOffset = xOffset + [width floatValue];
                    i++;
                }
                
                BOOL isImageInLineWidthText = self.imagePosition == XWSegImagePositionLeftOfText || self.imagePosition == XWSegImagePositionRightOfText;
                if (isImageInLineWidthText) {
                    if (self.imagePosition == XWSegImagePositionLeftOfText) {
                        imageXOffset = xOffset;
                        textXOffset = imageXOffset + imageWidth + self.textImageSpacing;
                    } else {
                        textXOffset = xOffset;
                        imageXOffset = textXOffset + stringWidth + self.textImageSpacing;
                    }
                } else {
                    imageXOffset = xOffset + ([self.segmentWidthsArray[i] floatValue] - imageWidth) / 2.0f; // Start with edge inset
                    textXOffset  = xOffset + ([self.segmentWidthsArray[i] floatValue] - stringWidth) / 2.0f;
                    
                    CGFloat whitespace = CGRectGetHeight(self.frame) - imageHeight - stringHeight - self.textImageSpacing;
                    if (self.imagePosition == XWSegImagePositionAboveText) {
                        imageYOffset = ceilf(whitespace / 2.0);
                        textYOffset = imageYOffset + imageHeight + self.textImageSpacing;
                    } else if (self.imagePosition == XWSegImagePositionBelowText) {
                        textYOffset = ceilf(whitespace / 2.0);
                        imageYOffset = textYOffset + stringHeight + self.textImageSpacing;
                    }
                }
            }
            
            CGRect imageRect = CGRectMake(imageXOffset, imageYOffset, imageWidth, imageHeight);
            CGRect textRect = CGRectMake(ceilf(textXOffset), ceilf(textYOffset), ceilf(stringWidth), ceilf(stringHeight));

            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = textRect;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = [self attributedTitleAtIndex:idx];
            if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
                titleLayer.truncationMode = kCATruncationEnd;
            }
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = imageRect;
			
            if (self.selectedIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
			titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
			
            [self addBackgroundAndBorderLayerWithRect:imageRect];
        }];
	}
    
    // Add the selection indicators
    if (self.selectedIndex != XWSegmentedControlNoSegment) {
        if (self.selectionStyle == XWSegSelectionStyleArrow) {
            if (!self.indicatorArrowLayer.superlayer) {
                [self setArrowFrame];
                [self.scrollView.layer addSublayer:self.indicatorArrowLayer];
            }
        } else {
            if (!self.indicatorStripLayer.superlayer) {
                self.indicatorStripLayer.frame = [self frameForSelectionIndicator];
                [self.scrollView.layer addSublayer:self.indicatorStripLayer];
                
                if (self.selectionStyle == XWSegSelectionStyleBox && !self.indicatorBoxLayer.superlayer) {
                    self.indicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
                    [self.scrollView.layer insertSublayer:self.indicatorBoxLayer atIndex:0];
                }
            }
        }
    }
}

- (void)addBackgroundAndBorderLayerWithRect:(CGRect)fullRect {
    // Background layer
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = fullRect;
    [self.layer insertSublayer:backgroundLayer atIndex:0];
    
    // Border layer
    if (self.borderType & XWSegBorderTypeTop) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0, 0, fullRect.size.width, self.borderWidth);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer: borderLayer];
    }
    if (self.borderType & XWSegBorderTypeLeft) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0, 0, self.borderWidth, fullRect.size.height);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer: borderLayer];
    }
    if (self.borderType & XWSegBorderTypeBottom) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0, fullRect.size.height - self.borderWidth, fullRect.size.width, self.borderWidth);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer: borderLayer];
    }
    if (self.borderType & XWSegBorderTypeRight) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(fullRect.size.width - self.borderWidth, 0, self.borderWidth, fullRect.size.height);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer: borderLayer];
    }
}

- (void)setArrowFrame {
    self.indicatorArrowLayer.frame = [self frameForSelectionIndicator];
    
    self.indicatorArrowLayer.mask = nil;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    CGPoint p3 = CGPointZero;
    
    if (self.indicatorLocation == XWSegIndicatorLocationDown) {
        p1 = CGPointMake(self.indicatorArrowLayer.bounds.size.width / 2, 0);
        p2 = CGPointMake(0, self.indicatorArrowLayer.bounds.size.height);
        p3 = CGPointMake(self.indicatorArrowLayer.bounds.size.width, self.indicatorArrowLayer.bounds.size.height);
    }
    
    if (self.indicatorLocation == XWSegIndicatorLocationUp) {
        p1 = CGPointMake(self.indicatorArrowLayer.bounds.size.width / 2, self.indicatorArrowLayer.bounds.size.height);
        p2 = CGPointMake(self.indicatorArrowLayer.bounds.size.width, 0);
        p3 = CGPointMake(0, 0);
    }
    
    [arrowPath moveToPoint:p1];
    [arrowPath addLineToPoint:p2];
    [arrowPath addLineToPoint:p3];
    [arrowPath closePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.indicatorArrowLayer.bounds;
    maskLayer.path = arrowPath.CGPath;
    self.indicatorArrowLayer.mask = maskLayer;
}

- (CGRect)frameForSelectionIndicator {
    CGFloat indicatorYOffset = 0.0f;
    
    if (self.indicatorLocation == XWSegIndicatorLocationDown) {
        indicatorYOffset = self.bounds.size.height - self.indicatorHeight + self.indicatorEdgeInsets.bottom;
    }
    
    if (self.indicatorLocation == XWSegIndicatorLocationUp) {
        indicatorYOffset = self.indicatorEdgeInsets.top;
    }
    
    CGFloat sectionWidth = 0.0f;
    
    if (self.type == XWSegTypeText) {
        CGFloat stringWidth = [self measureTitleAtIndex:self.selectedIndex].width;
        sectionWidth = stringWidth;
    } else if (self.type == XWSegTypeImages) {
        UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedIndex];
        CGFloat imageWidth = sectionImage.size.width;
        sectionWidth = imageWidth;
    } else if (self.type == XWSegTypeTextImages) {
		CGFloat stringWidth = [self measureTitleAtIndex:self.selectedIndex].width;
		UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedIndex];
		CGFloat imageWidth = sectionImage.size.width;
        sectionWidth = MAX(stringWidth, imageWidth);
	}
    
    if (self.selectionStyle == XWSegSelectionStyleArrow) {
        CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
        CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedIndex);
        
        CGFloat x = widthToStartOfSelectedIndex + ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) - (self.indicatorHeight/2);
        return CGRectMake(x - (self.indicatorHeight / 2), indicatorYOffset, self.indicatorHeight * 2, self.indicatorHeight);
    } else {
        if (self.selectionStyle == XWSegSelectionStyleTextWidthStripe &&
            sectionWidth <= self.segmentWidth &&
            self.segmentWidthStyle != XWSegStyleDynamic) {
            CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
            CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedIndex);
            
            CGFloat x = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) + (widthToStartOfSelectedIndex - sectionWidth / 2);
            return CGRectMake(x + self.indicatorEdgeInsets.left, indicatorYOffset, sectionWidth - self.indicatorEdgeInsets.right, self.indicatorHeight);
        } else {
            if (self.segmentWidthStyle == XWSegStyleDynamic) {
                CGFloat selectedSegmentOffset = 0.0f;
                
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (self.selectedIndex == i)
                        break;
                    selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
                    i++;
                }
                return CGRectMake(selectedSegmentOffset + self.indicatorEdgeInsets.left, indicatorYOffset, [[self.segmentWidthsArray objectAtIndex:self.selectedIndex] floatValue] - self.indicatorEdgeInsets.right, self.indicatorHeight + self.indicatorEdgeInsets.bottom);
            }
            
            return CGRectMake((self.segmentWidth + self.indicatorEdgeInsets.left) * self.selectedIndex, indicatorYOffset, self.segmentWidth - self.indicatorEdgeInsets.right, self.indicatorHeight);
        }
    }
}

- (CGRect)frameForFillerSelectionIndicator {
    if (self.segmentWidthStyle == XWSegStyleDynamic) {
        CGFloat selectedSegmentOffset = 0.0f;
        
        NSInteger i = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedIndex == i) {
                break;
            }
            selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
            
            i++;
        }
        
        return CGRectMake(selectedSegmentOffset, 0, [[self.segmentWidthsArray objectAtIndex:self.selectedIndex] floatValue], CGRectGetHeight(self.frame));
    }
    return CGRectMake(self.segmentWidth * self.selectedIndex, 0, self.segmentWidth, CGRectGetHeight(self.frame));
}

- (void)updateSegmentsRects {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    if ([self sectionCount] > 0) {
        self.segmentWidth = self.frame.size.width / [self sectionCount];
    }
    
    if (self.type == XWSegTypeText && self.segmentWidthStyle == XWSegStyleFixed) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }];
    } else if (self.type == XWSegTypeText && self.segmentWidthStyle == XWSegStyleDynamic) {
        NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
        
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            [mutableSegmentWidths addObject:[NSNumber numberWithFloat:stringWidth]];
        }];
        self.segmentWidthsArray = [mutableSegmentWidths copy];
    } else if (self.type == XWSegTypeImages) {
        for (UIImage *sectionImage in self.sectionImages) {
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(imageWidth, self.segmentWidth);
        }
    } else if (self.type == XWSegTypeTextImages && self.segmentWidthStyle == XWSegStyleFixed){
        //lets just use the title.. we will assume it is wider then images...
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }];
    } else if (self.type == XWSegTypeTextImages && self.segmentWidthStyle == XWSegStyleDynamic) {
        NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
        __block CGFloat totalWidth = 0.0;
        
        int i = 0;
        [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.right;
            UIImage *sectionImage = [self.sectionImages objectAtIndex:i];
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left;
            
            CGFloat combinedWidth = 0.0;
            if (self.imagePosition == XWSegImagePositionLeftOfText || self.imagePosition == XWSegImagePositionRightOfText) {
                combinedWidth = imageWidth + stringWidth + self.textImageSpacing;
            } else {
                combinedWidth = MAX(imageWidth, stringWidth);
            }
            
            totalWidth += combinedWidth;
            
            [mutableSegmentWidths addObject:[NSNumber numberWithFloat:combinedWidth]];
        }];
        
        if (self.shouldStretchSegmentsToScreenSize && totalWidth < self.bounds.size.width) {
            CGFloat whitespace = self.bounds.size.width - totalWidth;
            CGFloat whitespaceForSegment = whitespace / [mutableSegmentWidths count];
            [mutableSegmentWidths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat extendedWidth = whitespaceForSegment + [obj floatValue];
                [mutableSegmentWidths replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:extendedWidth]];
            }];
        }
        
        self.segmentWidthsArray = [mutableSegmentWidths copy];
    }

    self.scrollView.scrollEnabled = self.isUserDraggable;
    self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
}

- (NSUInteger)sectionCount {
    if (self.type == XWSegTypeText) {
        return self.sectionTitles.count;
    } else if (self.type == XWSegTypeImages ||
               self.type == XWSegTypeTextImages) {
        return self.sectionImages.count;
    }
    
    return 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    if (self.sectionTitles || self.sectionImages) {
        [self updateSegmentsRects];
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    CGRect enlargeRect =   CGRectMake(self.bounds.origin.x - self.enlargeEdgeInset.left,
                      self.bounds.origin.y - self.enlargeEdgeInset.top,
                      self.bounds.size.width + self.enlargeEdgeInset.left + self.enlargeEdgeInset.right,
                      self.bounds.size.height + self.enlargeEdgeInset.top + self.enlargeEdgeInset.bottom);
    
    if (CGRectContainsPoint(enlargeRect, touchLocation)) {
        NSInteger segment = 0;
        if (self.segmentWidthStyle == XWSegStyleFixed) {
            segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        } else if (self.segmentWidthStyle == XWSegStyleDynamic) {
            // To know which segment the user touched, we need to loop over the widths and substract it from the x position.
            CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
            for (NSNumber *width in self.segmentWidthsArray) {
                widthLeft = widthLeft - [width floatValue];
                
                // When we don't have any width left to substract, we have the segment index.
                if (widthLeft <= 0)
                    break;
                
                segment++;
            }
        }
        
        NSUInteger sectionsCount = 0;
        
        if (self.type == XWSegTypeImages) {
            sectionsCount = [self.sectionImages count];
        } else if (self.type == XWSegTypeTextImages || self.type == XWSegTypeText) {
            sectionsCount = [self.sectionTitles count];
        }
        
        if (segment != self.selectedIndex && segment < sectionsCount) {
            // Check if we have to do anything with the touch event
            if (self.isTouchEnabled)
                [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
        }
    }
}

#pragma mark - Scrolling

- (CGFloat)totalSegmentedControlWidth {
    if (self.type == XWSegTypeText && self.segmentWidthStyle == XWSegStyleFixed) {
        return self.sectionTitles.count * self.segmentWidth;
    } else if (self.segmentWidthStyle == XWSegStyleDynamic) {
        return [[self.segmentWidthsArray valueForKeyPath:@"@sum.self"] floatValue];
    } else {
        return self.sectionImages.count * self.segmentWidth;
    }
}

- (void)scrollToSelectedSegmentIndex:(BOOL)animated {
    CGRect rectForSelectedIndex = CGRectZero;
    CGFloat selectedSegmentOffset = 0;
    if (self.segmentWidthStyle == XWSegStyleFixed) {
        rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedIndex,
                                          0,
                                          self.segmentWidth,
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    } else {
        NSInteger i = 0;
        CGFloat offsetter = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedIndex == i)
                break;
            offsetter = offsetter + [width floatValue];
            i++;
        }
        
        rectForSelectedIndex = CGRectMake(offsetter,
                                          0,
                                          [[self.segmentWidthsArray objectAtIndex:self.selectedIndex] floatValue],
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - ([[self.segmentWidthsArray objectAtIndex:self.selectedIndex] floatValue] / 2);
    }
    
    
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:animated];
}

#pragma mark - Index Change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedIndex = index;
    [self setNeedsDisplay];
    
    if (index == XWSegmentedControlNoSegment) {
        [self.indicatorArrowLayer removeFromSuperlayer];
        [self.indicatorStripLayer removeFromSuperlayer];
        [self.indicatorBoxLayer removeFromSuperlayer];
    } else {
        [self scrollToSelectedSegmentIndex:animated];
        
        if (animated) {
            // If the selected segment layer is not added to the super layer, that means no
            // index is currently selected, so add the layer then move it to the new
            // segment index without animating.
            if(self.selectionStyle == XWSegSelectionStyleArrow) {
                if ([self.indicatorArrowLayer superlayer] == nil) {
                    [self.scrollView.layer addSublayer:self.indicatorArrowLayer];
                    
                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
                    return;
                }
            }else {
                if ([self.indicatorStripLayer superlayer] == nil) {
                    [self.scrollView.layer addSublayer:self.indicatorStripLayer];
                    
                    if (self.selectionStyle == XWSegSelectionStyleBox && [self.indicatorBoxLayer superlayer] == nil)
                        [self.scrollView.layer insertSublayer:self.indicatorBoxLayer atIndex:0];
                    
                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
                    return;
                }
            }
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
            
            // Restore CALayer animations
            self.indicatorArrowLayer.actions = nil;
            self.indicatorStripLayer.actions = nil;
            self.indicatorBoxLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [self setArrowFrame];
            self.indicatorBoxLayer.frame = [self frameForSelectionIndicator];
            self.indicatorStripLayer.frame = [self frameForSelectionIndicator];
            self.indicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            [CATransaction commit];
        } else {
            // Disable CALayer animations
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.indicatorArrowLayer.actions = newActions;
            [self setArrowFrame];
            
            self.indicatorStripLayer.actions = newActions;
            self.indicatorStripLayer.frame = [self frameForSelectionIndicator];
            
            self.indicatorBoxLayer.actions = newActions;
            self.indicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
        }
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeHandle)
        self.indexChangeHandle(index);
}

#pragma mark - Styling Support

- (NSDictionary *)resultingTitleTextAttributes {
    NSDictionary *defaults = @{
        NSFontAttributeName : [UIFont systemFontOfSize:19.0f],
        NSForegroundColorAttributeName : [UIColor blackColor],
    };
    
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
    
    if (self.titleTextAttributes) {
        [resultingAttrs addEntriesFromDictionary:self.titleTextAttributes];
    }

    return [resultingAttrs copy];
}

- (NSDictionary *)resultingSelectedTitleTextAttributes {
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:[self resultingTitleTextAttributes]];
    
    if (self.selectedTitleTextAttributes) {
        [resultingAttrs addEntriesFromDictionary:self.selectedTitleTextAttributes];
    }
    
    return [resultingAttrs copy];
}

@end
