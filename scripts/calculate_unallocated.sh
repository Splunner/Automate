#!/bin/bash

# Calculate unallocated space for /dev/sda and print detailed sizes for each partition

# Total and allocated size calculation for unallocated space
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT -b | awk '
  BEGIN {total_size = 0; allocated_size = 0}
  {
    if ($3 == "disk") { 
      total_size = $2; 
    }
    if ($3 == "part") {
      allocated_size += $2; 
    }
  }
  END {
    unallocated_size = total_size - allocated_size;
    print "Total size of sda: " total_size " bytes, " total_size/1024 " KB, " total_size/1048576 " MB, " total_size/1073741824 " GB";
    print "Allocated size: " allocated_size " bytes, " allocated_size/1024 " KB, " allocated_size/1048576 " MB, " allocated_size/1073741824 " GB";
    print "Unallocated size: " unallocated_size " bytes, " unallocated_size/1024 " KB, " unallocated_size/1048576 " MB, " unallocated_size/1073741824 " GB";
  }'

echo ""

# Display size of each partition in bytes, KB, MB, GB
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT -b | awk '{ if ($3 != "TYPE") { print $1, $2 " bytes", $2/1024 " KB", $2/1048576 " MB", $2/1073741824 " GB" } }'
