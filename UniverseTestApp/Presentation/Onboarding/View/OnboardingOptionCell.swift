//
//  OnboardingOptionCell.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 10.04.2025.
//

import UIKit
import SnapKit

final class OnboardingOptionCell: UITableViewCell {

    static let reuseId = "OnboardingOptionCell"

    private let container = UIView()
    private let optionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true
        contentView.addSubview(container)

        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(2)
        }

        optionLabel.font = .systemFont(ofSize: 16)
        optionLabel.textAlignment = .left
        optionLabel.numberOfLines = 0
        optionLabel.lineBreakMode = .byWordWrapping

        container.addSubview(optionLabel)

        optionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    func configure(text: String, isSelected: Bool) {
        optionLabel.text = text
        optionLabel.textColor = isSelected ? .white : .black
        container.backgroundColor = isSelected ? UIColor(hex: "#47BE9A") : .white
    }
}




