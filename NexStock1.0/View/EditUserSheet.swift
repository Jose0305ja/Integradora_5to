import SwiftUI

struct EditUserSheet: View {
    let details: UserDetailsResponse
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    @State private var username: String
    @State private var firstName: String
    @State private var lastName: String
    @State private var selectedRole: RoleModel?
    @State private var roles: [RoleModel]
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false

    init(details: UserDetailsResponse, onSave: @escaping () -> Void) {
        self.details = details
        self.onSave = onSave
        _username = State(initialValue: details.user.username)
        _firstName = State(initialValue: details.user.first_name)
        _lastName = State(initialValue: details.user.last_name)
        _roles = State(initialValue: details.roles)
        _selectedRole = State(initialValue: details.roles.first(where: { $0.id == details.user.role.id }))
    }

    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.tertiaryColor)
            }

            Spacer()

            Text("edit_user".localized)
                .font(.headline)
                .foregroundColor(.tertiaryColor)

            Spacer()

            Button("save".localized) { saveChanges() }
                .disabled(username.isEmpty || firstName.isEmpty || lastName.isEmpty || selectedRole == nil)
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
                            SectionContainer(title: "information".localized) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("username".localized)
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    TextField("username".localized, text: $username)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("first_name".localized)
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    TextField("first_name".localized, text: $firstName)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("last_name".localized)
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    TextField("last_name".localized, text: $lastName)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.vertical, 4)
                            .foregroundColor(.tertiaryColor)

                            SectionContainer(title: "role".localized) {
                                Picker("role".localized, selection: $selectedRole) {
                                    ForEach(roles, id: \.self) { role in
                                        Text(role.name).tag(role as RoleModel?)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        .padding()
                        .foregroundColor(.tertiaryColor)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear { print("[EditUserSheet] appear for \(details.user.id)") }
        .navigationBarBackButtonHidden(true)
        .alert("changes_saved".localized, isPresented: $showSuccessAlert) {
            Button("ok".localized, role: .cancel) {
                dismiss()
                onSave()
            }
        }
        .alert("error_occurred".localized, isPresented: $showErrorAlert) {
            Button("ok".localized, role: .cancel) {}
        }
    }


    private func saveChanges() {
        guard let role = selectedRole else { return }
        let update = UpdateUserModel(username: username, first_name: firstName, last_name: lastName, role_id: role.id)
        UserService.shared.updateUser(id: details.user.id, user: update) { result in
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
