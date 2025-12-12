//
//  ErrorToastView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct ErrorToastView: View {
    let error: TuneListError
    
    var body: some View {
        HStack {
            Image(systemName: error.iconName)
                .foregroundStyle(.white)
            Text(error.localizedDescription)
                .foregroundStyle(.white)
                .font(.subheadline.bold())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.red.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
        .zIndex(1) 
    }
}
