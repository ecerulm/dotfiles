function bt
  gdb --batch -ex r -ex bt -ex q --args $argv
end
