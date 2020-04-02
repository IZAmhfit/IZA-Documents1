//
//  FileManager-extensions.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation


//
extension URL {
    //
    var fileExists: Bool {
        //
        FileManager.default.fileExists(atPath: path)
    }
}


//
public enum DirectoryType : String {
    //
    case localDocuments = "Lokální"
    case cloudDocuments = "iCloud"
}


//
extension NotificationCenter {
    //
    static let reloadDirs = NSNotification.Name("iza-docs-reload")
    
    //
    func pingToReload() {
        //
        post(Notification(name: NotificationCenter.reloadDirs))
    }
}


// Zkratky na filePath/URL do sandboxu aplikace, adresar pro
// uzivatelske dokumenty
public extension FileManager {
    // lokalni adresar pro dokumenty, existuje vzdy
    static var localDocs: URL {
        //
        if let _dir = FileManager.default.urls(for: .documentDirectory,
                                               in: .userDomainMask).first
        {
            //
            return _dir
        }
        
        //
        abort()
    }
    
    // adresar pro iCloud dokumenty. Pokud uzivatel nepovoli iCloud, pak nil
    static var cloudDocs: URL? {
        // zjisteni zakladniho ubiquitous adresare
        // soucasne slouzi take jako univerzalni test provozuschopnosti
        // iCloud dokumentu pro dany AppleID
        if let _d = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
            // rozsirim o ...
            return _d.appendingPathComponent("Documents", isDirectory: true)
        }
        
        //
        return nil
    }
    
    // ...
    static var cloudON: Bool { cloudDocs != nil }
    
    //
    static func dirContents(_ url: URL) -> [URL] {
        //
        let _fm = FileManager.default
        
        //
        if let _cont = try? _fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        {
            //
            return _cont
        }
        
        //
        return []
    }
    
    //
    static func loadLocalContents() -> [URL] {
        //
        FileManager.dirContents(localDocs)
    }
    
    //
    static func loadCloudContents() -> [URL] {
        //
        if let _cl = cloudDocs {
            //
            return dirContents(_cl)
        }
        
        //
        return []
    }
    
    //
    static func loadDir(type: DirectoryType) -> [URL] {
        //
        switch type {
        case .localDocuments:
            //
            return loadLocalContents()
        case .cloudDocuments:
            //
            return loadCloudContents()
        }
    }
}

