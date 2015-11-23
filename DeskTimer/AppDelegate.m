//
//  AppDelegate.m
//  DeskTimer
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

#import "AppDelegate.h"

@interface AppDelegate ()
- (void)saveContext;

@property (weak) IBOutlet NSWindow *window;
@end

static NSString * const kModelName = @"Model";


@implementation AppDelegate

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[self saveContext];
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (!managedObjectContext && self.persistentStoreCoordinator)
	{
		managedObjectContext = [NSManagedObjectContext new];
		managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (!managedObjectModel)
	{
		NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:kModelName withExtension:@"momd"];
		managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
	}
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (!persistentStoreCoordinator)
	{
		NSString *modelDbFilename = [kModelName stringByAppendingString:@".sqlite"];
		NSURL *storeUrl = [self.documentsDirectory URLByAppendingPathComponent:modelDbFilename];
		
		NSError *error = nil;
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
		[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
		if (error)
		{
			NSLog(@"Error: %@: %@", error.localizedDescription, error.localizedFailureReason);
		}
	}
	return persistentStoreCoordinator;
}

- (NSURL *)documentsDirectory
{
	return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

- (void)saveContext
{
	NSError *error = nil;
	if (self.managedObjectContext)
	{
		if (self.managedObjectContext.hasChanges && ![self.managedObjectContext save:&error])
		{
			NSLog(@"Error: %@, %@", error, error.userInfo);
		}
	}
}

@end
