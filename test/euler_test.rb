require 'test/unit'
require 'timeout'
require '../lib/euler'

class EulerTest < Test::Unit::TestCase
  def test001; test_euler(:euler001,         233_168); end
  def test002; test_euler(:euler002,       4_613_732); end
  def test003; test_euler(:euler003,           6_857); end
  def test004; test_euler(:euler004,         906_609); end
  def test005; test_euler(:euler005,     232_792_560); end
  def test006; test_euler(:euler006,      25_164_150); end
  def test007; test_euler(:euler007,         104_743); end
  def test008; test_euler(:euler008,          40_824); end
  def test009; test_euler(:euler009,      31_875_000); end
  def test010; test_euler(:euler010, 142_913_828_922); end
  def test011; test_euler(:euler011,      70_600_674); end
  def test012; test_euler(:euler012,      76_576_500); end
  def test013; test_euler(:euler013,   5_537_376_230); end
  def test014; test_euler(:euler014,         837_799); end
  def test015; test_euler(:euler015, 137_846_528_820); end
  def test016; test_euler(:euler016,           1_366); end
  def test019; test_euler(:euler019,             171); end
  def test020; test_euler(:euler020,             648); end
  def test024; test_euler(:euler024,   2_783_915_460); end
  def test025; test_euler(:euler025,           4_782); end

  private

  def test_euler (method, answer)
    time = Time.now
    result = timeout(60){ Euler.send(method) }
    assert_equal(answer.to_s, result.to_s)
    puts "test #{method} took #{Time.now-time} seconds."
  end
end
