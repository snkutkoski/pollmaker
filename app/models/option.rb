# Options can be voted for. Option names must be unique for each Poll.
class Option < ApplicationRecord
  belongs_to :poll

  validates :name, presence: true, uniqueness: {scope: :poll_id}

  validates :vote_count, presence: true
end
