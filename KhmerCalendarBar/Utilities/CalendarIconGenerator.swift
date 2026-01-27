import AppKit
import CoreGraphics

enum CalendarIconGenerator {

    private static let flagBlue = NSColor(red: 3.0/255, green: 46.0/255, blue: 161.0/255, alpha: 1)
    private static let flagRed = NSColor(red: 224.0/255, green: 0, blue: 37.0/255, alpha: 1)

    // MARK: - Generate Icon

    static func generate(day: Int, month: String, khmerMonth: String, size: CGFloat = 512) -> NSImage {
        let image = NSImage(size: NSSize(width: size, height: size), flipped: true) { _ in
            guard let ctx = NSGraphicsContext.current?.cgContext else { return false }

            let s = size / 512.0 // scale factor

            // Layout
            let pad: CGFloat = 20 * s
            let bodyX = pad
            let bodyY: CGFloat = 56 * s
            let bodyW = size - pad * 2
            let bodyH = size - pad - bodyY
            let corner: CGFloat = 44 * s

            let bodyRect = CGRect(x: bodyX, y: bodyY, width: bodyW, height: bodyH)
            let bodyPath = CGPath(roundedRect: bodyRect, cornerWidth: corner, cornerHeight: corner, transform: nil)

            // Drop shadow
            ctx.saveGState()
            ctx.setShadow(offset: CGSize(width: 0, height: 6 * s), blur: 20 * s,
                          color: CGColor(gray: 0, alpha: 0.12))
            ctx.setFillColor(CGColor(gray: 1, alpha: 1))
            ctx.addPath(bodyPath)
            ctx.fillPath()
            ctx.restoreGState()

            // White body
            ctx.addPath(bodyPath)
            ctx.setFillColor(CGColor(gray: 1, alpha: 1))
            ctx.fillPath()

            // Flag stripes (clipped)
            ctx.saveGState()
            ctx.addPath(bodyPath)
            ctx.clip()

            let blueH: CGFloat = 115 * s
            let redH: CGFloat = 88 * s
            let sepH: CGFloat = 14 * s

            ctx.setFillColor(flagBlue.cgColor)
            ctx.fill(CGRect(x: bodyX, y: bodyY, width: bodyW, height: blueH))

            let redY = bodyY + blueH
            ctx.setFillColor(flagRed.cgColor)
            ctx.fill(CGRect(x: bodyX, y: redY, width: bodyW, height: redH))

            let sepY = redY + redH
            ctx.setFillColor(flagBlue.cgColor)
            ctx.fill(CGRect(x: bodyX, y: sepY, width: bodyW, height: sepH))

            ctx.restoreGState()

            // Angkor Wat — large, spanning most of the red stripe
            let cx = size / 2
            let watBase = sepY - 2 * s
            drawAngkorWat(in: ctx, cx: cx, baseY: watBase, redTop: redY, scale: s)

            // Binder rings
            drawRing(in: ctx, x: bodyX + bodyW * 0.3, topOfBody: bodyY, scale: s)
            drawRing(in: ctx, x: bodyX + bodyW * 0.7, topOfBody: bodyY, scale: s)

            // Text area
            let textTop = sepY + sepH
            let textBottom = bodyY + bodyH
            let textCX = size / 2

            // Month (English)
            let mStr = month as NSString
            let mAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 28 * s, weight: .medium),
                .foregroundColor: NSColor(red: 100.0/255, green: 116.0/255, blue: 139.0/255, alpha: 1)
            ]
            let mSize = mStr.size(withAttributes: mAttrs)
            let mY = textTop + 14 * s
            mStr.draw(at: NSPoint(x: textCX - mSize.width / 2, y: mY), withAttributes: mAttrs)

