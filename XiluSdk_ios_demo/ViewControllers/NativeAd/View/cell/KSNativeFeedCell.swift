import UIKit
import SnapKit
#if canImport(KSAdSDK)
import KSAdSDK
#endif
import SDWebImage

class KSNativeFeedCell: UITableViewCell {

    let relatedView = KSNativeAdRelatedView()

    let appIconImageView = UIImageView()
    let button = UIButton(type: .custom)
    let adIcon = UIImageView()
    let adIcon1 = UIImageView()
    let adLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(appIconImageView)
        contentView.addSubview(button)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(adIcon)
        contentView.addSubview(adIcon1)
        contentView.addSubview(adLabel)
        contentView.addSubview(relatedView.rotateView)

        button.setTitleColor(.blue, for: .normal)
        descriptionLabel.textColor = .blue
        descriptionLabel.font = .systemFont(ofSize: 17)
        adIcon.backgroundColor = UIColor(white: 0, alpha: 0.1)
        adIcon.layer.masksToBounds = true
        adIcon.layer.cornerRadius = 5
        adLabel.font = .systemFont(ofSize: 12)
        adLabel.textColor = .blue

        // ===== 完全照搬 OC demo 的约束 =====
        button.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(5)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.left.equalTo(button.snp.right).offset(10)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        adIcon.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(20)
        }
        adIcon1.snp.makeConstraints { make in
            make.left.equalTo(adIcon.snp.right).offset(5)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(20)
        }
        adLabel.snp.makeConstraints { make in
            make.left.equalTo(adIcon1.snp.right).offset(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(16)
        }
        appIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }

    func refresh(with nativeAd: KSNativeAd) {
        relatedView.refreshData(nativeAd)

        guard let data = nativeAd.data else { return }

        descriptionLabel.text = data.adDescription
        button.setTitle(data.actionDescription, for: .normal)

        if let url = data.appIconImage?.imageURL {
            appIconImageView.sd_setImage(with: URL(string: url))
        }

        relatedView.rotateView.isHidden = !data.enableRotate

        let configuration = KSAdViewActionConfiguration()
        configuration.isClickable = true
        configuration.isSlidable = true
        nativeAd.registerContainer(contentView, with: configuration)

        configuration.isClickable = true
        configuration.isSlidable = true
        nativeAd.registerActionViews([button, descriptionLabel], with: configuration)

        adLabel.text = data.adSource

        let whiteURL = data.adSourceLogoURL(.white)
        adIcon.sd_setImage(with: URL(string: whiteURL))

        let grayURL = data.adSourceLogoURL(.gray)
        adIcon1.sd_setImage(with: URL(string: grayURL))
    }

    // ===== 照搬 OC demo：rotateView 居中并置顶 =====
    override func layoutSubviews() {
        super.layoutSubviews()
        if contentView.subviews.last !== relatedView.rotateView {
            contentView.bringSubviewToFront(relatedView.rotateView)
        }
        relatedView.rotateView.center = contentView.center
    }
}
