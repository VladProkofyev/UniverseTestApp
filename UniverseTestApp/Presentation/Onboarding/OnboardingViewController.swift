//
//  OnboardingViewController.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

// OnboardingViewController.swift

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {

    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()

    private let tableView = UITableView()
    private let mainTitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let continueButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadSteps(service: OnboardingService())
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F4F8F8")

        mainTitleLabel.text = "Let’s setup App for you"
        mainTitleLabel.font = .boldSystemFont(ofSize: 24)
        mainTitleLabel.textColor = .black
        mainTitleLabel.textAlignment = .left
        mainTitleLabel.numberOfLines = 0

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.contentInset = .zero
        tableView.tableFooterView = UIView()
        tableView.register(OnboardingOptionCell.self, forCellReuseIdentifier: OnboardingOptionCell.reuseId)
        tableView.estimatedRowHeight = 52
        tableView.rowHeight = UITableView.automaticDimension
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(UIColor(hex: "#D0D5DD"), for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        continueButton.backgroundColor = .white
        continueButton.layer.cornerRadius = 26
        continueButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        continueButton.layer.shadowOpacity = 1
        continueButton.layer.shadowRadius = 20
        continueButton.isEnabled = false

        view.addSubview(mainTitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(continueButton)

        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(continueButton.snp.top).offset(-24)
        }

        continueButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(52)
        }
    }

    private func bindViewModel() {
        viewModel.currentStep
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] step in
                self?.titleLabel.text = step.question
                self?.tableView.reloadData()
                self?.continueButton.isEnabled = false
                self?.continueButton.backgroundColor = .white
                self?.continueButton.setTitleColor(UIColor(hex: "#D0D5DD"), for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.selectedOption
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selected in
                let isEnabled = selected != nil
                self?.continueButton.isEnabled = isEnabled
                self?.continueButton.backgroundColor = isEnabled ? UIColor(hex: "#081C15") : .white
                self?.continueButton.setTitleColor(isEnabled ? .white : UIColor(hex: "#D0D5DD"), for: .normal)
            })
            .disposed(by: disposeBag)

        continueButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.goToNextStep()
            }
            .disposed(by: disposeBag)

        viewModel.isLastStep
            .bind(onNext: { [weak self] isLast in
                if isLast {
                    let paywall = PaywallViewController()
                    paywall.modalPresentationStyle = .fullScreen
                    self?.present(paywall, animated: true)
                }
            })
            .disposed(by: disposeBag)

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension OnboardingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.currentStep.value?.answers.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingOptionCell.reuseId, for: indexPath) as? OnboardingOptionCell,
              let step = viewModel.currentStep.value else {
            return UITableViewCell()
        }
        let option = step.answers[indexPath.section]
        let isSelected = viewModel.selectedOption.value == option
        cell.configure(text: option, isSelected: isSelected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = viewModel.currentStep.value?.answers[indexPath.section] else { return }
        viewModel.selectedOption.accept(option)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.05
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}




















