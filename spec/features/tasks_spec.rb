require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  scenario 'has the right title' do
    visit '/'
    expect(page).to have_title 'Memoryboard'
  end
end
