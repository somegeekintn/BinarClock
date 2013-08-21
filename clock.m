//
//  clock.m
//  BinarClock
//
//  Created by Casey on 12/14/04.
//

#import "clock.h"

#define kDotSize	4

@implementation clockCtl

+ (void) initialize
{
}

- (void) awakeFromNib
{
	NSStatusBar		*bar = [NSStatusBar systemStatusBar];
	
	[NSApp setDelegate: self];

	_clockImage = NULL;
	_dot[eDot_Off] = [NSImage imageNamed: @"dot_off"];
	_dot[eDot_Red] = [NSImage imageNamed: @"dot_red"];
	_dot[eDot_Grn] = [NSImage imageNamed: @"dot_grn"];
	_dot[eDot_Blu] = [NSImage imageNamed: @"dot_blu"];
	_statusItem = [bar statusItemWithLength: (kDotSize * 6) + 3 + 8];
	[_statusItem retain];
	[_statusItem setHighlightMode: YES];
	[_statusItem setMenu: _statusMenu];
	[_statusItem setEnabled: YES];
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateStyle: NSDateFormatterShortStyle];
	[_dateFormatter setTimeStyle: NSDateFormatterShortStyle];

	[self updateClock: NULL];
	
	_timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(updateClock:) userInfo: NULL repeats: YES];
	
}

- (void) dealloc
{
	[_dateFormatter release];
	
	[super dealloc];
}

- (NSApplicationTerminateReply) applicationShouldTerminate: (NSApplication *) inSender
{
	NSStatusBar		*bar = [NSStatusBar systemStatusBar];
	
	[bar removeStatusItem: _statusItem];
	[_timer invalidate];
	
	return NSTerminateNow;
}

- (void) updateClock: (NSTimer *) inTimer
{
	static NSGradient	*sShine = nil;
	NSCalendarDate		*date = [NSCalendarDate calendarDate];
	NSBezierPath		*framePath;
	NSImage				*bit;
	NSPoint				origin;
	NSRect				frame;
	NSUInteger			hour = [date hourOfDay];
	NSUInteger			minute = [date minuteOfHour];
	NSUInteger			secs = [date secondOfMinute];
	NSUInteger			mask;

	if (sShine == nil) {
		sShine = [[NSGradient alloc] initWithColorsAndLocations:
					[NSColor colorWithCalibratedHue: 0.0 saturation: 0.0 brightness: 1.00 alpha: 0.5], (CGFloat)0.00,
					[NSColor colorWithCalibratedHue: 0.0 saturation: 0.0 brightness: 1.00 alpha: 0.3], (CGFloat)0.45,
					[NSColor colorWithCalibratedHue: 0.0 saturation: 0.0 brightness: 0.00 alpha: 0.0], (CGFloat)0.55,
					[NSColor colorWithCalibratedHue: 0.0 saturation: 0.0 brightness: 0.00 alpha: 0.0], (CGFloat)1.00,
					nil];
	}
	
	frame = NSMakeRect(0.0, 0.0, (kDotSize * 6) + 3 + 2, kDotSize * 4 + 2);
	framePath = [NSBezierPath bezierPathWithRoundedRect: frame xRadius: 2.0 yRadius: 2.0];
	
	[_clockImage autorelease];
	_clockImage = [[NSImage alloc] initWithSize: frame.size];
	[_clockImage lockFocus];
		
		[[NSColor colorWithCalibratedHue: 0.0 saturation: 0.0 brightness: 0.1 alpha: 1.0] set];
		[framePath fill];
		
// remove shine
//		[sShine drawInBezierPath: framePath angle: 280.0];

		origin.x = 0;	origin.y = 0;
		// hour tens
		for (mask=0x01; mask<0x04; mask<<=1) {
			bit = ((hour / 10) & mask) ? _dot[eDot_Red] : _dot[eDot_Off];
			[bit compositeToPoint: origin operation: NSCompositeSourceOver];
			origin.y += 4;
		}

		origin.x = kDotSize;	origin.y = 0;
		// hour ones
		for (mask=0x01; mask<0x10; mask<<=1) {
			bit = ((hour % 10) & mask) ? _dot[eDot_Red] : _dot[eDot_Off];
			[bit compositeToPoint: origin operation: NSCompositeSourceOver];
			origin.y += 4;
		}

		origin.x = kDotSize * 2 + 1;	origin.y = 0;
		// minute tens
		for (mask=0x01; mask<0x08; mask<<=1) {
			bit = ((minute / 10) & mask) ? _dot[eDot_Grn] : _dot[eDot_Off];
			[bit compositeToPoint: origin operation: NSCompositeSourceOver];
			origin.y += 4;
		}

		origin.x = kDotSize * 3 + 1;	origin.y = 0;
		// minute ones
		for (mask=0x01; mask<0x10; mask<<=1) {
			bit = ((minute % 10) & mask) ? _dot[eDot_Grn] : _dot[eDot_Off];
			[bit compositeToPoint: origin operation: NSCompositeSourceOver];
			origin.y += 4;
		}

		origin.x = kDotSize * 4 + 2;	origin.y = 0;
		// seconds tens
		for (mask=0x01; mask<0x08; mask<<=1) {
			bit = ((secs / 10) & mask) ? _dot[eDot_Blu] : _dot[eDot_Off];
			[bit compositeToPoint: origin operation: NSCompositeSourceOver];
			origin.y += 4;
		}

		origin.x = kDotSize * 5 + 2;	origin.y = 0;
		// seconds ones
		for (mask=0x01; mask<0x10; mask<<=1) {
			bit = ((secs % 10) & mask) ? _dot[eDot_Blu] : _dot[eDot_Off];
			[bit compositeToPoint: origin operation: NSCompositeSourceOver];
			origin.y += 4;
		}


	[_clockImage unlockFocus];
	[_statusItem setImage: _clockImage];
	[_statusItem setToolTip: [_dateFormatter stringFromDate: date]];
}

- (IBAction) handleAboutItem: (id) inSender
{
	[NSApp orderFrontStandardAboutPanel: NULL];
}

@end
