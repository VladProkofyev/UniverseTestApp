//
//  OnboardingService.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol OnboardingServiceProtocol {
    func fetchOnboardingSteps() -> Observable<[OnboardingStep]>
}

final class OnboardingService: OnboardingServiceProtocol {
    func fetchOnboardingSteps() -> Observable<[OnboardingStep]> {
        guard let url = URL(string: "https://test-ios.universeapps.limited/onboarding") else {
            return .error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }

        return URLSession.shared.rx
            .data(request: URLRequest(url: url))
            .map { data in
                let decoder = JSONDecoder()
                let container = try decoder.decode(ResponseContainer.self, from: data)
                return container.items
            }
    }
}
