"""
This script is designed to simulate the memory manipulation performed by the logical architecture.
It takes command line arguments to specify the starting address, the values count, and values
themself to be written in memory. The values can be provided in either decimal or hexadecimal 
format, with hexadecimal values starting with '0x'. The script then normalizes the arguments, 
checks their validity, and processes the memory according to the logical architecture algorithm.
Finally, it prints the memory content before and after processing.

Script usage:
python main.py --startAddress 0x0000 --valuesCount 0x000 --values 0x00 0x00 0x00 0x00
Each value can be in decimal or hexadecimal format (it must start with 0x if so).
"""

import argparse


def parse_arguments():
    """Parse arguments from command line."""
    parser = argparse.ArgumentParser(description="""Script to simulate the memory manipulation \
                                     done by the logical architecture.""")
    parser.add_argument('--startAddress', help='Working memory starting address.',
                        type=str, required=True)
    parser.add_argument('--valuesCount', help='Number of values to be written in memory.',
                        type=str, required=True)
    parser.add_argument('--values',  help='Values to be written in memory.',
                        nargs='+', type=str, required=True)
    args = parser.parse_args()
    return args


def normalize_arguments(args):
    """Normalize arguments got by the user using parse_arguments."""
    if args.startAddress.startswith('0x'):
        args.startAddress = int(args.startAddress, 16)
    else:
        args.startAddress = int(args.startAddress)
    if args.valuesCount.startswith('0x'):
        args.valuesCount = int(args.valuesCount, 16)
    else:
        args.valuesCount = int(args.valuesCount)
    for i, value in enumerate(args.values):
        if value.startswith('0x'):
            args.values[i] = int(value, 16)
        else:
            args.values[i] = int(value)
    return args


def check_arguments(args):
    """Check if the arguments provided by the user are valid"""
    # Valid startAddress size: 0 <= startAddress <= 0xFFFF
    if not 0 <= args.startAddress <= 0xFFFF:
        raise ValueError(
            'Invalid startAddress. It must be between 0 and 0xFFFF.')
    # Valid valuesCount size: 0 <= valuesCount <= 0x3FF
    if not 0 <= args.valuesCount <= 0x3FF:
        raise ValueError(
            'Invalid valuesCount. It must be between 0 and 0x3FF.')
    # Valid value size: 0 <= values[i] <= 0xFF
    for value in args.values:
        if not 0 <= value <= 0xFF:
            raise ValueError(
                'Invalid value. Each value must be between 0 and 0xFF.')
    # Memory space needed: startAddress + (2 * valuesCount) - 1 <= 0xFFFF
    if args.startAddress + (2 * args.valuesCount) - 1 > 0xFFFF:
        raise ValueError("""Insufficient memory space. \
                         startAddress + (2 * valuesCount) - 1 must be less than or \
                         equal to 0xFFFF.""")
    # Check if enough values are provided
    if len(args.values) != args.valuesCount:
        raise ValueError('Insufficient values provided.')


def main_processing(machine_start_address, values_to_write):
    """Main processing of the script."""
    # Initialize all memory values to 0x00
    machine_ram = [0x00] * 0xFFFF
    # Initialize arrays to store the pre- and post-processing results
    STR = []
    END = []
    # Write provided values in memory
    for i, value in enumerate(values_to_write):
        machine_ram[machine_start_address + i * 2] = value
    # Print address and memory value from machine_start_address to
    #    machine_start_address + (len(values_to_write) * 2)
    print('Memory content before processing:')
    for i in range(machine_start_address, machine_start_address + len(values_to_write) * 2):
        print(f'Address: 0x{i:04X} Value: 0x{machine_ram[i]:02X}')
        STR.append(machine_ram[i])
    print('')

    # Our logical architecture implementation use the following algorithm
    machine_last_valid_value = 0x00
    machine_credibility_counter = 0x00
    for i in range(machine_start_address, machine_start_address + len(values_to_write) * 2, 2):
        print(f'Working on address: 0x{i:04X}, value: 0x{machine_ram[i]:02X}')
        if machine_ram[i] == 0x00:
            machine_ram[i] = machine_last_valid_value
            if machine_last_valid_value != 0x00:
                if machine_credibility_counter != 0x00:
                    machine_credibility_counter = machine_credibility_counter - 1
            machine_ram[i + 1] = machine_credibility_counter
        else:
            machine_credibility_counter = 0x1F
            machine_ram[i + 1] = machine_credibility_counter
            machine_last_valid_value = machine_ram[i]
    print('')

    # Print address and memory value from machine_start_address to
    #   machine_start_address + (len(values_to_write) * 2)
    print('Memory content after processing:')
    for i in range(machine_start_address, machine_start_address + len(values_to_write) * 2):
        print(f'Address: 0x{i:04X} Value: 0x{machine_ram[i]:02X}')
        END.append(machine_ram[i])
    print('')

    # Print the data needed to build a compliant testbench.
    print("ADD:", machine_start_address)
    print("K:", len(values_to_write))
    print("STR:", STR)
    print("END:", END)


def main():
    """Main function."""
    # Parse command line arguments
    args = parse_arguments()
    # Normalize arguments
    args = normalize_arguments(args)
    # Check argument validity
    check_arguments(args)
    # Process memory
    main_processing(args.startAddress, args.values)


if __name__ == "__main__":
    main()
