# Options can be voted for. Option names must be unique for each Poll.
class Option < ApplicationRecord
  belongs_to :poll

  has_many :votes

  validates :name, presence: true, uniqueness: {scope: :poll_id}
end
