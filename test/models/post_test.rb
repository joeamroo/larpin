require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @persona = Persona.create!(name: "Test Larper", headline: "Testing | In Character", larping_since: 1.year.ago)
  end

  test "larp_level scores buzzword-free text low" do
    post = @persona.posts.create!(body: "I had a normal day at work.")
    assert post.larp_level < 20
    assert_equal "NPC (for now)", post.larp_tier
  end

  test "larp_level rewards maximum cringe" do
    post = @persona.posts.create!(body: <<~LARP)
      I wasn't going to share this. But my mentor said the world needed it.

      At 4 AM, mid cold plunge, I realized: synergy is just hustle wearing a suit.

      My revenue is up 400%. My discipline? Immeasurable. Let that sink in.

      Agree? 👇

      #Grindset #Blessed #Larpmaxxing
    LARP
    assert post.larp_level >= 80, "expected >= 80, got #{post.larp_level}"
  end

  test "hot sort does not raise" do
    @persona.posts.create!(body: "hello")
    assert_nothing_raised { Post.feed.sorted("hot").to_a }
  end
end

class PollAndMemeTest < ActiveSupport::TestCase
  setup do
    @a = Persona.create!(name: "Poller One", headline: "Asking | Questions", larping_since: 1.year.ago)
    @b = Persona.create!(name: "Voter Two", headline: "Voting | Loudly", larping_since: 1.year.ago)
  end

  test "poll tallies votes into percentages" do
    poll = @a.posts.create!(kind: "poll", body: "A or B?", poll_options: [ "A", "B" ])
    poll.poll_votes.create!(persona: @b, choice: 0)
    results = poll.poll_results
    assert_equal 100, results[0][:pct]
    assert_equal 0, results[1][:pct]
  end

  test "aura moves on grant and dock" do
    assert_equal 0, @a.aura
    @a.add_aura(15)
    @a.add_aura(-20)
    assert_equal(-5, @a.reload.aura)
    assert_equal "Aura in the red", @a.aura_tier
  end

  test "streak increments on consecutive days" do
    @a.touch_streak!
    assert_equal 1, @a.streak
    @a.update!(last_larp_on: Date.current - 1, streak: 4)
    @a.touch_streak!
    assert_equal 5, @a.streak
  end

  test "larpmaxx generator follows the snowclone" do
    text = LarpmaxxGenerator.generate("grindset")
    assert_includes text, "You need to be grindsetmaxxing."
    assert_includes text, "Stop being an NPC"
  end
end
