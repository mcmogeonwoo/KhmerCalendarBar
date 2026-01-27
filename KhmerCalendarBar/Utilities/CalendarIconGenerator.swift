import AppKit
import CoreGraphics

enum CalendarIconGenerator {

    // Cambodia flag colors
    private static let flagBlue = NSColor(red: 3.0/255, green: 46.0/255, blue: 161.0/255, alpha: 1)
    private static let flagRed = NSColor(red: 224.0/255, green: 0, blue: 37.0/255, alpha: 1)

    // MARK: - Generate Full Icon (512x512)

    static func generate(day: Int, month: String, khmerMonth: String, size: CGFloat = 512) -> NSImage {
        let image = NSImage(size: NSSize(width: size, height: size), flipped: true) { _ in
            guard let ctx = NSGraphicsContext.current?.cgContext else { return false }

            let scale = size / 512.0

            // Layout constants (designed for 512)
            let pad: CGFloat = 20 * scale
            let ringHeight: CGFloat = 36 * scale
            let bodyX = pad
            let bodyY = pad + ringHeight
            let bodyW = size - pad * 2
            let bodyH = size - pad - bodyY
            let corner: CGFloat = 44 * scale

            let bodyRect = CGRect(x: bodyX, y: bodyY, width: bodyW, height: bodyH)
            let bodyPath = CGPath(roundedRect: bodyRect, cornerWidth: corner, cornerHeight: corner, transform: nil)

            // --- Drop shadow (light blue tint behind icon) ---
            ctx.saveGState()
            ctx.setShadow(offset: CGSize(width: 0, height: 6 * scale), blur: 20 * scale,
                          color: CGColor(gray: 0, alpha: 0.15))
            ctx.setFillColor(CGColor(gray: 1, alpha: 1))
            ctx.addPath(bodyPath)
            ctx.fillPath()
            ctx.restoreGState()

            // --- White body fill ---
            ctx.addPath(bodyPath)
            ctx.setFillColor(CGColor(gray: 1, alpha: 1))
            ctx.fillPath()

            // --- Flag stripes (clipped to body) ---
            ctx.saveGState()
            ctx.addPath(bodyPath)
            ctx.clip()

            let blueH: CGFloat = 115 * scale
            let redH: CGFloat = 88 * scale
            let sepH: CGFloat = 14 * scale

            // Top blue
            ctx.setFillColor(flagBlue.cgColor)
            ctx.fill(CGRect(x: bodyX, y: bodyY, width: bodyW, height: blueH))

            // Red
            let redY = bodyY + blueH
            ctx.setFillColor(flagRed.cgColor)
            ctx.fill(CGRect(x: bodyX, y: redY, width: bodyW, height: redH))

            // Bottom blue separator
            let sepY = redY + redH
            ctx.setFillColor(flagBlue.cgColor)
            ctx.fill(CGRect(x: bodyX, y: sepY, width: bodyW, height: sepH))

            ctx.restoreGState()

            // --- Angkor Wat silhouette (on red stripe) ---
            let watCenterX = size / 2
            drawAngkorWat(in: ctx, centerX: watCenterX, baseY: redY + redH - 6 * scale, scale: scale)

            // --- Binder rings ---
            let ringX1 = bodyX + bodyW * 0.3
            let ringX2 = bodyX + bodyW * 0.7
            drawBinderRing(in: ctx, x: ringX1, topOfBody: bodyY, scale: scale)
            drawBinderRing(in: ctx, x: ringX2, topOfBody: bodyY, scale: scale)

            // --- Text content area ---
            let textAreaTop = sepY + sepH
            let textAreaBottom = bodyY + bodyH
            let textCenterX = size / 2

            // Month name (English)
            let monthStr = month as NSString
            let monthFont = NSFont.systemFont(ofSize: 28 * scale, weight: .medium)
            let monthColor = NSColor(red: 100.0/255, green: 116.0/255, blue: 139.0/255, alpha: 1)
            let monthAttrs: [NSAttributedString.Key: Any] = [
                .font: monthFont,
                .foregroundColor: monthColor
            ]
            let monthSize = monthStr.size(withAttributes: monthAttrs)
            let monthY = textAreaTop + 16 * scale
            monthStr.draw(at: NSPoint(x: textCenterX - monthSize.width / 2, y: monthY),
                          withAttributes: monthAttrs)

            // Khmer month name
            let khmerStr = khmerMonth as NSString
            let khmerFont = NSFont.systemFont(ofSize: 22 * scale, weight: .regular)
            let khmerColor = NSColor(red: 148.0/255, green: 163.0/255, blue: 184.0/255, alpha: 1)
            let khmerAttrs: [NSAttributedString.Key: Any] = [
                .font: khmerFont,
                .foregroundColor: khmerColor
            ]
            let khmerSize = khmerStr.size(withAttributes: khmerAttrs)
            let khmerY = monthY + monthSize.height + 2 * scale
            khmerStr.draw(at: NSPoint(x: textCenterX - khmerSize.width / 2, y: khmerY),
                          withAttributes: khmerAttrs)

            // Large date number
            let dayStr = "\(day)" as NSString
            let dayFont = NSFont.systemFont(ofSize: 140 * scale, weight: .bold)
            let dayColor = NSColor(red: 30.0/255, green: 41.0/255, blue: 59.0/255, alpha: 1)
            let dayAttrs: [NSAttributedString.Key: Any] = [
                .font: dayFont,
                .foregroundColor: dayColor
            ]
            let daySize = dayStr.size(withAttributes: dayAttrs)
            let dayAreaTop = khmerY + khmerSize.height
            let dayY = dayAreaTop + (textAreaBottom - 10 * scale - dayAreaTop - daySize.height) / 2
            dayStr.draw(at: NSPoint(x: textCenterX - daySize.width / 2, y: dayY),
                        withAttributes: dayAttrs)

            return true
        }
        return image
    }

