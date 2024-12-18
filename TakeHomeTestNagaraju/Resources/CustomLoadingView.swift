//
//  CustomLoadingView.swift
//  TakeHomeTest
//
//  Created by Raju on 18/12/24.
//

import Foundation
import SwiftUI

struct CustomLoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    @Binding var loadingMessage: String
    var content: () -> Content

    var body: some View {
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                if isShowing {
                    Rectangle().foregroundColor(ColorConstants.black.opacity(Double(ScalingFactor.scalePoint6)))
                        .ignoresSafeArea(.all, edges: .bottom)
                }
                VStack(spacing: 0) {
                    Spacer().frame(height: SpacingConstants.space25)
                    ProgressView()
                        .controlSize(.large)
                    Spacer().frame(height: SpacingConstants.space8)
                    Text(loadingMessage == "" ? StringConstants.loadingText : loadingMessage)
                        .font(Font.caption)
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: SpacingConstants.space25)
                }
                .frame(width: UIScreen.main.bounds.width * ScalingFactor.scalePoint7)
                .background(Color.init(white: ScalingFactor.scalePoint9))
                .cornerRadius(RadiusConstant.radius8)
                .opacity(self.isShowing ? 1 : 0)
            }
    }

}
