//
//  DocumentView.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//
//
let __myFormatter: DateFormatter = {
    //
    let _m = DateFormatter()
    
    //
    _m.dateStyle = .short
    _m.timeStyle = .short
    
    //
    return _m
}()

//
extension Date {
    //
    var asString: String {
        //
        return __myFormatter.string(from: self)
    }
}

//
func myTextField(_ placeh: String, text: Binding<String>) -> some View {
    //
    TextField(placeh, text: text).disableAutocorrection(true)
}

/**
 Zobrazeni jednoho dokumentu
 */
struct ExampleDocView : View {
    /// drzim si model obsahu
    @ObservedObject var doc: ExampleDocModel
    /// model pro cely adresar
    @ObservedObject var dir: DirectoryContentModel
    
    ///
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    ///
    init(url: URL, dir: DirectoryContentModel) {
        //
        doc = ExampleDocModel(url: url)
        self.dir = dir
        
        // interne bude odlozeno do MaintQueue.async
        doc.openIfExists()
    }
    
    //
    var transferButtonText: String {
        //
        switch dir.directoryType {
        case .localDocuments:
            //
            return "Přesuň do iCloudu"
        case .cloudDocuments:
            //
            return "Přesuň do lokálu..."
        }
    }
    
    /// local -> cloud a naopak, podle typu "dir"
    func transfer() {
        // pokud se uvazuje klaudizmus
        guard let _cDir = FileManager.cloudDocs else {
            //
            return ;
        }
        
        //
        let _fm = FileManager.default
        let _url = doc._url
        let _filename = _url.lastPathComponent
        let _lDir = FileManager.localDocs
        
        // do klaudu
        if dir.directoryType == .localDocuments {
            let _makeCloud = _cDir.appendingPathComponent(_filename)
            
            //
            try? _fm.setUbiquitous(true, itemAt: _url,
                                   destinationURL: _makeCloud)
        } else {
            // z klaudu
            let _makeLocal = _lDir.appendingPathComponent(_filename)
            
            //
            try? _fm.setUbiquitous(false, itemAt: _url, destinationURL: _makeLocal)
        }
        
        //
        NotificationCenter.default.pingToReload()
        
        //
        mode.wrappedValue.dismiss()
    }
    
    ///
    var body: some View {
        //
        Form {
            //
            Section(header: Text("Head")) {
                //
                List {
                    myTextField("Název dokumentu...", text: $doc.data.nazev)
                    
                    //
                    Text(doc.data.dateCreated.asString)
                }
            }
            
            //
            Section(header: Text("Notes")) {
                //
                ForEach(doc.data.notes, id: \.self) {
                    //
                    Text($0)
                }
            }
            
            //
            Section(header: Text("Actions")) {
                //
                List {
                    //
                    HStack {
                        Text("Hlaseni: "); Spacer(); Text(doc.msg)
                    }
                    
                    //
                    Button("Nova poznamka") {
                        //
                        self.doc.data.notes.append("Nova")
                    }
                    
                    //
                    Button("Ulož") { self.doc.save(); }
                    Button("Načti") { self.doc.load(); }
                    
                    //
                    Button(transferButtonText) { self.transfer() }
                        .disabled(doc.modified == true)
                }
            }
        }
    }
}
