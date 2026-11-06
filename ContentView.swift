import SwiftUI

struct ContentView: View {
    @StateObject private var espManager = GhostESPManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Indirizzo IP ESP32")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("Es. 192.168.4.1", text: $espManager.espIP)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        Button(action: {
                            espManager.pingESP()
                        }) {
                            Text("Connetti")
                                .bold()
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                HStack {
                    Circle()
                        .fill(espManager.isConnected ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text(espManager.statusMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                Text("Pannello di Controllo")
                    .font(.headline)
                
                VStack(spacing: 15) {
                    Button(action: { espManager.sendCommand("scan_wifi") }) {
                        Label("Scansione Wi-Fi", systemImage: "wifi")
                            .modifier(ActionButtonStyle(backgroundColor: .orange))
                    }
                    
                    Button(action: { espManager.sendCommand("scan_ble") }) {
                        Label("Scansione BLE", systemImage: "wave.3.right")
                            .modifier(ActionButtonStyle(backgroundColor: .purple))
                    }
                    
                    Button(action: { espManager.sendCommand("stop_all") }) {
                        Label("Ferma Tutto", systemImage: "hand.raised.fill")
                            .modifier(ActionButtonStyle(backgroundColor: .red))
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Ghost ESP32")
        }
    }
}

struct ActionButtonStyle: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .font(.body.weight(.semibold))
            .cornerRadius(10)
    }
}
