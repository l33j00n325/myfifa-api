# frozen_string_literal: true

require 'rails_helper'

describe Types::QueryType, type: :graphql do
  subject { described_class }

  let(:user) { create :user }

  graphql_operation <<-GQL
    query fetchTeams {
      teams { id }
    }
  GQL

  graphql_context do
    { current_user: user }
  end

  it 'returns all Teams for user' do
    create_list :team, 3
    create_list :team, 3, user: user
    expect(response_data['teams'].pluck('id'))
      .to be == user.teams.pluck(:id).map(&:to_s)
  end
end
