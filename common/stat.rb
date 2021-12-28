class Stats
  def initialize(name, *views)
    @start = Time.now
    @name = name
    @views = *views.to_a
    @next = 2
  end
  
  def clock
    @start = Time.now
  end

  def humanize(size, precision)
    case
      when size == 1 
        "1"
      when size < 1e3 
         "%d " % size
      when size < 1e6 
         "%.#{precision}f K" % (size / 1e3)
      when size < 1e9 
        "%.#{precision}f M" % (size / 1e6)
      else
        "%.#{precision}f G" % (size / 1e9)
    end
  end

  def refresh?
    if @input == @next.ceil
      @next = @input*1.2
      true
    else
      false
    end
  end

  def show(input,output)
    @input, @output = input, output
    if self.refresh?
      $stderr.print "\r => #{@name}:".ljust(16)
      @views.each do |v|
        $stderr.print self.send(v)
      end
    end
  end

  def finish(input,output)
    @input, @output = input, output
    $stderr.print "\r => #{@name}:".ljust(16)
    @views.each do |v|
      $stderr.print self.send(v)
    end
    $stderr.puts ""
  end

  def elapsed 
    "Elapsed:".ljust(10) + "#{(Time.now - @start).round(2)} s".ljust(10)
  end
  
  def dropped 
    "Dropped:".ljust(10) + "#{humanize(@input - @output, 1)}".ljust(10)
  end

  def input  
    "In:".ljust(10) + "#{humanize(@input,1)}".ljust(10)
  end
  
  def output 
    "Out:".ljust(10) + "#{humanize(@output,1)}".ljust(10)
  end

  def ratio 
    "Ratio:".ljust(10) + "#{100*(@output.to_f/@input).round(2)} %".ljust(10)
  end
end

