//
//  PullToRefresh.swift
//  PullToRefresh
//
//  Created by Oleg Bakharev on 06.03.2024.
//

import SwiftUI

public extension View {
    // Full analog iOS 15 refreshable view modifier for iOS 13+
    func pullRefreshable(action: @Sendable @escaping () async -> Void) -> some View {
        modifier(PullToRefreshModifier(action: action))
    }
}

public extension EnvironmentValues {
    // Full analog iOS 15 refresh environment key for iOS 13+
    var pullRefresh: (() async -> Void)? {
        get { self[PullRefreshEnvironmentKey.self] }
        set { self[PullRefreshEnvironmentKey.self] = newValue }
    }
}

// MARK: - Private part

private struct PullToRefresh: UIViewRepresentable {

    class Coordinator {
        let action: @Sendable () async -> Void

        init(action: @Sendable @escaping () async -> Void) {
            self.action = action
        }

        @objc func onRefreshTriggered(sender: UIRefreshControl) {
            Task { @MainActor in
                await action()
                sender.endRefreshing()
            }
        }
    }

    let action: @Sendable () async -> Void

    // MARK: - Internal methods

    func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView { UIView() }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {
        // Необходима развязка по времени т.к. на момент вызова uiView ещё не в иерархии
        Task { @MainActor in
            guard let viewHost = uiView.superview?.superview else {
                print("failed to retrieve hostView")
                return
            }
            guard let scrollView = self.findScrollView(root: viewHost) else {
                print("failed to retrieve UIScrollView")
                return
            }

            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(
                context.coordinator,
                action: #selector(context.coordinator.onRefreshTriggered(sender:)),
                for: .valueChanged
            )
            scrollView.refreshControl = refreshControl
            // Если не выставить позицию рефреша, то в групповом стиле фон таблицы перекроет рефреш
            scrollView.insertSubview(refreshControl, at: 1)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    // MARK: - Private methods

    private func findScrollView(root: UIView) -> UIScrollView? {
        for subview in root.subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            } else if let scrollView = findScrollView(root: subview) {
                return scrollView
            }
        }
        return nil
    }

}

private struct PullToRefreshModifier: ViewModifier {
    let action: @Sendable () async -> Void

    func body(content: Content) -> some View {
        content
            .background(PullToRefresh(action: action))
            .environment(\.pullRefresh, action)
    }
}

private struct PullRefreshEnvironmentKey: EnvironmentKey {
    static var defaultValue: (() async -> Void)? = nil
}
