//
//  PaywallViewController.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import UIKit
import SnapKit

final class PaywallViewController: UIViewController {

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
        let fullText = "Try 7 days for free\n then $6.99 per week, auto-renewable"
        let attributed = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ])
        if let range = fullText.range(of: "$6.99") {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
        }
        label.attributedText = attributed
        label.textAlignment = .left
        label.numberOfLines = 0
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

        let fullText = "By continuing you accept our: Terms of Use, Privacy Policy, Subscription Terms"
        let attributed = NSMutableAttributedString(string: fullText, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
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

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white

        [imageView, titleLabel, subtitleLabel, startButton, termsTextView, closeButton].forEach { view.addSubview($0) }

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

        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
        }

        termsTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(startButton.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(16)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapStart() {
        print("Start Now tapped — simulating subscription")
        UserDefaults.standard.set(true, forKey: "isPremium")

        let alert = UIAlertController(title: "Almost there!", message: "You now have access to premium features.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)

        print("Subscription simulated and alert shown")
    }
}







