//
//  OnboardingViewModel.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import Foundation
import RxSwift
import RxRelay

final class OnboardingViewModel {

    private let allSteps = BehaviorRelay<[OnboardingStep]>(value: [])
    private var currentIndex = BehaviorRelay<Int>(value: 0)

    let currentStep = BehaviorRelay<OnboardingStep?>(value: nil)
    let selectedOption = BehaviorRelay<String?>(value: nil)
    let isLastStep = PublishRelay<Bool>()

    func loadSteps(service: OnboardingServiceProtocol) -> Observable<Void> {
        /*
        "items": [
            { "id": 1, "question": "What’s your occupation?", ... },
            { "id": 2, "question": "How old are you?", ... },
            { "id": 3, "question": "How did you find this scanner?", ... }
        ]
        */

        return service.fetchOnboardingSteps()
            .map { steps in
                print("Fetched steps: \(steps.map(\.question))")

                let ordered = [
                    steps.first(where: { $0.id == 1 }),
                    steps.first(where: { $0.id == 2 }),
                    steps.first(where: { $0.id == 3 })
                ].compactMap { $0 }

                print("Ordered steps: \(ordered.map(\.question))")

                self.allSteps.accept(ordered)
                self.currentIndex.accept(0)
                self.currentStep.accept(ordered.first)
            }
    }

    func goToNextStep() {
        var index = currentIndex.value
        index += 1

        if index < allSteps.value.count {
            currentIndex.accept(index)
            currentStep.accept(allSteps.value[index])
            selectedOption.accept(nil)
        } else {
            isLastStep.accept(true)
        }
    }
}
