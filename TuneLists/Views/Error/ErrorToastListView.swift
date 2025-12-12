//
//  ErrorToastListView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 11.12.2025.
//

import SwiftUI

struct ErrorToastListView: View {
    @Environment(ErrorService.self) var service: ErrorService
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ForEach(service.errorQueue) { error in
                ErrorToastView(error: error)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.bouncy, value: service.errorQueue)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .allowsHitTesting(false)
    }
}
