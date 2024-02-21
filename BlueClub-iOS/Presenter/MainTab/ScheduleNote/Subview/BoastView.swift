//
//  BoastView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/13/24.
//

import SwiftUI
import DesignSystem
import Domain
import Navigator
import DependencyContainer
import Utility
import Photos

struct BoastView: View {
    
    weak var navigator: Navigator?
    private let dependencies: Container
    private var diaryApi: DiaryNetworkable { dependencies.resolve() }
    
    private let diaryId: Int
    @State var isLoading = true
    @State var boast: BoastDTO?
    @State var cardImage: UIImage?
    
    init(
        navigator: Navigator?,
        dependencies: Container = .live,
        diaryId: Int
    ) {
        self.navigator = navigator
        self.dependencies = dependencies
        self.diaryId = diaryId
    }
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, { 
                    navigator?.dismiss()
                    navigator?.popToRoot()
                }),
                title: .none,
                trailingButton: ("닫기", { 
                    navigator?.dismiss()
                    navigator?.popToRoot()
                }))
        } content: {
            VStack(spacing: 0) {
                contentHeader()
                    .padding(.bottom, 16)
                if let boast {
                    BoastCard(boast: boast)
                        .getSize {
                            self.cardImage = BoastCard(boast: boast).snapshot(size: $0)
                        }
                        .padding(.horizontal, 20)
                }
            }
        } footer: {
            HStack(spacing: 8) {
                Button {
                    self.saveImageIfHasAuthorize()
                } label: {
                    Text("저장하기")
                        .fontModifer(.sb1)
                        .foregroundStyle(Color.colors(.primaryNormal))
                        .padding(.vertical, 17)
                        .frame(maxWidth: .infinity)
                        .roundedBackground(.colors(.primaryBackground))
                }

                ShareLink(
                    item: Image(uiImage: self.cardImage ?? .goldCoin ),
                    preview: SharePreview("BLUECLUB 자랑하기", image: Image(uiImage: self.cardImage ?? .goldCoin))
                ) {
                    Text("공유하기")
                        .fontModifer(.sb1)
                        .foregroundStyle(Color.colors(.white))
                        .padding(.vertical, 17)
                        .frame(maxWidth: .infinity)
                        .roundedBackground(.colors(.primaryNormal))
                }
            }.padding(20)
        }
        .task {
            do {
                self.boast = try await diaryApi.boast(diaryId: self.diaryId)
                self.isLoading = false
            } catch {
                self.isLoading = false
                printError(error)
            }
        }
        .loadingSpinner(isLoading)
    }
    
    @ViewBuilder func contentHeader() -> some View {
        Text("수입인증 카드로\n근무 성과를 자랑해봐요")
            .multilineTextAlignment(.leading)
            .fontModifer(.h6)
            .foregroundStyle(Color.colors(.gray10))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.top, 8)
    }

    func saveImageIfHasAuthorize() {
        guard !isLoading else { return }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            if status == .authorized {
                saveImage()
            } else {
                requestAuth()
            }
        }
    }
    
    func saveImage() {
        guard let cardImage else { return }
        Task { @MainActor in
            UIImageWriteToSavedPhotosAlbum(cardImage, nil, nil, nil)
            let parameter = AlertParameter(
                message: "이미지가 저장되었습니다.",
                buttons: [.init(title: "확인")])
            navigator?.alert(parameter)
        }
    }
    
    func requestAuth() {
        Task { @MainActor in
            printLog(message: "Photo library access denied")
            let parameter = AlertParameter(
                message: "설정에서 사진 접근 권한을 허용해주세요.",
                buttons: [.init(title: "허용하기", action: {
                    openAppSetting()
                })]
            )
            navigator?.alert(parameter)
        }
    }
}

#Preview {
    BoastView(navigator: nil, diaryId: 1)
}
