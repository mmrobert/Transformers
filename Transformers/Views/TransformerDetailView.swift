//
//  TransformerDetailView.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-27.
//

import SwiftUI

// used to "update" or "create" transformer
struct TransformerDetailView: View {
    
    private let teams: [String] = ["A", "D"]
    @Environment(\.presentationMode) var presentationMode
    @State private var transformer: TransformerViewModel
    @State private var createOrUpdate: CreateOrUpdate
    
    init(transformer: TransformerViewModel, createOrUpdate: CreateOrUpdate) {
        _transformer = State(initialValue: transformer)
        _createOrUpdate = State(initialValue: createOrUpdate)
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $transformer.name)
            Picker(selection: $transformer.team,
                   label: Text("Team").foregroundColor(.primary)
            ) {
                ForEach(teams, id: \.self) { team in
                    Text(team)
                }
            }
            Stepper(value: $transformer.rank, in: 0...10,
                    label: {
                        Text("Rank:  [\(transformer.rank)]")
                    }
            )
            Stepper(value: $transformer.strength, in: 0...10,
                    label: {
                        Text("Strength:  [\(transformer.strength)]")
                    }
            )
            Stepper(value: $transformer.intelligence, in: 0...10,
                    label: {
                        Text("Intelligence:  [\(transformer.intelligence)]")
                    }
            )
            Stepper(value: $transformer.speed, in: 0...10,
                    label: {
                        Text("Speed:  [\(transformer.speed)]")
                    }
            )
            Stepper(value: $transformer.endurance, in: 0...10,
                    label: {
                        Text("Endurance:  [\(transformer.endurance)]")
                    }
            )
            Stepper(value: $transformer.courage, in: 0...10,
                    label: {
                        Text("Courage:  [\(transformer.courage)]")
                    }
            )
            Stepper(value: $transformer.firepower, in: 0...10,
                    label: {
                        Text("Firepower:  [\(transformer.firepower)]")
                    }
            )
            Stepper(value: $transformer.skill, in: 0...10,
                    label: {
                        Text("Skill:  [\(transformer.skill)]")
                    }
            )
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.saveTransformer()
            //self.createOrUpdate = .Update
        }, label: { Text(createOrUpdate.rawValue) }))
        .resignKeyboardOnDragGesture()
    }
    
    func saveTransformer() {
        switch createOrUpdate {
        case .Create:
            TransformersListViewModel.createTransformer(transformer: transformer)
            presentationMode.wrappedValue.dismiss()
        case .Update:
            TransformersListViewModel.updateTransformer(transformer: transformer)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TransformerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransformerDetailView(transformer: TransformerViewModel.createEmptyTransformer(), createOrUpdate: .Create)
    }
}
