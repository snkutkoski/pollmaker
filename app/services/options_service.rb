module OptionsService
  class Option < ServiceModel
    attr_reader :name, :vote_count

    def initialize(name, vote_count, id, errors)
      super(id, errors)
      @name = name
      @vote_count = vote_count
    end

    def self.from_record(record)
      new(record.name, record.votes.count, record.id, record.errors.messages)
    end
  end

  # Casts a vote for the option with the given id.
  def self.vote(option_id)
    option = ::Option.find(option_id)
    vote = Vote.new(option: option)
    vote.save
    poll = PollsService.find(option.poll_id)
    ActionCable.server.broadcast(
      "poll_#{option.poll_id}",
      poll: poll.as_json(include: :options))
    poll
  end
end
