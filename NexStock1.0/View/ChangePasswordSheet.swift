import SwiftUI

struct ChangePasswordSheet: View {
    @State private var newPassword = ""
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.tertiaryColor)
            }

            Spacer()

            Text("change_password".localized)
                .font(.headline)
                .foregroundColor(.tertiaryColor)

            Spacer()

            Button("save".localized) { changePassword() }
                .disabled(newPassword.isEmpty)
                .foregroundColor(.tertiaryColor)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .background(Color.primaryColor)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.primaryColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    header

                    ScrollView {
                        VStack(spacing: 20) {
                            SectionContainer(title: "") {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("new_password".localized)
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    SecureField("new_password".localized, text: $newPassword)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding()
                        .foregroundColor(.tertiaryColor)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("password_updated".localized, isPresented: $showSuccessAlert) {
            Button("ok".localized, role: .cancel) {
                dismiss()
            }
        }
        .alert("error_occurred".localized, isPresented: $showErrorAlert) {
            Button("ok".localized, role: .cancel) {}
        }
    }

    private func changePassword() {
        guard let id = authService.userInfo?.id else {
            showErrorAlert = true
            return
        }
        UserService.shared.changePassword(id: id, newPassword: newPassword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    showSuccessAlert = true
                case .failure(let error):
                    print(error)
                    showErrorAlert = true
                }
            }
        }
    }
}
