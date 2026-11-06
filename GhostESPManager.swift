import Foundation
import Combine

class GhostESPManager: ObservableObject {
    @Published var espIP: String = "192.168.4.1"
    @Published var statusMessage: String = "Disconnesso"
    @Published var isConnected: Bool = false
    
    func sendCommand(_ command: String) {
        guard let url = URL(string: "http://\(espIP)/api/command?cmd=\(command)") else {
            self.statusMessage = "URL non valido"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.statusMessage = "Errore: \(error.localizedDescription)"
                    self.isConnected = false
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.statusMessage = "Comando '\(command)' inviato!"
                    self.isConnected = true
                } else {
                    self.statusMessage = "Errore risposta server"
                }
            }
        }.resume()
    }
    
    func pingESP() {
        sendCommand("ping")
    }
}
