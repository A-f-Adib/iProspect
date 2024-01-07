//
//  MeView.swift
//  iProspects
//
//  Created by A.f. Adib on 1/6/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI




struct MeView: View {
    
    @StateObject var newProspects = newProspect()
    
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("name", text: $newProspects.name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("email", text: $newProspects.emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .trailing)
                    .padding(.leading, 50)
                    .contextMenu {
                        Button {
                            
                            let imageSaver = ImageSaver()
                            imageSaver.writePhotoAlbum(image: qrCode)
                            
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
                
            }
            .navigationTitle("Scan Code")
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in
                updateCode()
            }
            .onChange(of: emailAddress) { _ in
                updateCode()
            }
        }
    }
    
    
    
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name) \n \(emailAddress)")
    }
    
    
    func generateQRCode(from string : String) -> UIImage {
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
               
            }
                
        }
      return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
