#encoding:utf-8
module Kernel
    cache = Hash.new
    cache[__FILE__] = loading = Object.new
    define_method(:import) do |relative_path|
      _caller = caller(1)
      file = File.join(
        *relative_path
        .split(File::Separator)
        .inject(
          File.dirname(caller[0].scan(/(.+):[0-9]+:/)[0][0]).split(File::Separator),
          &lambda do |sum,part|
          return sum if part == "."
          return sum.push(part) unless part == ".."
          raise(LoadError,"无效路径",_caller) unless sum.pop()
          return sum
        end)
      )
      raise(LoadError,"loop import",_caller) if cache.has_key?(file) && cache[file] == loading
      cache[file] = loading
      require(file)
      cache[file] = nil if cache[file]==loading
      cache[file]
    end
    define_method(:export) do |object|
      file = caller[0].scan(/(.+):[0-9]+:/)[0][0]
      cache[file] = object if cache[file] == loading
    end
end
import("./inner.rb")
import("./view.rb")
import("./Nuri Yuri's Tilemap.rb")