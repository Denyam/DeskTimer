//
//  TimerController.m
//  DeskTimer
//
//  Created by Denis on 26/03/2015.
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

#import "TimerController.h"

#import "Timer.h"

#import "DeskTimer-Swift.h"

@interface TimerController ()
@property (nonatomic) IBOutlet NSButton *startButton;
@property (nonatomic) IBOutlet NSButton *stopButton;
@property (nonatomic) IBOutlet NSTextField *secondsField;
@property (nonatomic) IBOutlet NSTextField *minutesField;
@property (nonatomic) IBOutlet NSTextField *hoursField;
@property (nonatomic) IBOutlet NSNumberFormatter *secondsFormatter;
@property (nonatomic) IBOutlet NSNumberFormatter *minutesFormatter;
@property (nonatomic) IBOutlet NSNumberFormatter *hoursFormatter;
@property (nonatomic) IBOutlet NSPopUpButton *soundSelectionButton;

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)selectSound:(id)sender;

@property (nonatomic) Timer *timer;

- (void)timerDidFire:(NSNotification *)notification;
- (void)timerDidTick:(NSNotification *)notification;

- (void)triggerAlarm;

- (void)adjustFieldValue:(NSTextField *)textField;
- (void)configureFormatter:(NSNumberFormatter *)formatter;

@property (nonatomic) NSArray *soundNames;
@property (nonatomic) NSUInteger selectedSoundIndex;
@end


@implementation TimerController

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
	[self configureFormatter:self.secondsFormatter];
	[self configureFormatter:self.minutesFormatter];
	[self configureFormatter:self.hoursFormatter];
	
	if (self.soundNames.count)
	{
		self.soundSelectionButton.title = self.soundNames[self.selectedSoundIndex];
	}
}

- (void)startTimer:(id)sender
{
	[self adjustFieldValue:self.secondsField];
	[self adjustFieldValue:self.minutesField];
	[self adjustFieldValue:self.hoursField];
	
	self.startButton.enabled = NO;
	self.stopButton.enabled = YES;
	[self.timer setHours:self.hoursField.integerValue minutes:self.minutesField.integerValue seconds:self.secondsField.integerValue];
	[self.timer start];
}

- (void)stopTimer:(id)sender
{
	self.startButton.enabled = YES;
	self.stopButton.enabled = NO;
	[self.timer stop];
}

- (void)selectSound:(id)sender
{
	self.selectedSoundIndex = self.soundSelectionButton.indexOfSelectedItem;
}

- (void)timerDidTick:(NSNotification *)notification
{
	self.secondsField.stringValue = [self.secondsField.formatter stringFromNumber:@(self.timer.remainingSeconds)];
	self.minutesField.stringValue = [self.secondsField.formatter stringFromNumber:@(self.timer.remainingMinutes)];
	self.hoursField.stringValue = [self.secondsField.formatter stringFromNumber:@(self.timer.remainingHours)];
}

- (void)timerDidFire:(NSNotification *)notification
{
	self.startButton.enabled = YES;
	self.stopButton.enabled = NO;
	
	[self triggerAlarm];
}

- (void)triggerAlarm
{
	NSSound *sound = nil;
	if (self.soundNames.count)
	{
		sound = [NSSound soundNamed:self.soundNames[self.selectedSoundIndex]];
		sound.loops = YES;
		[sound play];
	}
	
	NSAlert *alert = [NSAlert new];
	alert.messageText = NSLocalizedString(@"Time elapsed!", nil);
	[alert addButtonWithTitle:NSLocalizedString(@"OK", nil)];
	[alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
		[sound stop];
	}];
}

- (void)adjustFieldValue:(NSTextField *)textField
{
	NSInteger value = textField.integerValue;
	if ((textField != self.hoursField) && (value > 59))
	{
		value = 59;
	}
	if (value < 0)
	{
		value = 0;
	}
	textField.stringValue = [textField.formatter stringFromNumber:@(value)];
}

- (void)configureFormatter:(NSNumberFormatter *)formatter
{
	if (formatter != self.hoursFormatter)
	{
		formatter.format = @"00";
		formatter.formatWidth = 2;
		formatter.paddingCharacter = @"0";
	}
	formatter.allowsFloats = NO;
	formatter.maximumSignificantDigits = 2;
	formatter.maximumIntegerDigits = 2;
}

- (Timer *)timer
{
	if (!_timer)
	{
		_timer = [Timer new];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerDidFire:) name:kTimerDidFireNotification object:_timer];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerDidTick:) name:kTimerDidTickNotification object:_timer];
	}
	return _timer;
}

- (NSArray *)soundNames
{
	if (!_soundNames)
	{
		_soundNames = [SoundsList sounds];
	}
	return _soundNames;
}

@end
