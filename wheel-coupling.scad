include <MCAD/units/metric.scad>
include <MCAD/fasteners/nuts_and_bolts.scad>

use <MCAD/shapes/polyhole.scad>
use <MCAD/fasteners/threads.scad>

// settings
collar_thickness = 10 * length_mm;
collar_wall_thickness = M6;
motor_shaft_dia = M8;
motor_shaft_depth = 18.35 * length_mm;
setscrew_size = M3;
setscrew_pos = collar_thickness / 2;
setscrew_clearance = 0.3 * length_mm;

shaft_od = 12.7 * length_mm;
shaft_length = 20 * length_mm;
flange_dia = 26 * length_mm;
flange_thickness = 5 * length_mm;
key_width = 17 * length_mm;
key_thickness = 3 * length_mm;
key_length = 12 * length_mm;


// main model
difference () {
    basic_coupling_shape ();
    motor_shaft ();
}

module basic_coupling_shape ()
{
    collar ();

    translate ([0, 0, collar_thickness - epsilon])
    keyed_shaft ();

    translate ([flange_dia + 5 * length_mm, 0, 0])
    flange ();
}

module collar ()
{
    OD = collar_wall_thickness * 2 + motor_shaft_dia;

    difference () {
        // basic collar shape
        cylinder (
            d = OD,
            h = collar_thickness
        );

        translate ([0, 0, setscrew_pos])
        rotate (90, Y)
        polyhole (
            d = setscrew_size + setscrew_clearance,
            h = OD
        );

        translate ([motor_shaft_dia/2 + 0.5 * length_mm, 0, setscrew_pos])
        mirror (X)
        rotate (-90, Y)
        hull () {
            nutHole (setscrew_size, tolerance=setscrew_clearance);
            translate ([-OD, 0, 0])
            nutHole (setscrew_size, tolerance=setscrew_clearance);
        }
    }
}

module keyed_shaft ()
{
    cylinder (
        d = shaft_od,
        h = shaft_length
    );

    rotate (90, Z)
    translate ([0, 0, key_length/2])
    cube ([key_width, key_thickness, key_length], center=true);

    translate ([0, 0, shaft_length])
    metric_thread (
        diameter = shaft_od,
        pitch = 2,
        length = flange_thickness + 1 * length_mm,
        internal = false
    );
}

module flange ()
{
    difference () {
        cylinder (
            d = flange_dia,
            h = flange_thickness,
            $fn = 6
        );

        translate ([0, 0, -epsilon])
        metric_thread (
            diameter = shaft_od,
            pitch = 2,
            length = flange_thickness + epsilon * 2,
            internal = true
        );
    }
}

module motor_shaft ()
{
    translate ([0, 0, -epsilon])
    polyhole (
        d = motor_shaft_dia,
        h = motor_shaft_depth
    );
}
