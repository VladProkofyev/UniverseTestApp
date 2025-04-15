//
//  PaywallViewController.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import UIKit
import SnapKit

final class PaywallViewController: UIViewController {

    private let viewModel = PaywallViewModel()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paywall_illustration")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover all\nPremium features"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left

        let fullText = "Try 7 days for free\nthen $6.99 per week, auto-renewable"
        let attributed = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ])

        if let range = fullText.range(of: "$6.99") {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ], range: nsRange)
        }

        label.attributedText = attributed
        return label
    }()

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 26
        return button
    }()

    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.dataDetectorTypes = [.link]
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        let fullText = "By continuing you accept our:\nTerms of Use, Privacy Policy, Subscription Terms"
        let attributed = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.darkGray,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ])

        let links: [String: String] = [
            "Terms of Use": "https://example.com/terms",
            "Privacy Policy": "https://example.com/privacy",
            "Subscription Terms": "https://example.com/subscription"
        ]

        for (text, urlString) in links {
            if let range = fullText.range(of: text) {
                let nsRange = NSRange(range, in: fullText)
                attributed.addAttribute(.link, value: urlString, range: nsRange)
            }
        }

        textView.attributedText = attributed
        return textView
    }()

    private let bottomContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()

        viewModel.loadProduct { [weak self] product in
            guard let self = self else { return }
            if product == nil {
                print("Product loading failed")
            }
        }
    }


    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(closeButton)
        view.addSubview(bottomContainer)

        bottomContainer.addSubview(startButton)
        bottomContainer.addSubview(termsTextView)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.4).priority(.medium)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }

        bottomContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        startButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }

        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.centerX.equalToSuperview()
        }
    }

    private func setupActions() {
        startButton.isEnabled = true
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }


    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapStart() {
        viewModel.purchase { [weak self] success in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: success ? "Almost there!" : "Oops!",
                    message: success ? "You now have access to premium features." : "The purchase was cancelled or failed.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
}







