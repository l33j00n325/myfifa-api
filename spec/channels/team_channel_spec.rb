# frozen_string_literal: true

require 'rails_helper'

describe TeamChannel, type: :channel do
  let(:user) { create :user }
  let(:team) { create :team, user: user }

  before do
    # initialize connection with identifiers
    stub_connection current_user: user
  end

  it 'subscribes to a stream when team id is provided' do
    subscribe(id: team.id)
    expect(subscription).to have_stream_for(team)
  end

  it 'does not subscribe to a stream for Team not bound to user' do
    team = create :team
    expect { subscribe(id: team.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
