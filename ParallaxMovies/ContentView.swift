//
//  ContentView.swift
//  ParallaxMovies
//
//  Created by Arkasha Zuev on 26.11.2021.
//

import SwiftUI

struct Movie: Identifiable {
    var id: String { title }
    let title: String
    let rating: Int
    var imgString: String
    var bgString: String?
    
    static let sampleMovies = [
//        Movie(title: "Shang-Chi and the Legend of the Ten Rings", rating: 5, imgString: "Shang-Chi and the Legend of the Ten Rings"),
//        Movie(title: "Venom: Let There Be Carnage", rating: 3, imgString: "Venom Let There Be Carnage"),
//        Movie(title: "Red Notice", rating: 4, imgString: "Red Notice"),
        Movie(title: "A Boy Called Christmas", rating: 5, imgString: "A Boy Called Christmas"),
        Movie(title: "Infinite", rating: 5, imgString: "Infinite")
    ]
}

struct ContentView: View {
    
    @State private var offsetX: CGFloat = 0
    @State private var maxOffsetX: CGFloat = -1
    
    let movies = Movie.sampleMovies
    
    var body: some View {
        GeometryReader { reader in
            let screenSize = reader.size
            ZStack {
                backgroundCarousel(screenSize: screenSize)
                moviesCarousel(reader: reader)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func backgroundCarousel(screenSize: CGSize) -> some View {
        
        let bgWidth: CGFloat = screenSize.width * CGFloat(movies.count)
        let scrollPrecentage = offsetX / maxOffsetX
        let clampedPrecentage: CGFloat = 1 - max(0, min(scrollPrecentage, 1))
        let posX: CGFloat = (bgWidth - screenSize.width) * clampedPrecentage
        
        return HStack(spacing: 0) {
            ForEach(movies.reversed()) { movie in
                Image(movie.bgString ?? movie.imgString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenSize.width)
                    .frame(maxWidth: .infinity)
                    .blur(radius: 1)
                    .scaleEffect(1.004)
                    .clipped()
                    .overlay(Color.black.opacity(0.45))
                    .ignoresSafeArea()
            }
        }
        .frame(width: bgWidth)
        .position(x: bgWidth / 2 - posX, y: screenSize.height / 2)
    }
    
    func moviesCarousel(reader: GeometryProxy) -> some View {
        
        let screenSize = reader.size
        let itemWidth: CGFloat = screenSize.width * 0.8
        let paddingX: CGFloat = (screenSize.width - itemWidth) / 2
        let spacing: CGFloat = 10
        
        return ScrollView(.horizontal) {
            HStack(spacing: 0) {
                
                GeometryReader { geo -> Color in
                    DispatchQueue.main.async {
                        offsetX = (geo.frame(in: .global).minX - paddingX) * -1
                        let scrollContentWidth = itemWidth * CGFloat(movies.count) + spacing * CGFloat(movies.count - 1)
                        let maxOffsetX = scrollContentWidth + 2 * paddingX - screenSize.width
                        if self.maxOffsetX == -1 {
                            self.maxOffsetX = maxOffsetX
                        }
                        print(offsetX / maxOffsetX)
                    }
                    return Color.clear
                }
                .frame(width: 0)
                
                HStack(spacing: spacing) {
                    ForEach(movies) { movie in
                        MovieItem(movie: movie, screenSize: screenSize, width: itemWidth)
                    }
                }
                .padding(.horizontal, paddingX)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
