#encoding:utf-8
module Kernel
    cache = Hash.new
    cache[__FILE__] = loading = Object.new
    define_method(:import) do |relative_path|
      file = File.join(
        File.dirname(caller[0].scan(/(.+):[0-9]+:/)[0][0]),
        *relative_path.split(File::Separator).inject([],&lambda do |sum,part|
          return sum if part == "."
          return sum.push(part) unless part == ".."
          raise("无效路径") unless sum.shift
          return sum
        end)
      )
      raise("loop import") if cache.has_key?(file) && cache[file] == loading
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
import("lambda_call.rb")