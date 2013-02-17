# encoding: utf-8

require 'spec_helper'

describe PayrollTasksController do
  render_views

  before(:each) do
    @base_title = 'Hravé Mzdy - online platová a mzdová agenda'
  end

  describe "GET 'new'" do
    it 'returns http success' do
      get 'new'
      response.should be_success
    end

    it 'should have the right title' do
      get 'new'
      response.body.should have_selector('title',
                                         :text => @base_title + ' | Start a new payroll task')
    end
  end


end
