import SwiftUI

struct LaunchScreenView: View {
  var body: some View {
    ZStack {
      Color(.systemBackground)
        .ignoresSafeArea()

      VStack(spacing: 24) {
        Image("AppLogo")
          .resizable()
          .scaledToFit()
          .frame(width: 120, height: 120)
          .clipShape(RoundedRectangle(cornerRadius: 28))

        Text("Renewed")
          .font(.largeTitle.bold())
          .foregroundColor(.primary)
      }
    }
  }
}

#Preview {
  LaunchScreenView()
}
