module PollsService
  class Poll < ServiceModel
    attr_reader :question, :options

    def initialize(question, options, id, errors)
      super(id, errors)
      @question = question
      @options = options
    end

    def self.from_record(record)
      counts = Vote.vote_counts(record.options)

      options = counts.map do |option_id, count|
        option_record = record.options.find { |o| o.id == option_id }
        OptionsService::Option.new(option_record.name, count, option_record.id, option_record.errors)
      end

      new(record.question, options, record.id, record.errors.messages)
    end

    # Override default 'valid?' method to check nested options for errors
    def valid?
      super && options.all?(&:valid?)
    end
  end

  # Creates a new Poll with the specified question and option names in params.
  #
  # params - Hash in the following structure:
  #          {
  #            question: <String>,
  #            options: [{name: <String>}, ...]
  #          }
  #
  # Returns the created Poll service object. The Poll can have errors, indicating the it was invalid and not saved.
  def self.create(params)
    options = params[:options].map do |option_params|
      Option.new(name: option_params[:name])
    end

    poll_record = ::Poll.create(question: params[:question], options: options)

    PollsService::Poll.from_record(poll_record)
  end

  # Finds the Poll with the given id.
  def self.find(id)
    begin
      record = ::Poll.find(id)
      PollsService::Poll.from_record(record)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
