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
