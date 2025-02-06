import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false // Состояние авторизации

    // Заранее установленные данные
    private let correctUsername = "Admin" // Правильный логин
    private let correctPassword = "1234"  // Правильный пароль

    var body: some View {
        if isLoggedIn {
            // Переход на HomeView после успешного логина
            HomeView(isLoggedIn: $isLoggedIn)
        } else {
            NavigationView {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 25) {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        VStack(spacing: 15) {
                            TextField("Username", text: $username)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)

                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
                        }
                        .padding(.horizontal, 30)

                        Button(action: login) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .font(.headline)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
                        }
                        .padding(.horizontal, 30)

                        Spacer()
                    }
                    .padding(.top, 100)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }

    private func login() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Please enter username and password"
            showingAlert = true
            return
        }

        // Проверяем правильность логина и пароля
        if username == correctUsername && password == correctPassword {
            // Если данные совпадают
            isLoggedIn = true
        } else {
            // Если логин или пароль неправильные
            alertMessage = "Invalid username or password"
            showingAlert = true
        }
    }
}
