//
//  DeskTimerTests.m
//  DeskTimerTests
//
//  Created by Denis on 24/03/2015.
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

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "Timer.h"

@interface DeskTimerTests : XCTestCase
@end

@implementation DeskTimerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTimerTimeLeft
{
	static const double secondsInMinute = 60;
	static const double secondsInHour = 3600;
	static const NSUInteger seconds = 10;
	static const NSUInteger minutes = 1;
	static const NSUInteger hours = 2;
	
	Timer *timer = [Timer new];
	[timer setHours:0 minutes:0 seconds:seconds];
	
	XCTAssertEqual(seconds, timer.remainingTime);
	XCTAssertEqual(seconds, timer.remainingSeconds);
	XCTAssertEqual(0, timer.remainingMinutes);
	XCTAssertEqual(0, timer.remainingHours);
	
	Timer *minuteTimer = [Timer new];
	[minuteTimer setHours:0 minutes:minutes seconds:0];
	XCTAssertEqual(minutes * secondsInMinute, minuteTimer.remainingTime);
	XCTAssertEqual(0, minuteTimer.remainingSeconds);
	XCTAssertEqual(minutes, minuteTimer.remainingMinutes);
	XCTAssertEqual(0, minuteTimer.remainingHours);
	
	Timer *hourTimer = [Timer new];
	[hourTimer setHours:hours minutes:0 seconds:0];
	XCTAssertEqual(hours * secondsInHour, hourTimer.remainingTime);
	XCTAssertEqual(0, hourTimer.remainingSeconds);
	XCTAssertEqual(0, hourTimer.remainingMinutes);
	XCTAssertEqual(hours, hourTimer.remainingHours);
}

@end
