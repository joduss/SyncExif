//
//  ContentView.swift
//  SyncExif
//
//  Created by Jonathan Duss on 02.05.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var file1: URL?
    @State private var file2: URL?
    @State private var progress: String = "Waiting for file..."
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Transfer Metadata from")
            DropZoneView(file: $file1, label: "Drop file 1 here")
            Text("to")
            DropZoneView(file: $file2, label: "Drop file 2 here")

            Button("Sync Metadata") {
                // Action to sync metadata
                if let file1 = file1, let file2 = file2 {
                    // Implement your logic to sync metadata here
                    print("Syncing metadata for \(file1.lastPathComponent) and \(file2.lastPathComponent)")
                    do {
                        progress = "Processing"
                        try ExifSynchronizer.syncExif(fromFile: file1, toFile: file2)
                        progress = "Done"
                    } catch DefaultError.Error(message: let msg) {
                        progress = "Error: \(msg)"
                    } catch {
                        progress = "Unknown error \(error)"
                    }
                    
                } else {
                    print("Please drop files into both zones to sync metadata.")
                }
            }
            .buttonStyle(DefaultButtonStyle())
            
            Text(progress)
        }
        .padding()
    }
}

struct DropZoneView: View {
    @Binding var file: URL?
    var label: String

    var body: some View {
        VStack {
            if let file = file {
                Text(file.lastPathComponent)
                    .font(.title)
                Text(file.path)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text(label)
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlColor))
        .cornerRadius(10)
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            if let provider = providers.first(where: { $0.canLoadObject(ofClass: URL.self) } ) {
                let _ = provider.loadObject(ofClass: URL.self) { object, error in
                    if let url = object {
                        print("url: \(url)")
                        file = url
                    }
                }
                return true
            }
            return false
        }
//        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
//            for provider in providers {
//                do {
//                    print(provider.registeredContentTypes)
//                    provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, completionHandler: { coding, error in
//                            print(coding)
//                        
//                        if let data = coding as? NSData {
//                            var s = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
//                            print(s)
//                        }
//                        
//                    })
////                    let item = try provider.registeredTypeIdentifiers.readURL()
////                    DispatchQueue.main.async {
////                        self.file = item
////                    }
//                } catch {
//                    print("Failed to read dropped file: \(error.localizedDescription)")
//                }
//            }
//            return true
//        }
    }
}


#Preview {
    ContentView()
}
