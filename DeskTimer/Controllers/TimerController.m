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
#import "AppDelegate.h"

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

@property (nonatomic) NSMutableArray<NSManagedObject *> *timerModels;
@property (nonatomic) NSMutableArray<Timer *> *timers;
@property (nonatomic, readonly) Timer *timer;

- (void)timerDidFire:(NSNotification *)notification;
- (void)timerDidTick:(NSNotification *)notification;

- (void)triggerAlarm;

- (void)adjustFieldValue:(NSTextField *)textField;
- (void)configureFormatter:(NSNumberFormatter *)formatter;

@property (nonatomic) NSArray *soundNames;
@property (nonatomic) NSUInteger selectedSoundIndex;

- (Timer *)timerFromModel:(NSManagedObject *)timerModel;
- (void)changeTimerTime;
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
    
    self.hoursField.integerValue = self.timer.remainingHours;
    self.minutesField.integerValue = self.timer.remainingMinutes;
    self.secondsField.integerValue = self.timer.remainingSeconds;
}

- (void)startTimer:(id)sender
{
	[self adjustFieldValue:self.secondsField];
	[self adjustFieldValue:self.minutesField];
	[self adjustFieldValue:self.hoursField];
	
	self.startButton.enabled = NO;
	self.stopButton.enabled = YES;
    [self changeTimerTime];
	
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

- (NSMutableArray *)timers
{
	if (!_timers)
	{
		_timers = [NSMutableArray new];
        
        if (!self.timerModels.count)
        {
            NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Timer" inManagedObjectContext:context];
            NSManagedObject *timerModel = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            [timerModel setValue:@(0) forKey:@"interval"];
            
            [self.timerModels addObject:timerModel];
        }
        
        Timer *timer = [self timerFromModel:self.timerModels.firstObject];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerDidFire:) name:kTimerDidFireNotification object:timer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerDidTick:) name:kTimerDidTickNotification object:timer];
        
        [_timers addObject:timer];
	}
	return _timers;
}

- (NSMutableArray *)timerModels
{
    if (!_timerModels)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Timer"];
        NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
        
        NSError *fetchError = nil;
        _timerModels = [context executeFetchRequest:fetchRequest error:&fetchError].mutableCopy;
    }
    return _timerModels;
}

- (Timer *)timer
{
	return self.timers.firstObject;
}

- (NSArray *)soundNames
{
	if (!_soundNames)
	{
		_soundNames = [SoundsList sounds];
	}
	return _soundNames;
}

- (Timer *)timerFromModel:(NSManagedObject *)timerModel
{
	Timer *result = nil;
	if ([timerModel.entity.name isEqualToString:NSStringFromClass([Timer class])])
	{
		result = [Timer new];
        NSNumber *seconds = [timerModel valueForKey:@"interval"];
        if (seconds)
        {
            [result setHours:0 minutes:0 seconds:seconds.unsignedIntegerValue];
        }
	}
	return result;
}

- (void)changeTimerTime
{
    [self.timer setHours:self.hoursField.integerValue minutes:self.minutesField.integerValue seconds:self.secondsField.integerValue];
    [self.timerModels.firstObject setValue:@(self.timer.remainingTime) forKey:@"interval"];
}

@end
