//
//  MainEntryView.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-26.
//

import SwiftUI
import Combine

// Transformers list page with navigation button "Edit" and "Add"
struct MainEntryView: View {
    
    @ObservedObject var viewModel = TransformersListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // list view
                List {
                    ForEach(viewModel.list) {
                        TransformerCellView(transformer: $0)
                    }
                    .onDelete(perform: { indexSet in
                        let toDelete = indexSet.map { viewModel.list[$0] }
                        for vm in toDelete {
                            TransformersListViewModel.deleteTransformer(transformer: vm)
                        }
                    })
                }
                HStack(alignment: .center) {
                    Button("Start a Battle") { self.startBattle() }
                }
            }
            .navigationBarTitle("Transformers")
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink(destination: TransformerDetailView(transformer: TransformerViewModel.createEmptyTransformer(), createOrUpdate: .Create)) { Text("Add") })
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                self.viewModel.viewLoaded = true
            }
        }
    }
    
    func startBattle() {
        viewModel.startBattle()
    }
}

struct MainEntryView_Previews: PreviewProvider {
    static var previews: some View {
        MainEntryView()
    }
}
