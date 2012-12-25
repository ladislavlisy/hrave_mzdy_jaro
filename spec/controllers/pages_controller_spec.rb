# encoding: utf-8

require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Hravé Mzdy - online platová a mzdová agenda"
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.body.should have_selector("title",
                                    :text => @base_title + " | Home")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.body.should have_selector("title",
                                         :text => @base_title + " | About")
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.body.should have_selector("title",
                                         :text => @base_title + " | Help")
    end
  end

end
