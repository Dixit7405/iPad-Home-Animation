//
//  ContentView.swift
//  Ipad Demo
//
//  Created by Dixit Rathod on 23/07/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedPage: Int = 0
    @Namespace var namespace
    @State private var offset: CGFloat = -1
    @State private var showIconView: Bool = false
    @State private var showIconView2: Bool = false
    let iconsSize: CGFloat = 90
    
    let colors = [0, 1]
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("ipad_ss")
                    .resizable()
                    .blur(radius: (1 - (offset/geo.size.width)) * 10)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                tabView
                
                HStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { index in
                        appIcon
                    }
                    
                    Color.black
                        .frame(width: 0.5)
                    
                    appIcon
                    
                        ZStack {
                            if !showIconView {
                                appIcon
                                    .offset(x: -7)
                                    .scaleEffect(x: 0.95, y: 0.95)
                                    .matchedGeometryEffect(id: "rect1", in: namespace, properties: .frame, isSource: true)
                            }
                            
                            if !showIconView2 {
                                appIcon
                                    .matchedGeometryEffect(id: "rect2", in: namespace, properties: .frame, isSource: true)
                            }
                    }
                    
                }
                .padding(15)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Material.ultraThin.opacity(0.6))
                        
                }
                .frame(height: 90)
                .offset(y: showIconView2 ? 250 : 0)
            }
            
        }
    }
    
    var appIcon: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Material.thin)
            .aspectRatio(1.0, contentMode: .fit)
    }
    
    private var tabView: some View {
        GeometryReader { bounds in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    TabView(selection: $selectedPage) {
                        ForEach(colors, id: \.self) { color in
                            pageView(bounds: bounds)
                            
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(width: bounds.size.width)
                    
                    ZStack {
                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Material.ultraThin)
                                .frame(width: 400, height: 70)
                                .overlay {
                                    HStack(spacing: 10) {
                                        Image(systemName: "magnifyingglass")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(.white)
                                        
                                        Text("App Library")
                                            .font(.system(size: 24, weight: .medium, design: .default))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .opacity(showIconView2 ? 1 : 0)
                            
                            
                            HStack(spacing: 30) {
                                if showIconView {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Material.ultraThin)
                                        .frame(width: 200, height: 200)
                                        .matchedGeometryEffect(id: "rect1", in: namespace, isSource: true)
                                }
                                
                                if showIconView2 {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Material.ultraThin)
                                        .frame(width: 200, height: 200)
                                        .matchedGeometryEffect(id: "rect2", in: namespace)
                                }
                            }
                            .frame(maxWidth: bounds.size.width * 0.7, alignment: .leading)
                            .padding(.top, 30)
                            
                            Spacer(minLength: 0)
                        }
                        .frame(maxHeight: bounds.size.height * 0.7)
                        
                    }
                    .frame(width: bounds.size.width)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self,
                                               value: $0.frame(in: .named("scroll")).origin.x)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { xOffset in
                        offset = xOffset
                        
                        withAnimation(.bouncy.delay(xOffset == 0 ? 0 : 0.05)) {
                            showIconView = xOffset == 0
                        }
                        
                        withAnimation(.bouncy.delay(xOffset == 0 ? 0.05 : 0)) {
                            showIconView2 = xOffset == 0
                        }
                        
                    }
                    
                }
                
            }
            .scrollTargetBehavior(.paging)
        }
    }
    
    func pageView(bounds: GeometryProxy) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 70), spacing: 80, alignment: .center)], spacing: 80) {
            ForEach(0..<6) { index in
                appIcon
            }
        }
        .frame(width: bounds.size.width * 0.75, height: bounds.size.height * 0.85, alignment: .top)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#Preview {
    ContentView()
}