            // Month (Khmer)
            let kStr = khmerMonth as NSString
            let kAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 22 * s, weight: .regular),
                .foregroundColor: NSColor(red: 148.0/255, green: 163.0/255, blue: 184.0/255, alpha: 1)
            ]
            let kSize = kStr.size(withAttributes: kAttrs)
            let kY = mY + mSize.height + 2 * s
            kStr.draw(at: NSPoint(x: textCX - kSize.width / 2, y: kY), withAttributes: kAttrs)

            // Date number
            let dStr = "\(day)" as NSString
            let dAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 140 * s, weight: .bold),
                .foregroundColor: NSColor(red: 30.0/255, green: 41.0/255, blue: 59.0/255, alpha: 1)
            ]
            let dSize = dStr.size(withAttributes: dAttrs)
            let dAreaTop = kY + kSize.height
            let dY = dAreaTop + (textBottom - 10 * s - dAreaTop - dSize.height) / 2
            dStr.draw(at: NSPoint(x: textCX - dSize.width / 2, y: dY), withAttributes: dAttrs)

            return true
        }
        return image
    }

    // MARK: - Angkor Wat

    private static func drawAngkorWat(in ctx: CGContext, cx: CGFloat, baseY: CGFloat,
                                       redTop: CGFloat, scale: CGFloat) {
        ctx.setFillColor(CGColor(gray: 1, alpha: 1))

        // Tower dimensions — large enough to fill most of the red stripe
        let centerH: CGFloat = 78 * scale
        let centerW: CGFloat = 32 * scale
        let sideH: CGFloat = 56 * scale
        let sideW: CGFloat = 26 * scale
        let spacing: CGFloat = 44 * scale  // center-to-center distance to side towers

        // Draw towers (center tallest, sides shorter)
        drawSpire(in: ctx, cx: cx, baseY: baseY, width: centerW, height: centerH, scale: scale)
        drawSpire(in: ctx, cx: cx - spacing, baseY: baseY, width: sideW, height: sideH, scale: scale)
        drawSpire(in: ctx, cx: cx + spacing, baseY: baseY, width: sideW, height: sideH, scale: scale)

        // Stepped base platform
        let baseW1: CGFloat = 170 * scale
        let baseH1: CGFloat = 7 * scale
        ctx.fill(CGRect(x: cx - baseW1 / 2, y: baseY, width: baseW1, height: baseH1))

        let baseW2: CGFloat = 195 * scale
        let baseH2: CGFloat = 5 * scale
        ctx.fill(CGRect(x: cx - baseW2 / 2, y: baseY + baseH1, width: baseW2, height: baseH2))
    }

    private static func drawSpire(in ctx: CGContext, cx: CGFloat, baseY: CGFloat,
                                   width: CGFloat, height: CGFloat, scale: CGFloat) {
        let hw = width / 2
        let tipY = baseY - height
        let path = CGMutablePath()

        // Lotus-bud / prasat spire shape
        path.move(to: CGPoint(x: cx, y: tipY))

        // Left side: narrow near tip, widens toward base
        path.addCurve(
            to: CGPoint(x: cx - hw, y: baseY),
            control1: CGPoint(x: cx - hw * 0.15, y: tipY + height * 0.25),
            control2: CGPoint(x: cx - hw * 0.95, y: tipY + height * 0.55)
        )

        // Bottom
        path.addLine(to: CGPoint(x: cx + hw, y: baseY))

        // Right side: mirror
        path.addCurve(
            to: CGPoint(x: cx, y: tipY),
            control1: CGPoint(x: cx + hw * 0.95, y: tipY + height * 0.55),
            control2: CGPoint(x: cx + hw * 0.15, y: tipY + height * 0.25)
        )

        path.closeSubpath()
        ctx.addPath(path)
        ctx.fillPath()
    }

    // MARK: - Binder Ring

    private static func drawRing(in ctx: CGContext, x: CGFloat, topOfBody: CGFloat, scale: CGFloat) {
        let ringR: CGFloat = 10 * scale
        let stemW: CGFloat = 6 * scale
        let stemTop = topOfBody - 20 * scale
        let stemBottom = topOfBody + 8 * scale

        let metalColor = NSColor(red: 160.0/255, green: 170.0/255, blue: 185.0/255, alpha: 1)

        // Stem
        ctx.setFillColor(metalColor.cgColor)
        ctx.fill(CGRect(x: x - stemW / 2, y: stemTop, width: stemW, height: stemBottom - stemTop))

        // Ring circle
        let ringCY = topOfBody - 4 * scale
        let ringRect = CGRect(x: x - ringR, y: ringCY - ringR, width: ringR * 2, height: ringR * 2)
        ctx.setFillColor(NSColor(red: 200.0/255, green: 206.0/255, blue: 216.0/255, alpha: 1).cgColor)
        ctx.fillEllipse(in: ringRect)
        ctx.setStrokeColor(metalColor.cgColor)
        ctx.setLineWidth(3 * scale)
        ctx.strokeEllipse(in: ringRect)
    }

    // MARK: - Save PNG

    static func savePNG(image: NSImage, to url: URL) -> Bool {
        let size = image.size
        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )!
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        image.draw(in: NSRect(origin: .zero, size: size))
        NSGraphicsContext.restoreGraphicsState()

        guard let pngData = rep.representation(using: .png, properties: [:]) else { return false }
        do {
            try pngData.write(to: url)
            return true
        } catch {
            print("[CalendarIcon] Save failed: \(error)")
            return false
        }
    }
}
