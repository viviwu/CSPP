//
//  XWTypewriterView.m
//  WritingAnimationMessageView
//
//  Created by viviwu on 2/08/14.
//  Copyright (c) 2014 viviwu. All rights reserved.
//

#import "XWTypewriterView.h"

#import <QuartzCore/QuartzCore.h>

#define kScreen_W [[UIScreen mainScreen] bounds].size.width
#define kScreen_H [[UIScreen mainScreen] bounds].size.height

#define RepeatCount 100

static XWTypewriterView *_XWTypewriterView = nil;

@implementation XWTypewriterView

@synthesize  textView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = UIColor.blackColor;
        textView = [[UITextView alloc]initWithFrame:CGRectMake(5.0, 5.0, self.frame.size.width-10.0, self.frame.size.height-10.0)];
        textView.backgroundColor = UIColor.clearColor;
        textView.textColor = UIColor.yellowColor;
        textView.font = [UIFont systemFontOfSize:16.0];
        textView.textAlignment = NSTextAlignmentJustified;
        textView.editable = NO;
        [self addSubview:textView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)printMessage:(NSString*)message
          inDuration:(float)duration
{
    TCSTART
    
    [self setHidden:FALSE];
    [msgAttribute removeAllObjects];
    if(!msgAttribute) msgAttribute = [NSMutableDictionary dictionary];
    
    if (message&&message.length>0)
    {
        [msgAttribute setObject:message forKey:@"message"];
        [msgAttribute setObject:[NSNumber numberWithBool:YES] forKey:@"textOnly"];
        [msgAttribute setObject:[NSNumber numberWithBool:YES] forKey:@"animated"];
        [msgAttribute setObject:[NSNumber numberWithBool:NO] forKey:@"blink"];
        [msgAttribute setObject:[NSNumber numberWithBool:YES] forKey:@"IsWritingAnimation"]; 
    }
    
    if (msgAttribute.count>0&&(!isShowing))
    {
        isCancelled=FALSE;
        isShowing = TRUE;
        [textView.layer removeAllAnimations];
        [textView setAlpha:1.0f];
        
        if (((NSNumber*)[msgAttribute objectForKey:@"blink"]).boolValue)
            [self Blink];
        
        disappeared = FALSE;
        textView.backgroundColor=[UIColor clearColor];
        [textView setShowsVerticalScrollIndicator:TRUE];
        textView.layer.cornerRadius = 10.0;
        textView.layer.masksToBounds = YES;
        textView.opaque=NO;
        
        textToDisplay = [msgAttribute objectForKey:@"message"];
        
//        CGRect mainScreenBounds = [[UIScreen mainScreen]bounds];
//        CGRect globalRect = CGRectInset(mainScreenBounds, kScreen_W/6, kScreen_H/6);
//        [textView setFrame:globalRect];
        
        if (!((NSNumber*)[msgAttribute objectForKey:@"IsWritingAnimation"]).boolValue)
            [textView setText:textToDisplay];
        else
        {
            charactersNO_ = textToDisplay.length;
            charPos=0;
            [self writingAnimation];
        }
        
        if (((NSNumber*)[msgAttribute objectForKey:@"textOnly"]).boolValue==TRUE)
        {
            [textView setShowsVerticalScrollIndicator:FALSE];
        }
        else
        {
            [textView setShowsVerticalScrollIndicator:TRUE];
        }
         
        if (((NSNumber*)[msgAttribute objectForKey:@"animated"]).boolValue==TRUE)
        {
            [self showAnimationAsIfMoving:textView IsShowing:YES];
            [NSTimer scheduledTimerWithTimeInterval:duration
                                             target:self
                                           selector:@selector(finish1:)
                                           userInfo:nil
                                            repeats:NO];
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:duration
                                             target:self
                                           selector:@selector(finish2:)
                                           userInfo:nil
                                            repeats:NO];
        }
        
        [msgAttribute removeAllObjects];
    }
    
    TCEND
}

