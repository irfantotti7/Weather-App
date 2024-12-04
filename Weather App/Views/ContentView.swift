import SwiftUI
/*
struct ContentView: View {
    @StateObject private var weatherVM = WeatherViewModel()
    @State private var cityName: String = ""

    var body: some View {
        ZStack {
            

            VStack {
                TextField("Enter city name", text: $cityName)
                    .padding(.horizontal, 24) //
                    .padding() // Adds padding to all sides (top, bottom, left, and right)
                    .foregroundColor(.gray)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)

                    

                Button(action: {
                    weatherVM.fetchWeather(for: cityName)
                }) {
                    Text("Get Weather")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let error = weatherVM.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                Text(weatherVM.weatherDescription)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Text(weatherVM.temperature)
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
           
        }
    }
}

*/


struct ContentView: View {
    @State private var cityName: String = ""
    @StateObject private var weatherVM = WeatherViewModel()
    var body: some View {
        VStack {
            TextField("Enter city name", text: $cityName)
                .padding(.horizontal, 24)
                .padding()
                .foregroundColor(.black)
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                .shadow(radius: 5)
                .font(.system(size: 18, weight: .medium, design: .default)) 
                .frame(maxWidth: 350)
                .padding(.top, 50)
            
            Button(action: {
                
                weatherVM.fetchWeather(for: cityName)
            }) {
                Text("Search")
                    .font(.system(size: 18, weight: .semibold, design: .rounded)) // Button font style
                    .padding(.vertical, 12)
                    .frame(maxWidth: 350)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.top, 20)
            
            Spacer() // Pushes the elements to the top and adds space at the bottom
        }
        .background(Color(UIColor.systemGray6)) // Light gray background
        .edgesIgnoringSafeArea(.all) // Extend the background to all edges
    }
}

