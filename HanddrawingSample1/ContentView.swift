//
//  ContentView.swift
//  HanddrawingSample1
//
//  Created by 牧内 on 2023/09/17.
//

import SwiftUI

struct DrawLine: Identifiable {
    static var idCount: Int = 0
    var id: String
    var points: [CGPoint]
    
    static func makeDrawLine(points: [CGPoint]) -> DrawLine {
        let line = DrawLine(id: "\(DrawLine.idCount)", points: points)
        DrawLine.idCount += 1
        return line
    }
}

struct ContentView: View {
    // すでに描いたLine
    @State private var lines: [DrawLine] = []
    // いまドラッグ中のLine
    @State private var currentLine: DrawLine?
    
    var body: some View {
        VStack {
            // リセットボタン
            Button(action: {
                lines = []
            }, label: {
                Text("Clear")
            })
            ZStack {
                // Canvas部分
                Rectangle()
                    .fill(Color.white)
                    .border(Color.black, width: 1)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                if currentLine == nil {
                                    currentLine = DrawLine.makeDrawLine(points: [])
                                }
                                guard var line = currentLine else { return }
                                line.points.append(value.location)
                                currentLine = line
                            })
                            .onEnded({ value in
                                guard var line = currentLine else { return }
                                line.points.append(value.location)
                                lines.append(line)
                                // リセット
                                currentLine = nil
                            })
                    )
                
                // 追加ずみのLineの描画
                ForEach(lines) { line in
                    Path { path in
                        path.addLines(line.points)
                    }.stroke(Color.red, lineWidth: 1)
                }.clipped()
                
                // ドラッグ中のLineの描画
                Path { path in
                    guard let line = currentLine else { return }
                    path.addLines(line.points)
                }.stroke(Color.red, lineWidth: 1)
                .clipped()
                
            }
            .padding(20)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
