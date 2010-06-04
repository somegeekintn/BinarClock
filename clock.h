//
//  clock.h
//  BinarClock
//
//  Created by Casey on 12/14/04.
//

#import <Cocoa/Cocoa.h>

enum {
	eDot_Off = 0,
	eDot_Red,
	eDot_Grn,
	eDot_Blu,
	eDot_Max
};

@interface clockCtl : NSObject {
	NSImage				*_dot[eDot_Max];
	NSImage				*_clockImage;
	
	IBOutlet NSMenu		*_statusMenu;
	NSStatusItem		*_statusItem;
	NSDateFormatter		*_dateFormatter;
	NSTimer				*_timer;
}

- (void)		updateClock: (NSTimer *) inTimer;

@end
