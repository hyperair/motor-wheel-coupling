include <MCAD/units/metric.scad>
include <MCAD/fasteners/nuts_and_bolts.scad>

use <MCAD/shapes/polyhole.scad>

collar_thickness = 10 * length_mm;
collar_wall_thickness = M5;
motor_shaft_dia = M8;
setscrew_size = M3;
setscrew_pos = collar_thickness / 2;

collar ();

translate ([0, 0, collar_thickness - epsilon])
tooth ();
shaft ();

module collar ()
{
    OD = collar_wall_thickness * 2 + motor_shaft_dia;

    difference () {
        // basic collar shape
        cylinder (
            d = OD,
            h = collar_thickness
        );

        // motor shaft
        translate ([0, 0, -epsilon])
        polyhole (
            d = motor_shaft_dia,
            h = collar_thickness + epsilon * 2
        );

        translate ([0, 0, setscrew_pos])
        rotate (90, Y)
        polyhole (
            d = setscrew_size,
            h = OD
        );

        translate ([motor_shaft_dia/2 + 0.5 * length_mm, 0, setscrew_pos])
        mirror (X)
        rotate (-90, Y)
        hull () {
            nutHole (setscrew_size, tolerance=0.3);
            translate ([-OD, 0, 0])
            nutHole (setscrew_size, tolerance=0.3);
        }
    }
}
