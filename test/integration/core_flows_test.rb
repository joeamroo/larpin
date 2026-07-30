require "test_helper"

class CoreFlowsTest < ActionDispatch::IntegrationTest
  test "first visit mints a persona and renders the feed" do
    get root_path
    assert_response :success
    assert Persona.where(is_bot: false).any?
  end

  test "posting a larp works" do
    get root_path
    assert_difference "Post.count", 1 do
      post posts_path, params: { post: { body: "I closed a deal in a dream.", kind: "post" } }
    end
    assert_redirected_to root_path
  end

  test "search is gated behind premium, which is free, which is the joke" do
    get root_path
    get search_path, params: { q: "synergy" }
    assert_redirected_to premium_path

    post premium_activate_path
    get search_path, params: { q: "synergy" }
    assert_response :success
  end

  test "easy apply instantly rejects" do
    get root_path
    poster = Persona.create!(name: "Recruiter Bot", headline: "Hiring | Not Really", larping_since: 1.year.ago)
    job = poster.jobs.create!(title: "Chief Vibes Officer", company: "Synergy Labs")
    assert_difference "JobApplication.count", 1 do
      post apply_job_path(job)
    end
    follow_redirect!
    assert_response :success
  end

  test "claiming an account and signing back in" do
    get root_path
    post signup_path, params: { persona: { name: "Baron Von Test", email: "baron@test.larp", password: "sixchars" } }
    assert_redirected_to root_path
    assert Persona.exists?(email: "baron@test.larp")

    delete logout_path
    post login_path, params: { email: "baron@test.larp", password: "sixchars" }
    assert_redirected_to root_path
  end
end
