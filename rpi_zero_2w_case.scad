// Raspberry Pi Zero 2 W - Premium Kapaklı Kutu
// OpenSCAD tasarımı
// Geliştirilmiş sürüm: gerçek Pi Zero 2 W ölçüleri ve daha iyi baskı/uyum dengesi

$fn = 72;

// ---------------------------
// Resmi Raspberry Pi Zero 2 W boyutları
// ---------------------------
board_w = 65;      // mm
board_d = 30;      // mm
board_t = 1.6;     // mm

// Montaj deliği bilgisi (resmi ölçü)
mount_hole_spacing = 58;      // mm
mount_hole_diameter = 2.75;   // mm
mount_hole_margin = 2.5;      // mm

// Kutu sabitleri
wall = 2.2;        // duvar kalınlığı
clearance = 0.45;  // kart ile gövde arasındaki tolerans
corner_r = 4;

outer_w = board_w + 2 * wall + 2 * clearance + 4;
outer_d = board_d + 2 * wall + 2 * clearance + 4;
base_h = 18;
lid_h = 8;

module rounded_box(size = [10, 10, 10], r = 2) {
    hull() {
        for (x = [r, size[0]-r])
            for (y = [r, size[1]-r])
                for (z = [r, size[2]-r])
                    translate([x, y, z])
                        sphere(r = r);
    }
}

module mounting_post() {
    cylinder(h = 6, r = 2.3);
}

module board_supports() {
    // İç desteği kart için
    translate([wall + clearance + 2, wall + clearance + 2, 0])
        for (x = [0, board_w - 10])
            for (y = [0, board_d - 10])
                translate([x, y, 0])
                    cylinder(h = 3.5, r = 2.1);
}

module mount_holes_layout() {
    // Gerçek Pi Zero 2 W eksen planı:
    // 2 adet montaj deliği, merkezler arası 58 mm
    // x pozisyonları 2.5 ve 60.5 mm, y = 2.5 mm
    x_positions = [2.5, 60.5];
    y_pos = 2.5;
    for (x = x_positions)
        translate([x + wall + clearance + 1.2, y_pos + wall + clearance + 1.2, 0])
            cylinder(h = 12, r = mount_hole_diameter/2, center = true);
}

module front_ports() {
    // Ön yüz paneli: micro USB + HDMI + USB + SD kart

    // Power / microUSB
    translate([outer_w * 0.17, -0.5, base_h * 0.56])
        rotate([90, 0, 0])
            cube([10.5, 7.0, 2.4], center = true);

    // USB 2.0
    translate([outer_w * 0.44, -0.5, base_h * 0.55])
        rotate([90, 0, 0])
            cube([12.5, 8.0, 2.4], center = true);

    // HDMI 1
    translate([outer_w * 0.72, -0.5, base_h * 0.38])
        rotate([90, 0, 0])
            cube([12.5, 7.5, 2.4], center = true);

    // HDMI 2
    translate([outer_w * 0.72, -0.5, base_h * 0.68])
        rotate([90, 0, 0])
            cube([12.5, 7.5, 2.4], center = true);

    // microSD kart yuvası (ön yüz / alt taraf)
    translate([outer_w * 0.35, -0.5, base_h * 0.22])
        rotate([90, 0, 0])
            cube([18.0, 4.2, 2.4], center = true);

    // Ek kablo/izleme için küçük yedek boşluk
    translate([outer_w * 0.10, -0.5, base_h * 0.80])
        rotate([90, 0, 0])
            cube([14.0, 8.0, 2.5], center = true);
}

module side_gpio_window() {
    // GPIO erişimi için yan pencere
    translate([-0.5, outer_d * 0.48, base_h * 0.52])
        rotate([0, 90, 0])
            cube([18.0, 12.0, 2.2], center = true);
}

module ventilation_pattern() {
    // Kapak üstünde havalandırma deliği düzeni
    spacing = 9;
    for (x = [10 : spacing : outer_w - 10])
        for (y = [10 : spacing : outer_d - 10])
            translate([x, y, lid_h / 2])
                rotate([90, 0, 0])
                    cylinder(h = 2.2, r = 1.0, center = true);
}

module bottom_case() {
    difference() {
        rounded_box([outer_w, outer_d, base_h], r = corner_r);

        // İç boşluk
        translate([wall + clearance + 1.2, wall + clearance + 1.2, wall + 1.2])
            rounded_box([
                outer_w - 2 * (wall + clearance + 1.2),
                outer_d - 2 * (wall + clearance + 1.2),
                base_h
            ], r = max(corner_r - 1, 1));

        front_ports();
        side_gpio_window();
    }

    // Gerçek montaj deliği pozisyonları
    for (x = [2.5, 60.5])
        translate([x + wall + clearance + 1.2, 2.5 + wall + clearance + 1.2, 0])
            mounting_post();

    // İç kart destekleri
    board_supports();
}

module lid() {
    difference() {
        rounded_box([outer_w, outer_d, lid_h], r = corner_r);

        // İç çukur
        translate([wall + 0.8, wall + 0.8, 1.8])
            rounded_box([
                outer_w - 2 * (wall + 0.8),
                outer_d - 2 * (wall + 0.8),
                lid_h
            ], r = max(corner_r - 1, 1));

        ventilation_pattern();
    }

    // Kapanma için alt lip
    translate([wall + 0.35, wall + 0.35, 0])
        difference() {
            rounded_box([
                outer_w - 2 * (wall + 0.35),
                outer_d - 2 * (wall + 0.35),
                3.5
            ], r = max(corner_r - 1, 1));

            translate([2.2, 2.2, -0.5])
                rounded_box([
                    outer_w - 2 * (wall + 0.35) - 4.4,
                    outer_d - 2 * (wall + 0.35) - 4.4,
                    5
                ], r = max(corner_r - 2, 1));
        }
}

module assembled_case() {
    translate([0, 0, 0])
        bottom_case();

    translate([0, 0, base_h + 2])
        lid();
}

assembled_case();

// Ayrı parça dışa aktarma:
// bottom_case();
// translate([outer_w + 12, 0, 0]) lid();

