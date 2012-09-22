//
//  DHDSlider.m
//  CoreAnimationSlider
//
//  Created by Douglas Heriot on 21/09/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHDSlider.h"
#import <QuartzCore/QuartzCore.h>

@interface DHDSlider()
@property (strong) CALayer *thumb;
@end

@implementation DHDSlider

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
		self.wantsLayer = YES;
		
		self.layer.contents = [NSImage imageWithSize:self.bounds.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
			[[NSColor greenColor] set];
			NSRectFill(dstRect);
			return YES;
		}];
		
		NSSize thumbSize = NSMakeSize(self.bounds.size.width, self.bounds.size.width);
		
		self.thumb = [CALayer layer];
		
		self.thumb.contents = [NSImage imageWithSize:thumbSize flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
				[[NSColor redColor] set];
			NSRectFill(dstRect);
			return YES;
		}];
		
		[self.layer addSublayer:self.thumb];
    }
    
    return self;
}

- (BOOL)wantsUpdateLayer
{
	return YES;
}

- (void)updateLayer
{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	NSSize thumbSize = NSMakeSize(self.bounds.size.width, self.bounds.size.width);
	NSRect thumbFrame;
	thumbFrame.size = thumbSize;
	thumbFrame.origin.x = 0.0;
	thumbFrame.origin.y = 0.0;
	self.thumb.frame = thumbFrame;
	
	[CATransaction commit];
	
}

@end
