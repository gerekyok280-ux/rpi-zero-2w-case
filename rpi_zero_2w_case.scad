// Raspberry Pi Zero 2 W - Kapaklı Kutu
// STL/3D baskı için OpenSCAD tasarımı
// Hazırlayan: GitHub Copilot

$fn = 48;

// Temel ölçüler (mm)
board_w = 65;
board_d = 30;
board_t = 1.6;

wall = 2.2;
clearance = 0.5;
corner_r = 3;

case_w = board_w + 2 * wall + 2 * clearance + 4;
case_d = board_d + 2 * wall + 2 * clearance + 4;
case_h = 26;
lid_h = 7;
base_h = case_h - lid_h;

module rounded_box(size = [10, 10, 10], r = 2) {
    hull() {
        for (x = [r, size[0]-r])
            for (y = [r, size[1]-r])
                translate([x, y, 0])
                    cylinder(h = size[2], r = r);
    }
}

module standoff() {
    cylinder(h = 6, r = 2.3);
}

module board_mount_holes() {
    // Pi Zero 2 W montaj deliği pozisyonları
    positions = [
        [3.5, 3.5],
        [3.5, case_d - 3.5],
        [case_w - 3.5, 3.5],
        [case_w - 3.5, case_d - 3.5]
    ];

    for (p = positions)
        translate([p[0], p[1], 0])
            cylinder(h = 12, r = 1.65, center = true);
}

module ventilation_pattern() {
    // Kapak ve yan yüzeylerde havalandırma için ince delikler
    for (x = [6 : 8 : case_w - 6])
        for (y = [3 : 8 : case_d - 3])
            translate([x, y, 0])
                rotate([90, 0, 0])
                    cylinder(h = 1.5, r = 0.9, center = true);
}

module port_cutouts() {
    // Ana bağlantı noktaları (üst yüzeye göre kenar üzerinden)
    // Y ekseni dışarı doğru açık olan yüzey: y = 0
    // Micro USB / USB / HDMI / SD Kart

    // Micro USB / Power
    translate([case_w * 0.22, -1, case_h * 0.48])
        rotate([90, 0, 0])
            cube([10, 6, 2.5], center = true);

    // USB 2.0
    translate([case_w * 0.49, -1, case_h * 0.50])
        rotate([90, 0, 0])
            cube([12, 6, 2.5], center = true);

    // HDMI (2 x)
    translate([case_w * 0.70, -1, case_h * 0.42])
        rotate([90, 0, 0])
            cube([11, 6, 2.5], center = true);

    translate([case_w * 0.70, -1, case_h * 0.62])
        rotate([90, 0, 0])
            cube([11, 6, 2.5], center = true);

    // microSD kart yuvası
    translate([case_w * 0.38, -1, case_h * 0.22])
        rotate([90, 0, 0])
            cube([18, 4, 2.2], center = true);

    // GPIO erişimi için yan pencere
    translate([-1, case_d * 0.42, case_h * 0.55])
        rotate([0, 90, 0])
            cube([18, 14, 2.5], center = true);
}

module bottom_case() {
    difference() {
        rounded_box([case_w, case_d, case_h], r = corner_r);

        // İç boşluk
        translate([wall + clearance, wall + clearance, wall + 1.2])
            rounded_box([case_w - 2 * (wall + clearance), case_d - 2 * (wall + clearance), case_h], r = max(corner_r - 1, 1));

        // Aşağıdaki yüzeye port açılışları
        port_cutouts();

        // Güç ve kablo düzeni için küçük açıklık
        translate([case_w * 0.12, -1, case_h * 0.72])
            rotate([90, 0, 0])
                cube([14, 8, 2.5], center = true);
    }

    // Montaj desteği
    for (x = [6, case_w - 6])
        for (y = [6, case_d - 6])
            translate([x, y, 0])
                standoff();

    // Alt kenar koruyucu lip
    translate([wall, wall, 0])
        difference() {
            cube([case_w - 2*wall, case_d - 2*wall, 2]);
            translate([1.5, 1.5, -1])
                cube([case_w - 2*wall - 3, case_d - 2*wall - 3, 4]);
        }
}

module top_lid() {
    difference() {
        rounded_box([case_w, case_d, lid_h], r = corner_r);

        // İç boşluk: kapağın merkezinde hafif çukur
        translate([wall + 1.5, wall + 1.5, 2])
            rounded_box([case_w - 2 * (wall + 1.5), case_d - 2 * (wall + 1.5), lid_h], r = max(corner_r - 1, 1));

        // Kapak üst yüzey ventilasyonu
        translate([case_w / 2, case_d / 2, lid_h * 0.5])
            ventilation_pattern();
    }

    // Kapağı tutan yan lip
    translate([wall + 0.4, wall + 0.4, 0])
        difference() {
            cube([case_w - 2*(wall + 0.4), case_d - 2*(wall + 0.4), 3]);
            translate([1.8, 1.8, -1])
                cube([case_w - 2*(wall + 0.4) - 3.6, case_d - 2*(wall + 0.4) - 3.6, 5]);
        }
}

module assembled_case() {
    translate([0, 0, 0])
        bottom_case();

    translate([0, 0, case_h + 2])
        top_lid();
}

assembled_case();

// Aşağıdaki satırları yorumdan çıkarıp STL olarak dışa aktarma için kullanabilirsiniz:
// export("rpi_zero_2w_case.stl");

// Not: Kapak ve taban ayrı ayrı export edilerek baskıya hazır hale getirilebilir.
// Örnek:
// rotate([180,0,0]) bottom_case();
// top_lid();




