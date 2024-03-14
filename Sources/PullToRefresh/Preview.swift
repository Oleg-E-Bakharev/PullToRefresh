//
//  Preview.swift
//  PullToRefresh
//
//  Created by Oleg Bakharev on 06.03.2024.
//

import SwiftUI

struct Preview: View {
    // An iOS 15 \.refresh analog
    @Environment(\.pullRefresh) private var refresh

    var body: some View {
        List(1..<20) { row in
            Button("Refresh") {
                Task {
                    await refresh?()
                }
            }
            .disabled(refresh == nil)
        }
    }
}

#Preview {
    Preview()
        .pullRefreshable { // An iOS 15 refreshable analog
            print("refreshing...")
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            print("done!")
        }
}
