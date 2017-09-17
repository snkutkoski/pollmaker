class Vote < ApplicationRecord
  belongs_to :option

  def self.vote_counts(options)
    counts = where(option: options).group(:option_id).count
    options.reduce({}) do |hash, option|
      hash[option.id] = 0
      hash
    end.merge(counts)
  end
end
