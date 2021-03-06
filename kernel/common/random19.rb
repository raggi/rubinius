class Rubinius::Randomizer
  def random_range(limit)
    min, max = limit.max.coerce(limit.min)
    diff = max - min
    diff += 1 if max.kind_of?(Integer) && !limit.exclude_end?
    random(diff) + min
  end

  def random(limit)
    if limit.equal?(undefined)
      random_float
    else
      if limit.kind_of?(Range)
        random_range(limit)
      else
        limit_int = Rubinius::Type.coerce_to limit, Integer, :to_int
        raise ArgumentError, "invalid argument - #{limit}" if limit_int <= 0

        if limit.is_a?(Integer)
          random_integer(limit - 1)
        elsif limit.respond_to?(:to_f)
          random_float * limit
        else
          random_integer(limit_int - 1)
        end
      end
    end
  end
end

class Random
  def self.new_seed
    Rubinius::Randomizer.instance.generate_seed
  end

  def self.srand(seed=undefined)
    if seed.equal? undefined
      seed = Rubinius::Randomizer.instance.generate_seed
    end

    seed = Rubinius::Type.coerce_to seed, Integer, :to_int
    Rubinius::Randomizer.instance.swap_seed seed
  end

  def self.rand(limit=undefined)
    Rubinius::Randomizer.instance.random(limit)
  end

  def initialize(seed=undefined)
    @randomizer = Rubinius::Randomizer.new
    if !seed.equal?(undefined)
      seed = Rubinius::Type.coerce_to seed, Integer, :to_int
      @randomizer.swap_seed seed
    end
  end

  def rand(limit=undefined)
    @randomizer.random(limit)
  end

  def seed
    @randomizer.seed
  end

  def state
    @randomizer.seed
  end
  private :state

  def ==(other)
    return false unless other.kind_of?(Random)
    seed == other.seed
  end

  # Returns a random binary string.
  # The argument size specified the length of the result string.
  def bytes(length)
    length = Rubinius::Type.coerce_to length, Integer, :to_int
    s = ''
    i = 0
    while i < length
      s << @randomizer.random_integer(255).chr
      i += 1
    end

    s
  end
end
