//
//  WorkoutListView.swift
//  fitProgress
//
//  Created by Koty Stannard on 8/11/22.
//

import SwiftUI

struct WorkoutListView: View {
    
    var body: some View {
        List {
            Section {
                Text("Bench")
                Text("Overhead Press")
                Text("Cable fly")
                Text("Tricep Pushdown")
            } header: {
                Text("Push")
            }
            
            Section {
                Text("Deadlift")
                Text("Barbell Row")
                Text("Lat Pulldown")
                Text("Hammer Curl")
            } header: {
                Text("pull")
            }

            Section {
                Text("Squat")
                Text("Leg Press")
                Text("Leg Extension")
                Text("Calf Raise")
            } header: {
                Text("Legs")
            }
        }
    }
}

struct WorkoutListViewPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
    }
}
