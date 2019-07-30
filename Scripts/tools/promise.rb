eventLoop = []
empty = lambda{}
Promise = Class.new do
  define_method(:initialize) do |callback|
    @resolve = proc{|arr|proc{|callback|arr.push(callback)}}.call(resolve_arr = [])
    @reject = proc{|arr|proc{|callback|arr.push(callback)}}.call(reject_arr = [])
    resolve = reject = nil
    resolve = lambda do |r|
      resolve = reject = @reject = empty
      resolve_arr.each(&@resolve = lambda{|cb|eventLoop.push(lambda{cb.call(r)})})
    end
    reject = lambda do |r|
      resolve = reject = @resolve = empty
      reject_arr.each(&@reject = lambda{|cb|eventLoop.push(lambda{cb.call(r)})})
    end
    eventLoop.push(lambda{callback.call(resolve,reject)})
  end
  define_method(:then) do |cb|
    self.class.new(lambda do |res,rej|
      @resolve.call(lambda do |r|
        return res.call(r) unless ((r = cb.call(r)).class == self.class)
        r.then(res)
        r.catch(rej)
      end)
      @reject.call(rej)
    end)
  end
  define_method(:catch) do |cb|
    self.class.new(lambda do |res,rej|
      @reject.call(lambda do |r|
        return res.call(r) unless ((r = cb.call(r)).class == self.class)
        r.then(res)
        r.catch(rej)
      end)
      @resolve.call(res)
    end)
  end
end
Graphics.module_eval do
  graphics_update = method(:update)
  define_singleton_method(:update) do
    cb = graphics_update.call()
    cb.call while cb = eventLoop.shift
  end
end