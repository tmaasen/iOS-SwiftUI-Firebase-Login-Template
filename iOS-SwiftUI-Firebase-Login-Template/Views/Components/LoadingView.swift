//
//  LoadingView.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 3/7/25.
//

import SwiftUI

struct LoadingView: View {
	var body: some View {
		ZStack {
			Color.black.opacity(0.2)
				.ignoresSafeArea()
			
			VStack(spacing: 16) {
				ProgressView()
					.scaleEffect(1.5)
					.tint(.white)
				
				Text("Loading...")
					.font(.headline)
					.foregroundColor(.white)
			}
			.padding(24)
			.background(
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.gray.opacity(0.7))
			)
		}
		.transition(.opacity)
	}
}
