//
//  XWSegmentedControl.h
//  XWSegmentedControl
//
//  Created by vivi wu on 23/12/12.
//  Copyright (c) 2012-2015 vivi wu. All rights reserved.
//  Thanks Hesham Abd-Elmegid with "HMSegmentedControl"

#import <UIKit/UIKit.h>

@class XWSegmentedControl;

typedef void (^IndexChangeHandle)(NSInteger index);
typedef NSAttributedString *(^XWTitleFormatterBlock)(XWSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected);

typedef NS_ENUM(NSInteger, XWSegSelectionStyle) {
    XWSegSelectionStyleTextWidthStripe, // Indicator width will only be as big as the text width
    XWSegSelectionStyleFullWidthStripe, // Indicator width will fill the whole segment
    XWSegSelectionStyleBox, // A rectangle that covers the whole segment
    XWSegSelectionStyleArrow // An arrow in the middle of the segment pointing up or down depending on `XWSegIndicatorLocation`
};

typedef NS_ENUM(NSInteger, XWSegIndicatorLocation) {
    XWSegIndicatorLocationDown,
    XWSegIndicatorLocationUp,
	XWSegIndicatorLocationNone // No selection indicator
};

typedef NS_ENUM(NSInteger, XWSegStyle) {
    XWSegStyleFixed, // Segment width is fixed
    XWSegStyleDynamic, // Segment width will only be as big as the text width (including inset)
};

typedef NS_OPTIONS(NSInteger, XWSegBorderType) {
    XWSegBorderTypeNone = 0,
    XWSegBorderTypeTop = (1 << 0),
    XWSegBorderTypeLeft = (1 << 1),
    XWSegBorderTypeBottom = (1 << 2),
    XWSegBorderTypeRight = (1 << 3)
};

enum {
    XWSegmentedControlNoSegment = -1   // Segment index for no selected segment
};

typedef NS_ENUM(NSInteger, XWSegType) {
    XWSegTypeText,
    XWSegTypeImages,
	XWSegTypeTextImages
};

typedef NS_ENUM(NSInteger, XWSegImagePosition) {
    XWSegImagePositionBehindText,
    XWSegImagePositionLeftOfText,
    XWSegImagePositionRightOfText,
    XWSegImagePositionAboveText,
    XWSegImagePositionBelowText
};

@interface XWSegmentedControl : UIControl

@property (nonatomic, strong) NSArray<NSString *> *sectionTitles;
@property (nonatomic, strong) NSArray<UIImage *> *sectionImages;
@property (nonatomic, strong) NSArray<UIImage *> *sectionSelectedImages;

/**
 Provide a block to be executed when selected index is changed.
 
 Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexChangeHandle indexChangeHandle;

/**
 Used to apply custom text styling to titles when set.
 
 When this block is set, no additional styling is applied to the `NSAttributedString` object returned from this block.
 */
@property (nonatomic, copy) XWTitleFormatterBlock titleFormatter;

/**
 Text attributes to apply to item title text.
 */
@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;

/*
 Text attributes to apply to selected item title text.
 
 Attributes not set in this dictionary are inherited from `titleTextAttributes`.
 */
@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes UI_APPEARANCE_SELECTOR;

/**
 Segmented control background color.
 
 Default is `[UIColor whiteColor]`
 */
@property (nonatomic, strong)IBInspectable UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 Color for the selection indicator stripe
 
 Default is `R:52, G:181, B:229`
 */
@property (nonatomic, strong)IBInspectable UIColor *indicatorColor UI_APPEARANCE_SELECTOR;

/**
 Color for the selection indicator box
 
 Default is indicatorColor
 */
@property (nonatomic, strong)IBInspectable UIColor *indicatorBoxColor UI_APPEARANCE_SELECTOR;

/**
 Color for the vertical divider between segments.
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong)IBInspectable UIColor *verticalDividerColor UI_APPEARANCE_SELECTOR;

/**
 Opacity for the seletion indicator box.
 
 Default is `0.2f`
 */
@property (nonatomic)IBInspectable CGFloat indicatorBoxOpacity;

