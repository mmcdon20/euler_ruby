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

puts Euler.euler018