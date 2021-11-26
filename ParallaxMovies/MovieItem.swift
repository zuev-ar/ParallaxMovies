//
//  MovieItem.swift
//  ParallaxMovies
//
//  Created by Arkasha Zuev on 26.11.2021.
//

import SwiftUI

struct MovieItem: View {
    
    let movie: Movie
    let screenSize: CGSize
    let width: CGFloat
    
    var body: some View {
        GeometryReader { reader in
            
            let midX = reader.frame(in: .global).midX
            let distance = abs(screenSize.width / 2 - midX)
            let damping: CGFloat = 4.5
            let precentage = abs(distance / (screenSize.width / 2) / damping - 1)
            
            VStack {
                Image(movie.imgString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .shadow(color: .black.opacity(0.6), radius: 14, y: 10)
                
                Text(movie.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                HStack(spacing: 5) {
                    ForEach(1 ..< 6) { i in
                        Image(systemName: i <= movie.rating ? "star.fill" : "star")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .scaleEffect(precentage)
        }
        .frame(width: width)
        .frame(maxHeight: .infinity)
    }
}

struct MovieItem_Previews: PreviewProvider {
    static var previews: some View {
        MovieItem(movie: Movie.sampleMovies[0], screenSize: CGSize.zero, width: CGFloat.infinity)
    }
}