/**
 Width the vertical divider between segments that is added when `verticalDividerEnabled` is set to YES.
 
 Default is `1.0f`
 */
@property (nonatomic, assign)IBInspectable CGFloat verticalDividerWidth;

/**
 Specifies the style of the control
 
 Default is `XWSegTypeText`
 */
@property (nonatomic, assign)IBInspectable XWSegType type;

/**
 Specifies the style of the selection indicator.
 
 Default is `XWSegSelectionStyleTextWidthStripe`
 */
@property (nonatomic, assign)IBInspectable XWSegSelectionStyle selectionStyle;

/**
 Specifies the style of the segment's width.
 
 Default is `XWSegStyleFixed`
 */
@property (nonatomic, assign)IBInspectable XWSegStyle segmentWidthStyle;

/**
 Specifies the location of the selection indicator.
 
 Default is `XWSegIndicatorLocationUp`
 */
@property (nonatomic, assign)IBInspectable XWSegIndicatorLocation indicatorLocation;

/*
 Specifies the border type.
 
 Default is `XWSegBorderTypeNone`
 */
@property (nonatomic, assign)IBInspectable XWSegBorderType borderType;

/**
 Specifies the image position relative to the text. Only applicable for XWSegTypeTextImages
 
 Default is `XWSegImagePositionBehindText`
 */
@property (nonatomic)IBInspectable XWSegImagePosition imagePosition;

/**
 Specifies the distance between the text and the image. Only applicable for XWSegTypeTextImages
 
 Default is `0,0`
 */
@property (nonatomic)IBInspectable CGFloat textImageSpacing;

/**
 Specifies the border color.
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

/**
 Specifies the border width.
 
 Default is `1.0f`
 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;

/**
 Default is YES. Set to NO to deny scrolling by dragging the scrollView by the user.
 */
@property(nonatomic, getter = isUserDraggable)IBInspectable BOOL userDraggable;

/**
 Default is YES. Set to NO to deny any touch events by the user.
 */
@property(nonatomic, getter = isTouchEnabled)IBInspectable BOOL touchEnabled;

/**
 Default is NO. Set to YES to show a vertical divider between the segments.
 */
@property(nonatomic, getter = isVerticalDividerEnabled)IBInspectable BOOL verticalDividerEnabled;

@property (nonatomic, getter=shouldStretchSegmentsToScreenSize)IBInspectable BOOL stretchSegmentsToScreenSize;

/**
 Index of the currently selected segment.
 */
@property (nonatomic, assign)IBInspectable NSInteger selectedIndex;

/**
 Height of the selection indicator. Only effective when `XWSegSelectionStyle` is either `XWSegSelectionStyleTextWidthStripe` or `XWSegSelectionStyleFullWidthStripe`.
 
 Default is 5.0
 */
@property (nonatomic, readwrite)IBInspectable CGFloat indicatorHeight;

/**
 Edge insets for the selection indicator.
 NOTE: This does not affect the bounding box of XWSegSelectionStyleBox
 
 When XWSegIndicatorLocationUp is selected, bottom edge insets are not used
 
 When XWSegIndicatorLocationDown is selected, top edge insets are not used
 
 Defaults are top: 0.0f
             left: 0.0f
           bottom: 0.0f
            right: 0.0f
 */
@property (nonatomic, readwrite)IBInspectable UIEdgeInsets indicatorEdgeInsets;

/**
 Inset left and right edges of segments.
 
 Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite)IBInspectable UIEdgeInsets segmentEdgeInset;

@property (nonatomic, readwrite)IBInspectable UIEdgeInsets enlargeEdgeInset;

/**
 Default is YES. Set to NO to disable animation during user selection.
 */
@property (nonatomic)IBInspectable BOOL shouldAnimateUserSelection;

- (id)initWithSectionTitles:(NSArray<NSString *> *)sectiontitles;
- (id)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages;
- (instancetype)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages titlesForSections:(NSArray<NSString *> *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeHandle:(IndexChangeHandle)indexChangeHandle;
- (void)setTitleFormatter:(XWTitleFormatterBlock)titleFormatter;

@end
