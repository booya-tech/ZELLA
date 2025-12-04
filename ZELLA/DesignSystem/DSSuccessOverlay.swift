//
//  DSSuccessOverlay.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

import SwiftUI

struct DSSuccessOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                FontAwesomeIcon(FontAwesome.Icon.check, size: 12)
                    .foregroundStyle(.white)
                Text(AppString.sizesSavedSuccessfully)
                    .font(.roboto(.body2Regular))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, Constants.mainPadding)
            .padding(.vertical, Constants.secondaryPadding)
            .background(AppColors.success)
            .cornerRadius(Constants.buttonRadius)
            .shadow(radius: Constants.shadowButtonRadius)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    DSSuccessOverlay()
}
