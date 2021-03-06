# solutions to project euler problems
class Euler
  def self.euler001
    (1...1000).select{|n| n % 3 == 0 || n % 5 == 0}.reduce(:+)
  end

  def self.euler002
    fibs_upto(4_000_000).select{|n| n.even?}.reduce(:+)
  end

  def self.euler003
    primes_upto(100_000).select{|n| 60_0851_475_143 % n == 0}.max
  end

  def self.euler004
    possibilities = []
    (100..999).each do |a|
      (a+1..999).each do |b|
        if palindrome? a*b
          possibilities.push(a*b)
        end
      end
    end
    possibilities.max
  end

  def self.euler005
    (1..20).reduce(:lcm)
  end

  def self.euler006
    (1..100).reduce(:+) ** 2 - (1..100).map{|n| n**2}.reduce(:+)
  end

  def self.euler007
    primes_upto(1_000_000)[10_000]
  end

  def self.euler008
    file = File.open('../resources/8.txt')
    number = file.lines.reduce(:+)
    file.close
    by_five = number.split(//).map(&:to_i).each_cons(5)
    by_five.map{|n| n.reduce(:*)}.max
  end

  def self.euler009
    (1..1000).each do |a|
      (a+1..1000).each do |b|
        c = 1000 - a - b
        if pythagorean_triplet?(a,b,c)
          return a * b * c
        end
      end
    end
  end

  def self.euler010
    primes_upto(2_000_000).reduce(:+)
  end

  def self.euler011
    file = File.open('../resources/11.txt')
    grid = file.lines.map{|line| line.split(' ').map(&:to_i)}
    file.close

    options = []

    (0...20).each do |row|
      (0...20).each do |col|
        options.push(across(grid,row,col))
        options.push(down(grid,row,col))
        options.push(diagonal1(grid,row,col))
        options.push(diagonal2(grid,row,col))
      end
    end

    options.max
  end

  def self.euler012
    require 'prime'

    i = 2
    factors = 0
    triangle = 0

    while factors < 500
      triangle = i * (i + 1) / 2
      powers   = triangle.prime_division.transpose[1]
      factors  = powers.map{|n| n + 1}.reduce(:*)
      i += 1
    end

    triangle
  end

  def self.euler013
    file = File.open('../resources/13.txt')
    result = file.lines.map(&:to_i).reduce(:+).to_s[0..9]
    file.close
    result
  end

  def self.euler014
    vals = {}
    vals[1] = 0

    (1..1_000_000).each do |n|
      i = 0
      number = n

      until vals.has_key?(number)
        number = collatz(number)
        i += 1
      end

     vals[n] = vals[number] + i
    end

    vals.max_by{|_,v|v}[0]
  end

  def self.euler015
    limit = 21
    grid = Array.new(limit,Array.new(limit,0))

    (0...limit).each do |row|
      (0...limit).each do |col|
        grid[row][col] = if row == 0 && col == 0
          1
        elsif row != 0 && col != 0
          grid[row-1][col] + grid[row][col-1]
        elsif row == 0
          grid[row][col-1]
        elsif col == 0
          grid[row-1][col]
        end
      end
    end

    grid.last.last
  end

  def self.euler016
    (2 ** 1000).to_s.chars.map(&:to_i).reduce(:+)
  end

  def self.euler017
    ones =      { 1 => 'One',           2 => 'Two',           3 => 'Three',
                  4 => 'Four',          5 => 'Five',          6 => 'Six',
                  7 => 'Seven',         8 => 'Eight',         9 => 'Nine' }
    teens =     { 1 => 'Eleven',        2 => 'Twelve',        3 => 'Thirteen',
                  4 => 'Fourteen',      5 => 'Fifteen',       6 => 'Sixteen',
                  7 => 'Seventeen',     8 => 'Eighteen',      9 => 'Nineteen' }
    tens =      { 1 => 'Ten',           2 => 'Twenty',        3 => 'Thirty',
                  4 => 'Forty',         5 => 'Fifty',         6 => 'Sixty',
                  7 => 'Seventy',       8 => 'Eighty',        9 => 'Ninety' }
    hundreds =  { 1 => 'OneHundred',    2 => 'TwoHundred',    3 => 'ThreeHundred',
                  4 => 'FourHundred',   5 => 'FiveHundred',   6 => 'SixHundred',
                  7 => 'SevenHundred',  8 => 'EightHundred',  9 => 'NineHundred' }
    thousands = { 1 => 'OneThousand',   2 => 'TwoThousand',   3 => 'ThreeThousand',
                  4 => 'FourThousand',  5 => 'FiveThousand',  6 => 'SixThousand',
                  7 => 'SevenThousand', 8 => 'EightThousand', 9 => 'NineThousand' }

    ones.each      {|k,v| ones[k]      = v.length}
    teens.each     {|k,v| teens[k]     = v.length}
    tens.each      {|k,v| tens[k]      = v.length}
    hundreds.each  {|k,v| hundreds[k]  = v.length}
    thousands.each {|k,v| thousands[k] = v.length}
    a = 'and'.length

    size = lambda do |n|
      case
      when n < 10                      then ones[n]
      when n < 100 && n > 10 && n < 20 then teens[n%10]
      when n < 100 && n % 10 == 0      then tens[n/10]
      when n < 100                     then tens[n/10] + size.call(n%10)
      when n < 1000 && n % 100 == 0    then hundreds[n/100]
      when n < 1000                    then hundreds[n/100] + a + size.call(n%100)
      when n < 10000 && n % 1000 == 0  then thousands[n/1000]
      else
      end
    end

    (1..1000).map{|number| size.call(number)}.reduce(:+)
  end

  def self.euler018
    file = File.open('../resources/18.txt')
    grid = file.lines.map{|line| line.split(' ').map(&:to_i)}
    file.close

    (0..grid.last.size).reverse_each do |col|
      (0..grid.size).reverse_each do |row|
        begin
          grid[row][col] += [grid[row+1][col], grid[row+1][col+1]].max
        rescue
          next
        end
      end
    end

    grid[0][0]
  end

  def self.euler019
    require 'Date'
    range = Date.new(1901,1,1)..Date.new(2000,12,31)
    range.select{|date| date.mday == 1}.count(&:sunday?)
  end

  def self.euler020
    factorial(100).to_s.chars.map(&:to_i).reduce(:+)
  end

  def self.euler021
    (1...10_000).select{|n| amicable?(n)}.reduce(:+)
  end

  def self.euler022
    file = File.open('../resources/22.txt')
    items = file.lines.reduce(:+).gsub('"','').split(',')
    file.close
    items = items.sort
    items = items.map{|name| word_value(name)}
    items = items.each_with_index.map{|v,i| v * (i+1)}
    items.reduce(:+)
  end

  def self.euler023
    require 'set'
    range = 1..28_123
    abundant_nums = range.select{|n| abundant? n}
    abundant_sums = []

    (0...abundant_nums.length).each do |a|
      (a...abundant_nums.length).each do |b|
        abundant_sums[abundant_nums[a]+abundant_nums[b]] = true
      end
    end

    range.reduce{|sum,n| sum + (abundant_sums[n] ? 0 : n)}
  end

  def self.euler024
    ('0'..'9').to_a.permutation(10).to_a[1_000_000-1].reduce(:+)
  end

  def self.euler025
    fibs_upto(10 ** 1001).index{|fib| fib.to_s.length == 1000} + 1
  end
end


# helper methods and utilities
class Euler
  private

  def self.divisor_sum (n)
    (2..Math.sqrt(n)).reduce(1) do |sum, element|
      if n % element == 0
        sum + element + (n/element == element ? 0 : n/element)
      else
        sum
      end
    end
  end

  def self.abundant? (n)
    divisor_sum(n) > n
  end

  def self.amicable? (a, b = divisor_sum(a))
    divisor_sum(b) == a && a != b
  end

  def self.word_value (word)
    word.chars.map{|char| char.ord - 64}.reduce(:+)
  end

  def self.factorial (n)
    (1..n).reduce(:*)
  end

  def self.product_of_4 (grid, row, col, ver, hor)
    begin
      grid[row + 0 * ver][col + 0 * hor] *
      grid[row + 1 * ver][col + 1 * hor] *
      grid[row + 2 * ver][col + 2 * hor] *
      grid[row + 3 * ver][col + 3 * hor]
    rescue
      0
    end
  end

  def self.across (grid, row, col)
    product_of_4(grid,row,col,0,1)
  end

  def self.down (grid, row, col)
    product_of_4(grid,row,col,1,0)
  end

  def self.diagonal1 (grid, row, col)
    product_of_4(grid,row,col,1,1)
  end

  def self.diagonal2 (grid, row, col)
    product_of_4(grid,row,col,1,-1)
  end

  def self.collatz (n)
    if n.even?
      n/2
    else
      3*n + 1
    end
  end

  def self.pythagorean_triplet? (a,b,c)
    a**2 + b**2 == c**2
  end

  def self.palindrome? (item)
    item.to_s == item.to_s.reverse
  end

  def self.fibs_upto (limit)
    fibs = [1]
    i = 2
    current = 1

    while current <= limit do
      fibs.push(current)
      current = fibs[i-1] + fibs[i-2]
      i += 1
    end

    fibs
  end

  # using sieve of Atkin approach
  def self.primes_upto (limit)
    is_prime    = Array.new(limit+1, false)
    sqrt        = Math.sqrt(limit).round.to_i
    is_prime[2] = true
    is_prime[3] = true

    (1..sqrt).each do |x|
      (1..sqrt).each do |y|
        a = 4*x*x + y*y
        b = 3*x*x + y*y
        c = 3*x*x - y*y
        if a <= limit && (a % 12 == 1 || a % 12 == 5)
          is_prime[a] = !is_prime[a]
        end
        if b <= limit && b % 12 == 7
          is_prime[b] = !is_prime[b]
        end
        if x > y && c <= limit && c % 12 == 11
          is_prime[c] = !is_prime[c]
        end
      end
    end

    (5..sqrt).each do |n|
      if is_prime[n]
        i = 1
        while i*n*n < limit do
          is_prime[i*n*n] = false
          i += 1
        end
      end
    end

    primes = []

    (0..limit).each do |i|
      if is_prime[i]
        primes.push(i)
      end
    end

    primes
  end
end