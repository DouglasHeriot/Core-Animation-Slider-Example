//
//  DHDSlider.m
//  CoreAnimationSlider
//
//  Created by Douglas Heriot on 21/09/12.
//  Copyright (c) 2012 Douglas Heriot. All rights reserved.
//

#import "DHDSlider.h"
#import "NSBezierPath+MCAdditions.h"
#import <QuartzCore/QuartzCore.h>

@interface DHDSlider()
{
	NSPoint clickLocation;
	double clickDoubleValue;
}
@property (strong) CALayer *thumb;
@property (nonatomic) BOOL active;
@end

@implementation DHDSlider

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
		self.doubleValue = 0.2;
		self.active = NO;
		
		self.wantsLayer = YES;
		self.layer.masksToBounds = NO;
		self.layer.mask = nil;
		
		self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawNever;
		
		self.layer.contents = [NSImage imageWithSize:NSMakeSize(20.0, 20.0) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
			
			NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(0.5, 0.5, 19.0, 19.0) xRadius: 5.0 yRadius: 5.0];
			
			[NSGraphicsContext saveGraphicsState];
			
			// Draw backgound
			[[NSColor colorWithDeviceWhite:0.8 alpha:1.0] set];
			[path fill];
			
			// Inner Glow/Shadow
			NSShadow *innerGlow = [[NSShadow alloc] init];
			[innerGlow setShadowBlurRadius:path.bounds.size.height / 3];
			[innerGlow setShadowOffset:NSMakeSize(0.0, 0.0)];
			[innerGlow setShadowColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.2]];
			
			[path fillWithInnerShadow:innerGlow];
			
			// Draw border
			[[NSColor colorWithDeviceWhite:0.6 alpha:1.0] set];
			[path stroke];
		
			[NSGraphicsContext restoreGraphicsState];
			
			return YES;
		}];
		
		self.layer.contentsCenter = CGRectMake(0.5, 0.5, 1e-5, 1e-5);
		
		self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;
		
		self.thumb = [CALayer layer];
		self.thumb.contents = [NSImage imageWithSize:NSMakeSize(40.0, 40.0) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
			
			NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(0.5, 0.5, 39.0, 39.0) xRadius: 5.0 yRadius: 5.0];
			
			[NSGraphicsContext saveGraphicsState];
			
			// Draw backgound
			NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.9] endingColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.0]];
			[gradient drawInBezierPath:path angle:90.0];
			
			// Inner Glow/Shadow
			NSShadow *innerGlow = [[NSShadow alloc] init];
			[innerGlow setShadowBlurRadius:path.bounds.size.height / 8];
			[innerGlow setShadowOffset:NSMakeSize(0.0, -1.0)];
			[innerGlow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.3]];
			
			[path fillWithInnerShadow:innerGlow];
			
			// Draw border
			[[NSColor colorWithDeviceWhite:0.1 alpha:1.0] set];
			[path stroke];
			
			[NSGraphicsContext restoreGraphicsState];
			
			return YES;
		}];
		self.thumb.contentsCenter = CGRectMake(0.25, 0.25, 0.25, 0.25);
		
		[self.layer addSublayer:self.thumb];
		
		[self setNeedsLayout:YES];
		[self setNeedsDisplay:YES];
    }
    
    return self;
}

- (BOOL)wantsUpdateLayer
{
	return YES;
}

- (void)layout
{
	[super layout];
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	NSSize thumbSize = NSMakeSize(self.bounds.size.width, self.bounds.size.width);
	NSRect thumbFrame;
	thumbFrame.size = thumbSize;
	thumbFrame.origin.x = 0.0;
	thumbFrame.origin.y = (self.bounds.size.height - thumbSize.height) * self.doubleValue;
	self.thumb.frame = thumbFrame;
	
	[CATransaction commit];
}

- (void)updateLayer
{
	self.thumb.shadowColor = [[NSColor blackColor] CGColor];
	self.thumb.shadowOffset = CGSizeMake(0.0, -0.5);
	self.thumb.shadowOpacity = 0.8;
	
	self.thumb.cornerRadius = 5.0;
	
	if(self.active)
	{
		self.thumb.shadowRadius = 1.5;
		self.thumb.backgroundColor = [NSColor colorWithDeviceRed:0.081 green:0.644 blue:0.788 alpha:0.670].CGColor;
	}
	else
	{
		self.thumb.shadowRadius = 0.5;
		self.thumb.backgroundColor = [NSColor clearColor].CGColor;
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{
	clickLocation = NSEvent.mouseLocation;
	clickDoubleValue = self.doubleValue;
	
	self.active = YES;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	CGFloat diff = NSEvent.mouseLocation.y - clickLocation.y;
	double newValue = clickDoubleValue + (diff / (self.bounds.size.height - self.thumb.frame.size.height));
	
	if(newValue > 1.0)
		newValue = 1.0;
	else if(newValue < 0.0)
		newValue = 0.0;
	
	self.doubleValue = newValue;
}

- (void)mouseUp:(NSEvent *)theEvent
{
	self.active = NO;
}

- (void)setActive:(BOOL)active
{
	_active = active;
	[self setNeedsDisplay:YES];
}

- (void)setDoubleValue:(double)doubleValue
{
	_doubleValue = doubleValue;
	[self setNeedsLayout:YES];
	[self noteFocusRingMaskChanged];
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (NSRect)focusRingMaskBounds
{
	return self.bounds;
}

- (void)drawFocusRingMask
{
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: self.thumb.frame xRadius: 5.0 yRadius: 5.0];
	[path fill];
}

@end
