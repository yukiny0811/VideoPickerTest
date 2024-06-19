//
//  ContentView.swift
//  VideoPickerTest
//
//  Created by Yuki Kuwashima on 2024/06/19.
//

import SwiftUI
import PhotosUI

struct ContentView: View {

    @State private var selectedVideo: [PhotosPickerItem] = []
    @State private var videoURL: URL?

    var body: some View {
        PhotosPicker("写真を選択", selection: $selectedVideo, maxSelectionCount: 1, matching: .any(of: [.videos]), photoLibrary: .shared())
            .onChange(of: selectedVideo) {
                Task {
                    videoURL = await getVideoURL(videos: selectedVideo)
                    print(videoURL)
                }
            }
    }

    private func getVideoURL(videos: [PhotosPickerItem]) async -> URL? {
        guard let video = videos.first else {
            return nil
        }
        guard let data = try? await video.loadTransferable(type: Data.self) else {
            return nil
        }
        guard let tempDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
}

#Preview {
    ContentView()
}
