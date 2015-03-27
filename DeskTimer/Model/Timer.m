//
//  Timer.m
//  DeskTimer
//
//  Created by Denis on 25/03/2015.
//  Copyright (c) 2015 Denis
//
//	This file is part of DeskTimer.
//
//	DeskTimer is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	DeskTimer is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with DeskTimer.  If not, see <http://www.gnu.org/licenses/>.
//

#import "Timer.h"

NSString *const kTimerDidTickNotification = @"TimerDidTickNotification";
NSString *const kTimerDidFireNotification = @"TimerDidFireNotification";

@interface Timer ()
@property (nonatomic) NSTimeInterval remainingTime;

@property (nonatomic) NSTimer *internalTimer;
@property (nonatomic) NSTimer *secondsTimer;

- (void)timerDidTick:(NSTimer *)timer;
- (void)timerDidFire:(NSTimer *)timer;
@end


@implementation Timer

- (void)dealloc
{
	[self.secondsTimer invalidate];
	[self.internalTimer invalidate];
}

- (void)setHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds
{
	self.remainingTime = seconds + 60 * minutes + 3600 * hours;
}

- (void)start
{
	self.internalTimer = [NSTimer scheduledTimerWithTimeInterval:self.remainingTime target:self selector:@selector(timerDidFire:) userInfo:nil repeats:NO];
	self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDidTick:) userInfo:nil repeats:YES];
}

- (void)stop
{
	[self.internalTimer invalidate];
	[self.secondsTimer invalidate];
}

- (NSUInteger)remainingHours
{
	return (NSUInteger)self.remainingTime / 3600;
}

- (NSUInteger)remainingMinutes
{
	NSUInteger totalMinutes = (NSUInteger)self.remainingTime / 60;
	return totalMinutes % 60;
}

- (NSUInteger)remainingSeconds
{
	return (NSUInteger)self.remainingTime % 60;
}

#pragma mark -

- (void)timerDidTick:(NSTimer *)timer
{
	NSTimeInterval remainingTime = self.internalTimer.fireDate.timeIntervalSinceNow;
	if (remainingTime < 0)
	{
		self.remainingTime = 0;
		[self.secondsTimer invalidate];
	}
	else
	{
		self.remainingTime = remainingTime;
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:kTimerDidTickNotification object:self];

	if (remainingTime < 0)
	{
		if ([self.internalTimer isValid])
		{
			[self.internalTimer fire];
		}
	}
}

- (void)timerDidFire:(NSTimer *)timer
{
	[self.secondsTimer invalidate];
	[[NSNotificationCenter defaultCenter] postNotificationName:kTimerDidFireNotification object:self];
}

@end
