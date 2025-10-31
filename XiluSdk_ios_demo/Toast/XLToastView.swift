import UIKit
import SnapKit

private let textFont: UIFont = UIFont.systemFont(ofSize: 15)
private let textSpacing: CGFloat = 3.0
private let duration: CGFloat = 2.5

public class XLToastView: UIView {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = textFont
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        isUserInteractionEnabled = false

        backgroundColor = UIColor.init(white: 0, alpha: 0.6)

        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError()
    }
}

public extension XLToastView {

    static func show(_ text: String?, targetView: UIView? = nil) {
        guard let text, !text.isEmpty else {
            return
        }

        DispatchQueue.main.async {
            let toastView = XLToastView()
            toastView.textLabel.text = text

            guard let superView = targetView ?? UIApplication.shared.keyWindow else {
                return
            }
            superView.subviews
                .filter { $0 is XLToastView }
                .forEach { $0.removeFromSuperview() }

            superView.addSubview(toastView)

            toastView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview().offset(20)
                make.right.lessThanOrEqualToSuperview().offset(-20)
                make.top.greaterThanOrEqualToSuperview().offset(20)
                make.bottom.lessThanOrEqualToSuperview().offset(-20)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                toastView.removeFromSuperview()
            }
        }
    }

    static func hide(_ targetView: UIView? = nil) {
        guard let superView = targetView ?? UIApplication.shared.keyWindow else {
            return
        }

        DispatchQueue.main.async {
            superView.subviews
                .filter { $0 is XLToastView }
                .forEach { $0.removeFromSuperview() }
        }
    }
}
