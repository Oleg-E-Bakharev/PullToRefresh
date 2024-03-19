# PullToRefresh
SwiftUI PullToRefresh from iOS13. Fully identically refreshable view modifier from iOS15

Xcode package dependancy:
    https://github.com/Oleg-E-Bakharev/PullToRefresh

SPM Usage:
```swift
    dependencies: [.package(url: "https://github.com/Oleg-E-Bakharev/PullToRefresh", from: "1.0.0")]
```
Simple use case:
```swift
import SwiftUI
import PullToRefresh

struct SimpleSample: View {
    var body: some View {
        List(0..<20) { row in
            Text("Item \(row)")
        }
        .pullRefreshable { // An iOS 15 refreshable analog
            print("custom refreshing...")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            print("done!")
        }
    }
}

#Preview {
    SimpleSample()
}
```

Comlex use case:
```swift

import SwiftUI
import PullToRefresh

struct ComplexSample: View {
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

struct ComplexSamplePreview: View {
    var body: some View {
        ComplexSample()
            .pullRefreshable { // An iOS 15 refreshable analog
                print("custom refreshing...")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                print("done!")
            }
    }
}

#Preview {
    ComplexSamplePreview()
}
```
