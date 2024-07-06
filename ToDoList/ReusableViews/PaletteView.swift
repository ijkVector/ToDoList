//
//  CustomColorPickerView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

struct PaletteView: View {
    @Binding var currentColor: Color
    
    @State private var hue: Double = 0
    @State private var brightness: Double = 1.0
    @State private var paletteSize: CGSize = .zero
    
    var body: some View {
        VStack {
            pallet
            slider
            GeometryReader { geometry in
                HStack { }
                    .onAppear {
                        paletteSize = geometry.size
                    }
            }
        }
        .padding()
    }
    
    private var pallet: some View {
        Rectangle()
            .fill(LinearGradient(colors: [
                getColor(with: 0/8),
                getColor(with: 1/8),
                getColor(with: 2/8),
                getColor(with: 3/8),
                getColor(with: 4/8),
                getColor(with: 5/8),
                getColor(with: 6/8),
                getColor(with: 7/8),
                getColor(with: 8/8)
            ], startPoint: .leading, endPoint: .trailing))
            .frame(height: 150)
            .cornerRadius(8.0)
            .gesture (
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        hue = min(
                            1,
                            max(0, Double(value.location.x / paletteSize.width))
                        )
                        currentColor = getColor(with: hue)
                    }
            )
        }
    
    private var slider: some View {
        Slider(value: $brightness, in: 0...1)
            .onChange(of: brightness) {
                currentColor = getColor(brightness)
            }
    }
    
    private func getColor(with hue: Double) -> Color {
        Color(hue: hue, saturation: 1, brightness: brightness)
    }
    
    private func getColor(_ brightness: Double) -> Color {
        Color(hue: hue, saturation: 1, brightness: brightness)
    }
}

#Preview {
    PaletteView(currentColor: Binding(get: { .green }, set: { _ in }))
}