    // MARK: - Angkor Wat Silhouette

    private static func drawAngkorWat(in ctx: CGContext, centerX: CGFloat, baseY: CGFloat, scale: CGFloat) {
        ctx.setFillColor(CGColor(gray: 1, alpha: 1))

        let towerW: CGFloat = 18 * scale
        let centerH: CGFloat = 52 * scale
        let sideH: CGFloat = 38 * scale
        let gap: CGFloat = 6 * scale

        // Central tower (tallest)
        drawTower(in: ctx, cx: centerX, baseY: baseY, width: towerW, height: centerH, scale: scale)

        // Left tower
        drawTower(in: ctx, cx: centerX - towerW - gap, baseY: baseY, width: towerW * 0.85, height: sideH, scale: scale)

        // Right tower
        drawTower(in: ctx, cx: centerX + towerW + gap, baseY: baseY, width: towerW * 0.85, height: sideH, scale: scale)

        // Base platform
        let baseW: CGFloat = 120 * scale
        let baseH: CGFloat = 6 * scale
        ctx.fill(CGRect(x: centerX - baseW / 2, y: baseY - baseH, width: baseW, height: baseH))

        // Wider foundation
        let foundW: CGFloat = 140 * scale
        let foundH: CGFloat = 4 * scale
        ctx.fill(CGRect(x: centerX - foundW / 2, y: baseY - baseH - foundH + 1 * scale,
                         width: foundW, height: foundH))
    }

    private static func drawTower(in ctx: CGContext, cx: CGFloat, baseY: CGFloat,
                                   width: CGFloat, height: CGFloat, scale: CGFloat) {
        let path = CGMutablePath()
        let halfW = width / 2
        let tipY = baseY - height

        // Pointed lotus-bud shape
        path.move(to: CGPoint(x: cx, y: tipY))
        path.addCurve(to: CGPoint(x: cx - halfW, y: baseY),
                      control1: CGPoint(x: cx - halfW * 0.3, y: tipY + height * 0.3),
                      control2: CGPoint(x: cx - halfW, y: tipY + height * 0.6))
        path.addLine(to: CGPoint(x: cx + halfW, y: baseY))
        path.addCurve(to: CGPoint(x: cx, y: tipY),
                      control1: CGPoint(x: cx + halfW, y: tipY + height * 0.6),
                      control2: CGPoint(x: cx + halfW * 0.3, y: tipY + height * 0.3))
        path.closeSubpath()

        ctx.addPath(path)
        ctx.fillPath()
    }

    // MARK: - Binder Ring

    private static func drawBinderRing(in ctx: CGContext, x: CGFloat, topOfBody: CGFloat, scale: CGFloat) {
        let ringR: CGFloat = 10 * scale
        let stemW: CGFloat = 6 * scale
        let stemTop = topOfBody - 20 * scale
        let stemBottom = topOfBody + 8 * scale

        // Stem (goes through the top edge)
        let stemColor = NSColor(red: 160.0/255, green: 170.0/255, blue: 185.0/255, alpha: 1)
        ctx.setFillColor(stemColor.cgColor)
        ctx.fill(CGRect(x: x - stemW / 2, y: stemTop, width: stemW, height: stemBottom - stemTop))

        // Ring circle
        let ringCY = topOfBody - 4 * scale
        let ringRect = CGRect(x: x - ringR, y: ringCY - ringR, width: ringR * 2, height: ringR * 2)

        let ringFill = NSColor(red: 200.0/255, green: 206.0/255, blue: 216.0/255, alpha: 1)
        ctx.setFillColor(ringFill.cgColor)
        ctx.fillEllipse(in: ringRect)

        let ringStroke = NSColor(red: 160.0/255, green: 170.0/255, blue: 185.0/255, alpha: 1)
        ctx.setStrokeColor(ringStroke.cgColor)
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

        guard let pngData = rep.representation(using: .png, properties: [:]) else {
            return false
        }
        do {
            try pngData.write(to: url)
            return true
        } catch {
            print("[CalendarIcon] Save failed: \(error)")
            return false
        }
    }
}
