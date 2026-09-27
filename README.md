# Raspberry Pi Zero 2 W Kapaklı Kutu

Bu repository, Raspberry Pi Zero 2 W için kapaklı, tüm bağlantı delikleri ve havalandırma açıklıkları olan bir 3D baskı kutusu tasarımı içerir.

## İçerik
- `rpi_zero_2w_case.scad` — OpenSCAD ile tasarlanmış parametreli kutu.

## Boyutlar
- Pi kartı: 65 x 30 mm
- Kutu dış ölçüsü: yaklaşık 74 x 40 mm
- Kutu yüksekliği: 26 mm
- Kapak yüksekliği: 7 mm

## Açık delikler
- Micro USB / güç girişi
- USB 2.0
- 2x HDMI
- microSD kart yuvası
- GPIO erişimi için kenar penceresi
- Havalandırma delikleri

## STL çıkarma
1. OpenSCAD kurun.
2. `rpi_zero_2w_case.scad` dosyasını açın.
3. `File > Export > Export as STL` seçin.
4. İsterseniz `bottom_case();` ve `top_lid();` satırlarını ayrı ayrı render ederek iki parça olarak dışa aktarabilirsiniz.

## Baskı notları
- Kullanılan malzeme: PLA / PETG
- Katman yüksekliği: 0.2 mm
- Duvar kalınlığı: 2.2 mm
- Boşluk: 0.5 mm
- Kapağın düzgün kapanması için 0.2–0.4 mm arası ayarlama yapılabilir.

## Görünüm
- Şık, yuvarlatılmış köşeler
- Kısa ve kompakt profil
- 3D baskıda kolay montaj

## Özelleştirme
`wall`, `clearance`, `case_h`, `lid_h` değerlerini değiştirerek kutuyu istenilen boyuta göre uyarlayabilirsiniz.

