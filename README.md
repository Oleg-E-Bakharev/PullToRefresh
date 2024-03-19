# PullToRefresh
SwiftUI PullToRefresh from iOS13. Fully identically refreshable view modifier from iOS15

Xcode package dependancy:
    https://github.com/Oleg-E-Bakharev/PullToRefresh

SPM Usage:
```swift
    dependencies: [.package(url: "https://github.com/Oleg-E-Bakharev/PullToRefresh", branch: "main")]
```
Use case:
```swift
import SwiftUI
import PullToRefresh

struct PullToRefreshSample: View {
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

public struct PullToRefreshSamplePreview: View {

    public init() {}

    public var body: some View {
        PullToRefreshSample()
            .pullRefreshable { // An iOS 15 refreshable analog
                print("custom refreshing...")
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                print("done!")
            }
    }
}

#Preview {
    PullToRefreshSamplePreview()
}
```
