def Bench.run
  i = 0
  while @should_run
    # string#capitalize_bang(...)
    raise "string#capitalize_bang(...) benchmark is not implemented"
    i += 1
  end

  @iterations = i
end
