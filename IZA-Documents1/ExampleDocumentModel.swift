//
//  SimpleDocumentModel.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


/**
 
 Wrapper nad UIDocument. Umi open/save.
 Drzi hodnotu obsahu nacteneho dokumentu.
 Je mu jedno, zda-li je soubor local/cloud. To urcuje URL.
 
 */
class ExampleDocModel: ObservableObject {
    /// primitivni obsah dokumentu. primo data
    @Published var data = ExampleDocScheme()
    @Published var modified = false
    
    /// komentar o stavu dokumentu (pro ucely View)
    @Published var msg: String = "Zatím prázdný"
    
    /// dokument se ocekava na tomto url
    let _url: URL
    
    ///
    var __localModifs: AnyCancellable!
    
    //
    private var _docOpen: SimpleUIDocument<ExampleDocScheme>?
    private var allocDoc: SimpleUIDocument<ExampleDocScheme> {
        //
        SimpleUIDocument<ExampleDocScheme>(fileURL: _url)
    }
    
    //
    init(url: URL) {
        //
        _url = url
        
        // kazda udalost na objektu, TODO: jinak
        __localModifs = $data.sink { _ in
            //
            self.modified = true
        }
    }
    
    ///
    func close() {
        //
        _docOpen?.close()
        _docOpen = nil
    }
    
    /// TODO
    func delete() {
        //
        data = ExampleDocScheme()
        msg = "Smazaný"
    }
    
    ///
    func save() {
        /// nesmi zrovna probihat zadna akce nad dokumentem
        guard _docOpen == nil else {
            //
            return ;
        }
        
        /// alokuj UIDocument, pres do nej data
        _docOpen = allocDoc
        _docOpen!.loadedDocument = data
        
        /// do View
        msg = "Zahajuju save"
        
        //
        let _SaveOp = UIDocument.decideSaveOperation(url: _url)
        
        //
        _docOpen!.save(to: _url, for: _SaveOp) { ok in
            //
            self.close()
            self.msg = ok ? "Ulozeno ok" : "Chyba pri ukladani"
            self.modified = false
        }
    }
    
    ///
    func load() {
        /// zamek....
        guard _docOpen == nil else {
            //
            return ;
        }
        
        /// alokuj
        _docOpen = allocDoc
        
        //
        _docOpen?.open { ok in
            //
            self.msg = "Chyba nacitani"
            
            //
            if ok, let _do = self._docOpen?.loadedDocument {
                //
                self.data = _do
                self.msg = "Nacteno OK"
                self.modified = false
            }
            
            //
            self.close()
        }
    }
    
    //
    func openIfExists() {
        //
        DispatchQueue.main.async {
            //
            self._openIfExists()
        }
    }
    
    //
    internal func _openIfExists() {
        //
        if _url.fileExists {
            //
            load()
        }
    }
}

