//
//  Timer.h
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

#import <Foundation/Foundation.h>

extern NSString *const kTimerDidTickNotification;
extern NSString *const kTimerDidFireNotification;

@interface Timer : NSObject

- (void)setHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
- (void)start;
- (void)stop;

@property (nonatomic, readonly) NSTimeInterval remainingTime;

@property (nonatomic, readonly) NSUInteger remainingHours;
@property (nonatomic, readonly) NSUInteger remainingMinutes;
@property (nonatomic, readonly) NSUInteger remainingSeconds;

@end
