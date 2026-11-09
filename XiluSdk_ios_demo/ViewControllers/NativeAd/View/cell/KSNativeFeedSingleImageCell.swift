import UIKit
import SnapKit
#if canImport(KSAdSDK)
import KSAdSDK
#endif
import SDWebImage

class KSNativeFeedSingleImageCell: KSNativeFeedCell {

    private let adImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(adImageView)
        adImageView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.bottom.equalTo(-40)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func refresh(with nativeAd: KSNativeAd) {
        super.refresh(with: nativeAd)
        guard let url = nativeAd.data?.imageArray.first?.imageURL else { return }
        adImageView.sd_setImage(with: URL(string: url))
    }
}
