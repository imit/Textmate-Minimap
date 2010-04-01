//
//  BackgroundUpdater.m
//  Textmate-Minimap
//
//  Created by Julian Eberius on 20.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BackgroundUpdater.h"
#include "math.h"
#import "MinimapView.h"
#import "AsyncBGDrawOperation.h"

@implementation BackgroundUpdater

- (id)initWithMinimapView:(MinimapView*)mv andOperationQueue:(NSOperationQueue*)opQueue
{
	self = [super init];
    if (self) {
		minimapView = mv;
		operationQueue = opQueue;
		dirtyRegions = [[NSMutableArray arrayWithCapacity:[[minimapView theImage] size].height/50] retain];
	}
    return self;
}

- (void) dealloc
{
	[super dealloc];
	[dirtyRegions release];
}

- (void)startRedrawInBackground
{
	NSRect visRect = [minimapView getVisiblePartOfMinimap];
	[operationQueue cancelAllOperations];
	[operationQueue setSuspended:YES];
	for (NSValue* val in dirtyRegions) {
		NSRange range = [val rangeValue];
		NSRect rectToDraw = NSMakeRect(visRect.origin.x, range.location-1, visRect.size.width, range.length+1);
		AsyncBGDrawOperation* op = [[[AsyncBGDrawOperation alloc] initWithMinimapView:minimapView andUpdater:self] autorelease];
		[op setPartToDraw:rectToDraw andRangeObject:(NSValue*)val];
		[operationQueue addOperation:op];
	}
	[operationQueue setSuspended:NO];
}

- (void)rangeWasRedrawn:(NSValue*)range
{
	[dirtyRegions removeObject:range];
}

- (void)setDirtyExceptForVisiblePart
{
	NSImage* image = [minimapView theImage];
	NSRect visRect = [minimapView getVisiblePartOfMinimap];
<<<<<<< HEAD

=======
	
>>>>>>> newesttry
	int i = visRect.origin.y+visRect.size.height;
	int t = visRect.origin.y;
	BOOL goUp = TRUE;
	BOOL goDown = TRUE;
	while (goUp || goDown) {
		if (goDown) {
			int length = 50;
			if ((i+length) > [image size].height) {
				length = [image size].height - i;
			}
<<<<<<< HEAD
			NSRange range = NSMakeRange(i, length+1);
			[self setRangeDirty:range];
			i=i+50;
			if (i>[image size].height)
				goDown = FALSE;
		}
		if (goUp) {
			int length = 50;
			if ((t-length) < 0) {
				length = t;
			}
			NSRange range = NSMakeRange(t, length+1);
			[self setRangeDirty:range];
			t = t-50;
			if (t<0)
				goUp = FALSE;
		}
	}
}

- (void)setRangeDirty:(NSRange)range
{
	NSValue* val = [NSValue valueWithRange:range];
	for (NSValue* v in dirtyRegions)
		if ([v isEqualToValue:val]) {
			return;
		}
	[dirtyRegions addObject:val];
}

- (void)addDirtyRegions:(NSArray *)regions
{
	[dirtyRegions addObjectsFromArray:regions];
}

- (void)setCompleteImageDirty
{
	NSImage* image = [minimapView theImage];
	int i;
	for (i=0;i<[image size].height;i=i+50) {
		int length = 50;
		if ((i+length) > [image size].height) {
			length = [image size].height - i;
		}
		NSRange range = NSMakeRange(i-1,length+1);
		[dirtyRegions addObject:[NSValue valueWithRange:range]];
=======
			
			NSRect rectToDraw = NSMakeRect(visRect.origin.x, i-1, visRect.size.width, length+1);
			AsyncDrawOperation* op = [[[AsyncDrawOperation alloc] initWithMinimapView:minimapView andMode:MM_BACKGROUND_DRAW] autorelease];
			[op setPartToDraw:rectToDraw];
			[operationQueue addOperation:op];
			i=i+50;
			if (i>[image size].height)
				goDown = FALSE;
		}
		if (goUp) {
			int length = 50;
			if ((t-length) < 0) {
				length = t;
			}
			
			NSRect rectToDraw = NSMakeRect(visRect.origin.x, t-length-1, visRect.size.width, length+1);
			AsyncDrawOperation* op = [[[AsyncDrawOperation alloc] initWithMinimapView:minimapView andMode:MM_BACKGROUND_DRAW] autorelease];
			[op setPartToDraw:rectToDraw];
			[operationQueue addOperation:op];
			t = t-50;
			if (t<0)
				goUp = FALSE;
		}
>>>>>>> newesttry
	}
}
@end
