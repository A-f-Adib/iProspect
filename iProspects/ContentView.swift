//
//  ContentView.swift
//  iProspects
//
//  Created by A.f. Adib on 1/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var prospects = Prospects()
    
    var labelName = LabelName()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label(labelName.everyOne, systemImage: labelName.personImg )
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label(labelName.contacted, systemImage: labelName.checkmark)
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label(labelName.uncontacted, systemImage: labelName.qmark )
                }
            
            MeView()
                .tabItem {
                    Label(labelName.me, systemImage: labelName.person)
                }
        }.environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
