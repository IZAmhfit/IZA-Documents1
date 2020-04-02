//
//  DirectoryView.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit


// Objekt slouzi:
// 1) Pro DirectoryView jako zdroj dat
// 2) Pro dalsi objekty View/Model jako informace o adresari dokumentu
class DirectoryContentModel : ObservableObject {
    //
    @Published var listOfDocuments: [URL] = []
    
    // cloud || local
    let directoryType: DirectoryType
    
    // pokud cloud a soucasne nedostupny => nil
    let homeDir: URL?
    
    //
    func url(forFilename: String) -> URL? {
        //
        guard let _url = homeDir else {
            //
            return nil
        }
        
        //
        return _url.appendingPathComponent(forFilename)
    }
    
    //
    init(type: DirectoryType, dir: URL?) {
        //
        directoryType = type
        homeDir = dir
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(__pingedToReload(notif:)), name: NotificationCenter.reloadDirs, object: nil)
    }
    
    //
    deinit {
        //
        NotificationCenter.default.removeObserver(self)
    }
    
    //
    func setup() {
        //
        listOfDocuments = FileManager.loadDir(type: directoryType)
    }
    
    @objc func __pingedToReload(notif: NSNotification) {
        //
        DispatchQueue.main.async {
            //
            self.setup()
        }
    }
    
    //
    func create(newDocument: URL) {
        //
        listOfDocuments.append(newDocument)
    }
}


/**
 
 Hlavni View aplikace. Udrzuje prehled o existujicich dokumentech.
 
 */
struct DirectoryView : View {
    /// Obsah adresare s dokumenty a sprava dokumentu
    @ObservedObject var dirContent: DirectoryContentModel
    
    /// funkce navrhu noveho dokumentu, datovy model
    @ObservedObject var newNameModel: CreateNewDocumentDialogModel
    
    //
    init(kind: DirectoryType) {
        //
        var _d: DirectoryContentModel!
        
        //
        switch kind {
        case .localDocuments:
            //
            _d = DirectoryContentModel(type: kind, dir: FileManager.localDocs)
        case .cloudDocuments:
            //
            _d = DirectoryContentModel(type: kind, dir: FileManager.cloudDocs)
        }
        
        //
        newNameModel = CreateNewDocumentDialogModel(inDir: _d)
        dirContent = _d
        
        //
        dirContent.setup()
    }
    
    //
    var body: some View {
        //
        NavigationView {
            //
            List(dirContent.listOfDocuments, id:\.self) { (url: URL) in
                //
                NavigationLink(destination: ExampleDocView(url: url,
                                                           dir: self.dirContent))
                {
                    //
                    Text(url.lastPathComponent)
                }
            }
                
            //
            .navigationBarTitle("Přehled: \(dirContent.directoryType.rawValue)")
            .navigationBarItems(trailing:
                //
                HStack {
                    //
                    Button("Add") {
                        //
                        self.newNameModel.sheetON = true
                    }
                    
                    //
                    Button("Reload") {
                        //
                        self.dirContent.setup()
                    }
                }
            )
                
            ///
            .sheet(isPresented: $newNameModel.sheetON) {
                //
                CreateNewDocumentDialog(model: self.newNameModel)
            }
        }
    }
}

