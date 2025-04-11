//
//  OnboardingStep.swift
//  UniverseTestApp
//
//  Created by Vlad Prokofiev  on 09.04.2025.
//

import Foundation

struct OnboardingStep: Decodable {
    let id: Int
    let question: String
    let answers: [String]
}
