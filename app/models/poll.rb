# Polls pose questions with at least two pre-defined options that can be voted for.
class Poll < ApplicationRecord
  has_many :options

  validates_presence_of :question

  validate :two_or_more_options
  validate :unique_options

  private

  def two_or_more_options
    errors.add(:options, 'at least two required') unless options.size >= 2
  end

  def unique_options
    option_names = options.map(&:name)
    errors.add(:options, 'must be unique') unless option_names.uniq.size == option_names.size
  end
end
