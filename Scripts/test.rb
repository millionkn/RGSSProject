module Kernel
  loadData = method(:load_data);
  define_method(:load_data) do |str|
    loadData.call(str.gsub(/^Data\/BT_/){"test/battle/BT_"})
  end
end
