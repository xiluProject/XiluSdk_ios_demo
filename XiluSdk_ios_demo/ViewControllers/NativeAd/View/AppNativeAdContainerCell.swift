//
//  AppNativeAdContainerCell.swift
//  SwiftDemo
//
//  Created by publicjoker on 20/10/2025.
//

import UIKit
import ADXiluSDK
import SnapKit

class AppNativeAdContainerCell: UITableViewCell {
    public func configAd(_ adView: UIView?) {
        if let adView = adView {
            adContainerView.addSubview(adView)
            adView.snp.makeConstraints { make in
                make.height.equalTo(max(adView.frame.size.height, 100))
                make.edges.equalToSuperview().inset(4)
            }
            contentView.setNeedsLayout()
        }
    }
    
    private var adContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .mainBackgroundColor
        container.clipsToBounds = true
        return container
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        addContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addContainer()
    }

    func addContainer() {
        contentView.addSubview(adContainerView)
        adContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
