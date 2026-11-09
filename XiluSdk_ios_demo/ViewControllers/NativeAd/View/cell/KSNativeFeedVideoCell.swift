import UIKit
import SnapKit
#if canImport(KSAdSDK)
import KSAdSDK
#endif

class KSNativeFeedVideoCell: KSNativeFeedCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        guard let videoAdView = relatedView.videoAdView else { return }
        contentView.addSubview(videoAdView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // ===== 照搬 OC demo =====
        guard let videoAdView = relatedView.videoAdView else { return }
        videoAdView.snp.remakeConstraints { make in
            make.top.equalTo(40)
            make.bottom.equalTo(-40)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
}
