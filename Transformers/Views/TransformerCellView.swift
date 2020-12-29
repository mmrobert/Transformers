//
//  TransformerCellView.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-27.
//

import SwiftUI
import SDWebImageSwiftUI

struct TransformerCellView: View {
    
    private var transformer: TransformerViewModel
    private var rating: Int
    
    init(transformer: TransformerViewModel) {
        self.transformer = transformer
        self.rating = transformer.strength + transformer.intelligence +
            transformer.speed + transformer.endurance + transformer.firepower
    }
    
    var body: some View {
        NavigationLink(destination: TransformerDetailView(transformer: transformer, createOrUpdate: .Update)) {
            HStack {
                // using third party framework "SDWebImageSwiftUI"
                WebImage(url: URL(string: transformer.team_icon ?? ""))
                    .resizable()
                    .placeholder { Rectangle().foregroundColor(.gray) }
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading) {
                    Text("Name:  [\(transformer.name)]")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Team:  [\(transformer.team)]")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Rank:  [\(String(transformer.rank))]")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Overall Rating:  [\(String(rating))]")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct TransformerCellView_Previews: PreviewProvider {
    static var previews: some View {
        TransformerCellView(transformer: TransformerViewModel.createEmptyTransformer())
    }
}

