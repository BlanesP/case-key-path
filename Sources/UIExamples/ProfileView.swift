//
//  ProfileView.swift
//  CasePathable
//


import SwiftUI
import CasePathable

/*
 Goal: Drive two different presentations from the same destination enum and
 use the associated values for the destination views
 E.g. Two buttons in a view, one shows a sheet the other an alert, both come
 from the same enum.
 */

@CasePathable
enum Destination {
    case edit(EditData)
    case info(InfoData)
}

struct EditData: Identifiable {
    let id = UUID()
    var name: String
}

struct InfoData: Identifiable {
    let id = UUID()
    var text: String
}

struct ProfileView: View {
    @State private var destination: Destination?

    var body: some View {
        VStack(spacing: 48) {
            Text("Profile").font(.title)

            Button("Edit") { destination = .edit(EditData(name: "Pau")) }
            
            Button("Info") { destination = .info(InfoData(text: "Member since 2020")) }
            
            Spacer()
        }
        .padding()
        .sheet(item: $destination.edit) { editData in
            Text("Editing \(editData.name)").padding()
        }
        .alert(item: $destination.info) { infoData in
            Alert(title: Text("Info"), message: Text(infoData.text))
        }
    }
}

#Preview {
    ProfileView()
}
