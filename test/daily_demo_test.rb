require_relative 'test_helpers'

describe "Demo" do
  before do
  end

  def dump_log(feed)
    puts ""
    puts "Log:"
    last_time = nil
    feed.log.each do |i|
      # t = nil
      # if last_time
      #   t = (i.timestamp - last_time)
      #   if t > 60 * 60 * 24
      #     t = (t / 60.0).to_s + ' days'
      #   elsif t > 60 * 60
      #     t = (t / 60.0).to_s + ' hrs'
      #   elsif t < 60 * 60
      #   else
      #     t = (t).to_s + ' sec'
      #     t = (t / 60.0).to_s + ' min'
      #   end
      # else
      #   t = i.timestamp
      # end
      t = i.timestamp
      puts "#{i.name}\t#{t}"
      last_time = i.timestamp
    end

  end
  
  describe "Foo" do
    it "works" do
      require 'date'
      feed = Feed.new(:start_time => Date.today.to_time, :max_current_time => 10.days)
      feed
        .when(:sleep)
        .wait(7.hours..9.hours)
        .then(:wake)

      feed.wait(0.minute).then(:wake)
      feed.when(:wake).wait(15.hours..18.hours).then(:sleep)
      
      feed.when(:wake).wait(3.minutes..20.minutes).then(:breakfast)
      feed.when(:breakfast).then(:juice)
      
      feed.when(:breakfast).wait(4.hours..5.hours).then(:lunch)
      feed.when(:lunch).wait(6.hours..8.hours).then(:dinner)

      milk = 5
      feed.when(:breakfast).then do |f|
        if milk > 0
          f.record :cerial
          milk -= 1
        else
          f.record :pop_tart
          f.wait(10.hours).then(:get_milk)
          f.when(:get_milk).then() do |ff|
            milk = 5
          end
        end
      end

      
      feed.play
      dump_log feed
    #   e = TriggerOnceEvent.new(@feed, :nap)
    #   assert_equal [], @feed.subscribers

    #   @feed.subscribe(e)
    #   e.fire
    #   assert_equal [], @feed.subscribers
    end
  end
end