-(void)showAnimationAsIfMoving:(UIView *)Object
                     IsShowing:(bool) IsShowing
{
	TCSTART
	
	if (isCancelled)return;
	
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
		
		float Distance1 = kScreen_W;
		float Distance2 = kScreen_W;
		
		if (IsShowing)
		{
			[animation setDuration:0.3];
			Distance1=kScreen_W;
			Distance2=0;
		}
		else
		{			
			[animation setDuration:0.5];
			Distance1=0;
			Distance2=kScreen_W;
		}
		[animation setRepeatCount:0];
		[animation setAutoreverses:NO];
		[animation setFromValue:[NSValue valueWithCGPoint:
								 CGPointMake([Object center].x - Distance1, [Object center].y)]];
		[animation setToValue:[NSValue valueWithCGPoint:
							   CGPointMake([Object center].x + Distance2, [Object center].y)]];
		[[Object layer] addAnimation:animation forKey:@"position"];
	
	TCEND
}


-(void)finish2:(NSTimer*)Sender
{
	TCSTART
	
	if (isCancelled)return;
	
	isShowing = FALSE;
	
	if (msgAttribute.count>0)
	{
        [self printMessage:@"" inDuration:0];
		return;
	}
	
	[self setHidden:TRUE];
	
	TCEND
}


-(void)finish1:(NSTimer*)Sender
{
	TCSTART
	
	if (isCancelled)return;
	
	if (disappeared)
	{
		isShowing = FALSE;
		if (msgAttribute.count>0)
		{
			[self printMessage:@"" inDuration:0];
			return;
		}
		[self setHidden:TRUE];
	}
	else
	{
		[self showAnimationAsIfMoving:textView IsShowing:NO];
		disappeared = TRUE;
		
		[NSTimer scheduledTimerWithTimeInterval:1
										 target:self
									   selector:@selector(finish1:)
									   userInfo:nil
										repeats:NO];
	}
	
	TCEND
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self cleanUpEverything];
}

-(void)cleanUpEverything
{
	TCSTART
	
		isCancelled = TRUE;
		textView.text=@"";
		[self setHidden:TRUE];
		[msgAttribute removeAllObjects];
		isShowing = FALSE;
	
	TCEND
}



- (void)Blink
{
	TCSTART
	
	[textView setAlpha:0.0];
	[UIView beginAnimations:@"blink" context:nil];
	
	[UIView setAnimationDuration:.2];
	[UIView setAnimationRepeatAutoreverses:YES];
	
	[UIView setAnimationRepeatCount: RepeatCount];
	
	[UIView setAnimationDelegate:self];
	
	[textView setAlpha:1.0f];	
	
	[UIView commitAnimations];
	
	TCEND
}


-(void)writingAnimation
{
	TCSTART
	
	if (isCancelled)return;
	
	if ((charPos+1)<=charactersNO_) 
		[textView setText:[NSString stringWithFormat:@"%@ _",[textToDisplay substringToIndex: charPos]]];
	
	else
		[textView setText:[NSString stringWithFormat:@"%@",textToDisplay]];
	
	charPos++;
	
	float time1;
	float time2;
	float time3;
	
	if (textToDisplay.length>32)
	{
		time1 = 0.09;
		time2 = 0.05;
		time3 = 0.01;
	}
	else
	{
		time1 = 0.2;
		time2 = 0.1;
		time3 = 0.05;
	}
	
	if (charPos<=charactersNO_) 
	{
		int RandomNo = arc4random()%(int)6;
		
		if (RandomNo>4)
		{
			[NSTimer scheduledTimerWithTimeInterval:time1  target:self selector:@selector(writingAnimation) userInfo:nil repeats:NO];
		}
		else if (RandomNo>2)
		{
			[NSTimer scheduledTimerWithTimeInterval:time2
											 target:self
										   selector:@selector(writingAnimation)
										   userInfo:nil
											repeats:NO];
		}
		else
		{
			[NSTimer scheduledTimerWithTimeInterval:time3
											 target:self
										   selector:@selector(writingAnimation)
										   userInfo:nil
											repeats:NO];
		}
	}
	
	TCEND
}

@end
