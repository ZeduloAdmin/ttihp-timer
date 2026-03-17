![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Zedulo Timer chip - SPI

This project demonstrates a fast ring oscillator timer implemented using a chain of inverters. The oscillator drives a counter whose value is read out by an embedded SPI device, providing a visible indication that the oscillator is running. The SPI device also aids in clearing the registers in the timer using an opcode.
The estimated frequency is not known yet, however the target frequency is about 350GHz.

### Features

- Ring oscillator built from an odd number of inverters

- Enable control for starting/stopping oscillation

- Counter driven directly by the oscillator


### Pinout
| Pin       | Name      | Dir | Description      |
|-----------|-----------|-----|------------------|
| ui[0]     | SPI_SCK   | In  | SPI clock        |
| ui[1]     | SPI_CS    | In  | SPI chip-select  |
| ui[2]     | SPI_MOSI  | In  | SPI MOSI         |
| ui[3]     | START 1   | In  | START signal 1   |
| ui[4]     | STOP 1    | In  | STOP signal 1    |
| ui[5]     | START 2   | In  | START signal 2   |
| ui[6]     | STOP 2    | In  | STOP signal 2    |
| ui[7]     | —         | —   | Unused           |
| uo[0]     | SPI_MISO  | Out | SPI MISO         |
| clk       | clock     | In  | input clk signal |
| ena       | enable    | In  | Enable signal    |
| rst_n     | reset     | In  | Reset signal     |





