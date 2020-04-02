//
//  ContentView.swift
//  IZA-Documents1
//
//  Created by Martin Hruby on 02/04/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import SwiftUI

///
struct ContentView: View {
    //
    var body: some View {
        //
        TabView {
            //
            DirectoryView(kind: .localDocuments).tag(0).tabItem { Text("Local") }
            DirectoryView(kind: .cloudDocuments).tag(1).tabItem { Text("Cloud") }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
