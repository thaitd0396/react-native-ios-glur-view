import Foundation
import UIKit
import SwiftUI

// Vendored Glur sources are compiled in the same target, so no import needed

@objc(GlurHostingView)
public class GlurHostingView: UIView {
    // Exposed via KVC from Objective-C++
    @objc public dynamic var radius: Double = 8.0 { didSet { updateRootView() } }
    @objc public dynamic var offset: Double = 0.3 { didSet { updateRootView() } }
    @objc public dynamic var interpolation: Double = 0.4 { didSet { updateRootView() } }
    @objc public dynamic var noise: Double = 0.1 { didSet { updateRootView() } }
    @objc public dynamic var drawingGroup: Bool = true { didSet { updateRootView() } }
    // 0 up, 1 down, 2 left, 3 right
    @objc public dynamic var directionRaw: Int = 1 { didSet { updateRootView() } }
    @objc public dynamic var imageUri: String? { didSet { updateRootView() } }

    private var hostingController: UIHostingController<GlurWrapper>?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        updateRootView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        hostingController?.view.frame = bounds
    }

    private func updateRootView() {
        let direction: BlurDirection
        switch directionRaw {
        case 0: direction = .up
        case 1: direction = .down
        case 2: direction = .left
        case 3: direction = .right
        default: direction = .down
        }

        let view = GlurWrapper(
            radius: radius,
            offset: offset,
            interpolation: interpolation,
            direction: direction,
            noise: noise,
            drawingGroup: drawingGroup,
            imageUri: imageUri
        )

        if let hc = hostingController {
            hc.rootView = view
        } else {
            let hc = UIHostingController(rootView: view)
            hc.view.backgroundColor = .clear
            addSubview(hc.view)
            hostingController = hc
            setNeedsLayout()
        }
    }
}

struct GlurWrapper: View {
    var radius: Double
    var offset: Double
    var interpolation: Double
    var direction: BlurDirection
    var noise: Double
    var drawingGroup: Bool
    var imageUri: String?

    @ViewBuilder
    private var contentImage: some View {
        if let uri = imageUri, !uri.isEmpty {
            if let url = URL(string: uri), url.scheme?.hasPrefix("http") == true {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Color.clear
                    case .empty:
                        Color.clear
                    @unknown default:
                        Color.clear
                    }
                }
            } else {
                // Treat as file path or bundled image name
                if uri.hasPrefix("file://"), let url = URL(string: uri) {
                    if let img = UIImage(contentsOfFile: url.path) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.clear
                    }
                } else if FileManager.default.fileExists(atPath: uri) {
                    if let img = UIImage(contentsOfFile: uri) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.clear
                    }
                } else if let img = UIImage(named: uri) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.clear
                }
            }
        } else {
            // Fallback placeholder
            Rectangle().fill(.ultraThinMaterial)
        }
    }

    var body: some View {
        contentImage
            .clipped()
            .glur(
                radius: radius,
                offset: offset,
                interpolation: interpolation,
                direction: direction,
                noise: noise,
                drawingGroup: drawingGroup
            )
            .accessibilityHidden(true)
    }
}

