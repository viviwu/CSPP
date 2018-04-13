//
//  XWTypewriterView.h
//  WritingAnimationMessageView
//
//  Created by viviwu on 2/08/14.
//  Copyright (c) 2014 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>  

#ifndef UseTryCatch
#define UseTryCatch 1//use 0 to disable and 1 to enable the try catch throughout the application


//Warning:Do not Enable this Macro for general purpose...use it if u are intentionally dubbugging for some unexpected method calls
#ifndef UsePTMName
#define UsePTMName 0//use 0 to disable and 1 to enable printing the method name throughout the application


#if UseTryCatch


#if UsePTMName
#define TCSTART @try{NSLog(@"\n%s\n",__PRETTY_FUNCTION__);
#else
#define TCSTART @try{
#endif

#define TCEND  }@catch(NSException *e){NSLog(@"\n\n\n\n\n\n\
\n\n|EXCEPTION FOUND HERE...PLEASE DO NOT IGNORE\
\n\n|FILE NAME         %s\
\n\n|LINE NUMBER       %d\
\n\n|METHOD NAME       %s\
\n\n|EXCEPTION REASON  %@\
\n\n\n\n\n\n\n",strrchr(__FILE__,'/'),__LINE__, __PRETTY_FUNCTION__,e);};


#else

#define TCSTART
#define TCEND

#endif
#endif


#endif
/////////////////////MACROS TO BE VISIBLE THROUGHT THE APPLICATION//////////////////////////////

@interface XWTypewriterView : UIView 
{
    UITextView * textView;
	BOOL disappeared;
    NSMutableDictionary * msgAttribute;
    BOOL isShowing;
	NSString* textToDisplay;
	NSInteger charactersNO_;
	int charPos;
	BOOL isCancelled;
}

@property(nonatomic, strong) UITextView * textView;

//+ (XWTypewriterView *)sharedTypewriter;

- (void)printMessage:(NSString*)message
          inDuration:(float)duration;
 

-(void)cleanUpEverything;

@end
