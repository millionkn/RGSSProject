class Proc
  def call(*args,&block)
    if(0>need = self.arity)
      need = 0 - need - 1
      args = args[0,need < args.length ? args.length : need]
    else
      args = args[0,need]
    end
    self.yield(*args,&block)
  end
end
