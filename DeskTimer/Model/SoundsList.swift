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
    @objc
	class func sounds() -> [String]
	{
		var result: [String] = [];
		
		let soundDirPath = "/System/Library/Sounds";
		let recognisedSoundExtension = "aiff";
		
        let url = NSURL.fileURL(withPath: soundDirPath, isDirectory: true);
		
		var possibleDirList: [URL]?
		do {
            possibleDirList = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: FileManager.DirectoryEnumerationOptions())
		} catch {
			possibleDirList = nil
		};
		
		if let dirList = possibleDirList {
			for fileUrl in dirList  {
				let fileNameExtension = fileUrl.pathExtension;
				
                if fileNameExtension == recognisedSoundExtension {
                    let fileName = fileUrl.deletingPathExtension().lastPathComponent
                    result.append(fileName)
				}
			}
		} else {
			
		}
		
		return result;
	}
}
