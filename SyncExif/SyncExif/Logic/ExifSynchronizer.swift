//
//  ExifSynchronizer.swift
//  SyncExif
//
//  Created by Jonathan Duss on 02.05.2024.
//

import Foundation

class ExifSynchronizer {
    
    static func syncExif(fromFile: URL, toFile: URL) throws {
        
        let exiftoolPath = "/usr/local/bin/exiftool"
        let task = Process()
        task.executableURL = URL(fileURLWithPath: exiftoolPath)
        task.arguments = ["-tagsFromFile", fromFile.path, "-extractEmbedded", "-all:all", "-Orientation=", "-FileModifyDate", "-overwrite_original", toFile.path]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        try task.run()
        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: outputData, encoding: .utf8) {
            print("Sync metadata output:", output)
        }
    }
}
