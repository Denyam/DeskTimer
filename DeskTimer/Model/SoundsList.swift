//
//  SoundsList.swift
//  DeskTimer
//
//  Created by Denis on 27/03/2015.
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


import Cocoa

class SoundsList: NSObject
{
	class func sounds() -> [String]
	{
		var result: [String] = [];
		
		let soundDirPath = "/System/Library/Sounds";
		let recognisedSoundExtension = "aiff";
		
		let url = NSURL.fileURLWithPath(soundDirPath, isDirectory: true);
		
		let errorPtr = NSErrorPointer();
		var possibleDirList: [AnyObject]?
		do {
			possibleDirList = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(url, includingPropertiesForKeys: [], options: NSDirectoryEnumerationOptions())
		} catch let error as NSError {
			errorPtr.memory = error
			possibleDirList = nil
		};
		
		if let dirList = possibleDirList {
			for fileUrl in dirList as! [NSURL] {
				let fileNameExtension = fileUrl.pathExtension ?? "";
				
				if fileNameExtension == recognisedSoundExtension {
					if let fileName = fileUrl.URLByDeletingPathExtension?.lastPathComponent {
						result.append(fileName);
					}
				}
			}
		} else {
			
		}
		
		return result;
	}
}
