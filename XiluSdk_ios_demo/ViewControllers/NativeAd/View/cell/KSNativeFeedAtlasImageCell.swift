import UIKit
import SnapKit
#if canImport(KSAdSDK)
import KSAdSDK
#endif
import SDWebImage

class KSNativeFeedAtlasImageCell: KSNativeFeedCell {

    private let kNativeFeedAtlasImageNum = 3

    private let imageGroupView = UIView()

    private lazy var imageViews: [UIImageView] = {
        (0..<kNativeFeedAtlasImageNum).map { _ in
            let iv = UIImageView()
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 2
            return iv
        }
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageGroupView)
        for iv in imageViews {
            imageGroupView.addSubview(iv)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func refresh(with nativeAd: KSNativeAd) {
        super.refresh(with: nativeAd)
        guard let array = nativeAd.data?.imageArray else { return }
        for i in 0..<kNativeFeedAtlasImageNum where i < array.count {
            let url = array[i].imageURL
            imageViews[i].sd_setImage(with: URL(string: url))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // ===== 照搬 OC demo =====
        imageGroupView.snp.remakeConstraints { make in
            make.top.equalTo(40)
            make.bottom.equalTo(-40)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }

        let width = bounds.size.width - 20
        let groupViewWidth = (width - 4 * 2) / 3.0

        var lastImageView: UIImageView?
        for imageView in imageViews {
            imageView.snp.remakeConstraints { make in
                make.top.bottom.equalTo(0)
                make.width.equalTo(groupViewWidth)
                if let last = lastImageView {
                    make.left.equalTo(last.snp.right).offset(4)
                } else {
                    make.left.equalTo(0)
                }
            }
            lastImageView = imageView
        }
    }
}
